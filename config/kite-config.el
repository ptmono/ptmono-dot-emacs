
;(require 'package-config)

(defvar d-kite/selection-name nil)
(defvar d-kite/selection-buffer-name nil)

(defun d-test-chromium/set ()
  "Start chromium with 'google-chrome --remote-debugging-port=922'
Then execute.
"
  (interactive)
  (d-kite/set))

(defun d-kite/set ()
  "Start chromium with 'google-chrome --remote-debugging-port=922'
Then execute.
"
  (interactive)
  (kite-console nil)
  
  (let* ((buffer-name (buffer-name))
	 (selection-name (replace-regexp-in-string "*kite console " "" (buffer-name)))
	 (selection-name (replace-regexp-in-string "*$" "" selection-name)))
    (setq d-kite/selection-name selection-name)
    (setq d-kite/selection-buffer-name buffer-name)

    (defun d-test ()
      ""
      (interactive)

      (condition-case nil
	  (kill-buffer d-kite/selection-buffer-name)
	(error nil))

      (d-kite-console d-kite/selection-name)
      (insert "location.reload()")
      (kite-console-send-input-or-visit-object)

      (sleep-for 1)

      (kill-buffer d-kite/selection-buffer-name)
      (d-kite-console d-kite/selection-name)
      
      )
    ))


(defun d-kite-console (selection)
  "Go to the Kite Console buffer for the session specified by
PREFIX.  Session and buffer are created as needed.  An existing
session is reused if possible, unless a prefix argument of (4) is
given in which case a new session is established.  With a prefix
of (16), Kite will prompt for remote host name and port.  With a
numeric prefix (1 or higher), Kite will reuse the Nth session,
where sessions are counted in the order in which they were
created."

  (d-kite-maybe-goto-buffer selection nil 'console))


(defun d-kite-maybe-goto-buffer (selection prefix type)
  "Find a session using `kite--find-default-session' and the
given PREFIX argument.  If this results in a vaid session, switch
to the buffer of the given TYPE for that session, creating it if
it doesn't exist yet."
  (let ((session (d-kite--find-default-session selection prefix)))
    (when session
      (kite--get-buffer-create session type))))



(defun d-kite--find-default-session (selection prefix)
  "Reuse an existing Kite session or create a new one, depending
on PREFIX.

If PREFIX is `(4)', create a new session for the default host and
port.

If PREFIX is `(16)', create a new session, prompting for host and
port.

Otherwise, if PREFIX is a number, use the session with that
index.

Otherwise, if any sessions are already open, reuse the most
recently used session.

Otherwise, create a new session using default host and port."
  (cond
   ((equal '(4) prefix)
    (d-kite-connect selection))
   ((equal '(16) prefix)
    (d-kite-connect
     selection
     (read-from-minibuffer "Host: "
                           kite-default-remote-host
                           nil
                           nil
                           'kite-remote-host-history
                           kite-default-remote-host)
     (let ((port (read-from-minibuffer
                  "Port: "
                  (number-to-string kite-default-remote-port)
                  nil
                  t
                  'kite-remote-port-history
                  (number-to-string kite-default-remote-port))))
       (unless (and (numberp port)
                    (>= port 1)
                    (<= port 65535))
         (error "Port must be a number between 1 and 65535"))
       port)))
   ((numberp prefix)
    (unless (and (>= prefix 1)
                 (<= prefix (length kite-active-session-list)))
      (error "No such kite session index: %s" prefix))
    (websocket-url
     (kite-session-websocket
      (nth (- prefix 1) kite-active-session-list))))
   ((and (not (null kite-most-recent-session))
         (gethash kite-most-recent-session kite-active-sessions))
    kite-most-recent-session)
   ((> 0 (hash-table-count kite-active-sessions))
    (let (random-session)
      (maphash (lambda (key value)
                 (unless random-session
                   (setq random-session key)))
               kite-active-sessions)))
   (t
    (d-kite-connect selection))))



(defun d-kite-connect (selection &optional host port)
  "Connect to the remote debugger instance running on the given
HOST and PORT using HTTP, retrieve a list of candidate tabs for
debugging, prompt the user to pick one, and create a new session
for the chosen tab.  Return the new session or nil if the user
enters the empty string at the prompt."
  (let* ((url-request-method "GET")
         (url-package-name "kite.el")
         (url-package-version "0.1")
         (url-http-attempt-keepalives nil)
         (use-host (or host kite-default-remote-host))
         (use-port (or port kite-default-remote-port))
         (url
          (url-parse-make-urlobj
           "http" nil nil use-host use-port "/json")))
    (with-current-buffer (url-retrieve-synchronously url)
      (goto-char 0)
      (if (and (looking-at "HTTP/1\\.. 200")
               (re-search-forward "\n\n" nil t))
          (let* ((debugger-tabs (let ((json-array-type 'list)
                                      (json-object-type 'plist))
                                  (json-read)))
                 (available-debuggers (make-hash-table))
                 (available-strings (make-hash-table :test 'equal))
                 (completion-strings (make-hash-table :test 'equal))
                 (completion-candidates nil))

            ;; Gather debuggers from server response

            (mapc (lambda (el)
                    (when (plist-member el :webSocketDebuggerUrl)
                      (puthash
                       (plist-get el :webSocketDebuggerUrl)
                       (cons el nil)
                       available-debuggers)))
                  debugger-tabs)

            ;; Gather debuggers currently open

            (maphash
             (lambda (websocket-url kite-session)
               (puthash
                websocket-url
                `((:webSocketDebuggerUrl
                   ,websocket-url
                   :thumbnailUrl ,(kite-session-page-thumbnail-url
                                   kite-session)
                   :faviconUrl ,(kite-session-page-favicon-url
                                 kite-session)
                   :title ,(kite-session-page-title
                            kite-session)
                   :url ,(kite-session-page-url kite-session))
                  . ,kite-session)
                available-debuggers))
             kite-active-sessions)

            ;; For each human readable identifier (url or title), see
            ;; if it is ambiguous

            (flet
                ((add-item (item url)
                           (let ((existing (gethash item
                                                    available-strings
                                                    '(0))))
                 (puthash item
                          (cons (1+ (car existing))
                                (cons url (cdr existing)))
                          available-strings))))

             (maphash
              (lambda (key value)
                (let ((url (plist-get (car value) :url))
                      (title (plist-get (car value) :title))
                      (websocket-url
                       (plist-get (car value) :webSocketDebuggerUrl)))
                  (add-item url websocket-url)
                  (when (not (equal title url))
                    (add-item title websocket-url))))
              available-debuggers))

            ;; Final pass, disambiguate and rearrange

            (flet
             ((disambiguate
               (string websocket-url)
               (let ((existing
                      (gethash string available-strings)))
                 (if (<= (car existing) 1)
                     string
                   (concat string
                           " ("
                           (substring websocket-url
                                      (length (kite--longest-prefix
                                               (cdr existing))))
                           ")")))))

             (maphash (lambda (key value)
                        (let ((url (plist-get (car value) :url))
                              (title (plist-get (car value) :title))
                              (websocket-url (plist-get
                                              (car value)
                                              :webSocketDebuggerUrl)))

                          (puthash (disambiguate url websocket-url)
                                   value
                                   completion-strings)
                          (puthash (disambiguate title websocket-url)
                                   value
                                   completion-strings)))
                      available-debuggers))

            ;; Map to keys

            (maphash (lambda (key value)
                       (setq completion-candidates
                             (cons key completion-candidates)))
                     completion-strings)

            (let ((selection selection))
              (when (> (length selection) 0)
                (kite--connect-webservice
                 (car (gethash selection completion-strings)))
                (plist-get (car (gethash selection
                                         completion-strings))
                           :webSocketDebuggerUrl))))
        (error "\
Could not contact remote debugger at %s:%s, check host and port%s"
               use-host
               use-port
               (if (> (length (buffer-string)) 0)
                   (concat ": " (buffer-string)) ""))))))
