
;;; === TODO
;;; --------------------------------------------------------------
;; 0909271026 d-ebook-index-create is using dired-mode. So ls -l results
;; is required. It has long lines. I want to create my own mode to see
;; ebook_list.

;; 0910231405 Fix d-dica-resize-image


(require 'd-library)
(require 'outline)

;;; === Startup
;;; --------------------------------------------------------------
;; It will move the backup files into trash folder. It require some delay.
;; FIXME: consider cron

;; (shell-command "find /home/ptmono/Desktop/Documents/ -regex \".*~$\" ! -regex \".*myscript.*\" -exec mv {} /tmp/trash/ \\;")


;;; === For insering current time
;;; --------------------------------------------------------------
(defvar d-myel-previous-time nil)

(defun d-insert-time ()
  "Inserting current time with \"\#\" e.g #0606300955 and rememberf this"
  (interactive)
  (let* ((current-time (d-create-citation)))
    (progn
      (kill-new current-time)
      (yank)
      (setq d-myel-previous-time current-time))))

(defun d-create-anchor ()
  (concat "#" (d-create-citation)))

(defun d-create-citation ()
  (let* ((current-time (d-current-time)))
    (if d-myel-previous-time
	(when (>= (string-to-number d-myel-previous-time)
		  (string-to-number current-time))
	  (setq current-time 
		(number-to-string
		 (+ (string-to-number d-myel-previous-time) 1)))))
    current-time))

(defun d-current-time ()
"create current time"
(format-time-string "%y%m%d%H%M" (current-time)))


;;; === Print info page
;;; --------------------------------------------------------------
;; info page에서 원하는 page의 하위 pages를 모두 print 한다.
(defun d-print-info ()
  "print info page"
  (interactive)
  (ps-print-buffer-with-faces)
  (let* ((subpage 1))		   
    (while (not (eq subpage 0)) 
      (if (re-search-forward "^* Menu" nil t)
	  (progn
	    (re-search-forward "^* .+" nil t)
	    (d-print-info-move-subpages subpage))
	(if (re-search-forward "^* .+" nil t)
	    (d-print-info-move-subpages subpage)
	  (d-print-info-move-back subpage)))))
  (message "complete printting"))

(defun d-print-info-move-subpages (subpage)
  "search next info node and join
and increase d-print-info-subpage value one"
    (Info-follow-nearest-node)
    (ps-print-buffer-with-faces)
    (setq subpage (1+ subpage)))

(defun d-print-info-move-back (subpage)
  ""
  (setq subpage (1- subpage))
  (Info-history-back)
  (forward-char))

;; To open current page with firefox in w3m-mode and muse-mode
(defun d-open-with-firefox ()
  "open current page of w3m or muse with firefox"
  (interactive)
  (let* ((url (or (w3m-print-current-url) (muse-link-at-point))))
    (browse-url-firefox url)))

(defun d-open-with-mozilla ()
  "open current page of w3m or muse with mozilla"
  (interactive)
  (let* ((url (or (w3m-print-current-url) (muse-link-at-point))))
    (browse-url-mozilla url)))

(defun d-open-with-kde ()
  "open current page of w3m or muse with firefox"
  (interactive)
  (let* ((url (or (w3m-print-current-url) (muse-link-at-point))))
    (browse-url-kde url)))


;;; === To use d-planner-search-notes on anywhere
;;; --------------------------------------------------------------
;;(defun d-planner-search-notes (regexp limit &optional include-body)
;;  "planner-search-note를 실행하는 directory가 ~/notes 여야 한다."
;;  (interactive (list (read-string "Regexp: ")
;;                     (if current-prefix-arg
;;                         (let ((planner-expand-name-favor-future-p nil))
;;                           (planner-read-date)))
;;                     nil))
;;  (let* (buffer)
;;  (point-to-register buffer)
;;  (planner-find-file (format-time-string "20%y.%m.%d"))
;;  (planner-search-notes regexp limit include-body)
;;  (other-window 1)
;;  (jump-to-register buffer)
;;  (other-window 1)))
;; do not need more


;;; === For mldonkey
;;; --------------------------------------------------------------
(defun d-mldonkey-down-torrent (link)
  "to download bittorrent file mldonkey가 실행되어 있어야 한다."
  (interactive
   (list (w3m-anchor)))
  (save-window-excursion
    ;(let ((link (w3m-anchor)))
    ;(let ((link (w3m-get-text-property-around 'w3m-href-anchor)))
    (unless (member "*MlDonkey Console*" (mapcar (function buffer-name) (buffer-list)))
      (mldonkey-console))
    (switch-to-buffer "*MlDonkey Console*")
    (insert (concat "dllink " link "\n"))
    (comint-send-input)
    (bury-buffer)
    (d-mldonkey-add-log link)
    (message "file is added.")))

(defun d-mldonkey-add-log (url)
  "The function d-mldonkey-down-torrent에 적용디어
  /home/ptmono/plans/manga_list 에 mldonkey로 받은 파일의 list를 만들어 준다."

  (if (string-match "^ed2k.*\|file\|\\([^\|]+\\)" url)
      (let ((file-name (w3m-url-decode-string (match-string 1 url))))
	(find-file "/home/ptmono/plans/manga_list")
	(goto-char (point-min))
	(insert (concat file-name "        # " url))
	(newline)
	(save-buffer)
	(kill-buffer (current-buffer)))))

(defun d-demonoid-down (dir)
  "download demonoid torrent file on emacs-w3m"
  (interactive (if current-prefix-arg
		   (list (read-directory-name "Location: " "/media/data/ebooks/computers/"))
		 (list "")))
  (let ((url w3m-current-url)
	link
	shme
	msg)
    (cond ((string-match "demonoid" url)
	   (search-forward "Click here to download"))
	  ((string-match "ebookshare.net" url)
	   (search-forward "Download This Torrent"))
	  ((string-match "h33t.com" url)
	   (search-forward "share download")))
    (setq link (w3m-anchor))
    ;;FIXME: It has spce problem. 이거 자체적으로 quote하는게 아닐까? 확인요.
    ;;(start-process "torrent" "*torrent*" "/home/ptmono/myscript/torrent.py " "-d" dir (concat "\"" link "\""))
    (start-process "torrent" "*torrent*" "/home/ptmono/myscript/torrent.py" "-d" dir link)

    (setq msg (concat "Download the link " link))
    (message msg)
    ;; (shell-command (concat "/home/ptmono/myscript/torrent.py " dir "\"" link "\""))
    (forward-line -1)
    ;buffer-string
    ;; (save-window-excursion
    ;;   (switch-to-buffer "*Shell Command Output*")
    ;;   (setq shme (buffer-string))
    ;;   (bury-buffer))
    ;; (message shme)
    ))

;; To copy images from dica to the hdd
(defun d-dica-copy ()
  "to copy dica pictures"
  (interactive)
  (shell-command-to-string "cp -r /media/usb/dcim/* ~/Desktop/pictures/")
  (if (y-or-n-p-with-timeout "delete all?" 4 "y")
      (progn
	(shell-command-to-string "rm -r /media/usb/dcim/*")
	(message "we complete coping!"))
    (message "we didn't delete the files of dcim!"))
  (shell-command-to-string "digikam"))

;; To backup my documents
(defun d-backup-documents ()
  "simply update ~/Desktop/Documents/* to /medis/data/backup/Documents/"
  (interactive)
  (shell-command-to-string "sudo cp -ru /home/ptmono/.emacs /media/data/backup/")
  (shell-command-to-string "sudo cp -ru /home/ptmono/.gnus /media/data/backup/")
  (shell-command-to-string "sudo cp -ru /home/ptmono/Desktop/Documents/* /media/data/backup/Documents/")
  (shell-command-to-string "sudo cp -ru /home/ptmono/.emacs.d/* /media/data/backup/emacs.d/")
  ;(shell-command-to-string "sudo cp -ru /usr/src/cvs/* /media/data/backup/cvs/")
  (shell-command-to-string "sudo cp -ru /home/ptmono/.emacs.d/etc/mldonkey-el-0.0.4b /data/backup/cvs/")
  (shell-command-to-string "sudo cp -ru /usr/src/packages/remember/ /data/backup/cvs/")
  (shell-command-to-string "sudo cp -ru /usr/src/cvs/color-theme/ /data/backup/cvs/")
  (shell-command-to-string "sudo cp -ru /usr/src/cvs/color-theme/themes/ /data/backup/cvs/")
  (shell-command-to-string "sudo cp -ru /usr/src/cvs/bbdb/lisp /data/backup/cvs/")
  (shell-command-to-string "sudo cp -ru /usr/src/cvs/mmm-mode/ /data/backup/cvs/")
  (shell-command-to-string "sudo cp -ru /usr/src/packages/* /media/data/backup/packages/")
  )


;;; === For find-file
;;; --------------------------------------------------------------
;; book mark use bookmark-after-jump-hook 'd-bookmark-after-jump.
(defun d-file-open ()
  "If specified file is opened I need some automated excusions.
This function is added to find-file-hook"
  (when (string-match "worknote[0-9]*\\.muse" (buffer-name))
    ;; This is duplicated with d-muse-mode-init
    )
  (when (equal (buffer-name) "elispWorknote.el")
    ;(outline-minor-mode)
    (lisp-interaction-mode)
    (goto-char (point-max))))
    
(push 'd-file-open find-file-hook)

;; (defun d-bookmark-after-jump ()
;;  "You use 'C-x r b' to jump to bookmark. This function is add to
;; bookmark-after-jump- hook"
;;  (when (equal (buffer-name) "elispWorknote.el")
;;    (progn
;;      (lisp-interaction-mode)
;;      (end-of-buffer))))

(add-hook 'bookmark-after-jump-hook 'd-file-open)


;;; === 0610301131 change camera image and move
;;; --------------------------------------------------------------
(defun d-dica-resize-image-name ()
"It is same function with 'd-insert-last-image' except that more bic 1 and
returns a file name created"
  (let* ((d-image-file-alist (directory-files "~/imgs/" t "image[0-9]+\\.jpg"))
	 (carlist (car d-image-file-alist))
	 (cdrlist (cdr d-image-file-alist))
	 numlist)
    (while carlist
      (string-match "[0-9]+" carlist)
      (setq numlist (cons (string-to-number (match-string 0 carlist)) numlist))
      (setq carlist (car cdrlist))
      (setq cdrlist (cdr cdrlist)))
    (let* ((b 0))
      (dolist (a numlist b)
	(setq b (max a b)))
      (concat "/home/ptmono/files/image" (number-to-string (+ b 1)) ".jpg"))))

;; (defun d-dica-resize-image ()
;; "The function converts the size of image and copy to /home/ptmono/file directory
;; in dired, tumme-mode. This is for web. The file name copied is 'imageNUMBER'."
;; (interactive)
;; (when (or (dired-get-filename) (tumme-original-file-name))
;;   (let* ((conv-string (concat "convert -scale 640 " (or (dired-get-filename) (tumme-original-file-name)) " " (d-dica-resize-image-name))))
;;     (shell-command-to-string conv-string)
;;     (message (concat (d-dica-resize-image-name) " is created")))))
;; (defun d-dired-filemanagement ()
;; "open current directory of dired mode to kfmclent openProfile filemanagement"
;;   (interactive)
;;   (shell-command (concat "kfmclient openProfile filemanagement \"" (dired-current-directory) "\"")))


;;; === For zip rar
;;; --------------------------------------------------------------
;; consider the use of d-ebook-ext
(defun d-extract-file ()
  "to extract zip or rar files of movie"
  (interactive)
  (let* ((filename (dired-get-filename))
	(extension (file-name-extension filename))
	(extract-directory "/tmp/0-movie/"))
    (when (equal "rar" extension)
      (shell-command (concat "unrar x " filename " " extract-directory)))
    (when (equal "zip" extension)
      (shell-command (concat "unzip " filename " -d " extract-directory)))))


;;; === For etags
;;; --------------------------------------------------------------
;; If you want to create new ~/TAGS with deleting previous ~/TAGS, use
;; d-etags-new. And use d-etags-add to add new etags to ~/TAGS
(defvar d-etags-directory-list '("/home/ptmono/.emacs.d/"
				 "/usr/share/emacs/"
				 "/usr/src/cvs/emacs/lisp/")
  "")

(defun d-etags-new ()
  "create new ~/TAG file"
  (interactive)
  (shell-command "rm ~/TAGS")
  (dolist (directory d-etags-directory-list)
    (shell-command (concat "find "
			   directory
			   " -name \"*.el\" |xargs etags -a -o ~/TAGS")))
  (message "done"))

(defun d-etags-add ()
  "add TAG to ~/TAG"
  (interactive)
  (let ((directory (read-directory-name "Directory: ")))
    (shell-command (concat "find "
			   directory
			   " -name \"*.el\" -or -name \"*.py\" |xargs etags -a -o ~/TAGS"))
    (message "done")))

(defun d-gwenview ()
  (interactive)
  (shell-command "gwenview&"))

(defun d-last-work ()
  (interactive)
  (split-window nil nil t)
  (bookmark-jump ".emacs")
  (other-window 1)
  (bookmark-jump "python-config.el"))


;;; === For movie
;;; --------------------------------------------------------------
(defun d-newsgroup-nfo ()
  "what is new nfo file on korea.binary.movie"
  (interactive)
  (start-process "movie-nfo" "*newsgroup-nfo*" "/home/ptmono/myscript/movienfo.py")
  (message "Work done"))


;;; === For shell
;;; --------------------------------------------------------------
(defun d-shell-cat-command ()
  (interactive)
  ""
  ;; var1=current point
  (let ((a (point)))
    (save-window-excursion
      (write-file "~/test/a"))
    (insert "cat ~/test/a |grep -i ptmono@ |sed -e \"s/ptmono@localhost/XXX@Y/g\"")
    (comint-send-input)))


;;; === For w3m
;;; --------------------------------------------------------------
(defun d-w3m-html-prettify ()
  (interactive)
  "In w3m the function will view the source of page that to be prettify"
  (let* ((util "~/myscript/htmlPrettify.py")
	 (buffer "*HTML*")
	 (command (concat util " \""w3m-current-url "\"")))
    (d-window-separate)
    (shell-command command buffer)
    (other-window 1)
    (html-mode)
    (unless view-mode
      (view-mode))
    ))


;;; === For find
;;; --------------------------------------------------------------
(defun d-find-file-tag ()
  "find-file of ~/plans directory. You don't need type muse extension for muse file."
  (interactive)
  (if current-prefix-arg
      (let* ((dir (read-directory-name "WorkDir: " "~/works/")))

	;; Fixme: It is more convenient that the function can open other file.
	(find-file (concat dir "w.muse")))
    (let* ((file (read-file-name "Tag: " "~/plans/"))
           ;; If file is "linux.", we only need "linux"
	   (file-muse (if (equal "." (substring file -1 nil))
			  (concat file "muse")
			(concat file ".muse"))))
      ;; always open muse file if there is
      (if (file-exists-p file-muse)
	  (find-file file-muse)
	(find-file file)))))

;; Fixed: We meet error in shell
(defun d-terminal ()
  "The nofork option means that Do not run in the background."
  (interactive)
  ;(start-process "konsole2" "*Process2*" "konsole" "--nofork" "--workdir" default-directory))
  (let* ((current-directory (shell-command-to-string "pwd"))
	 (current-directory (replace-regexp-in-string "\n" "" current-directory)))
    (start-process "konsole2" "*Process2*" "gnome-terminal" current-directory)))

(defun d-terminal2 ()
  ""
  (interactive)
  (start-process "konsole" "*Process*" "gnome-terminal"))

(defun d-nautilus ()
  "The nofork option means that Do not run in the background."
  (interactive)
  (let* ((current-directory (shell-command-to-string "pwd"))
	 (current-directory (replace-regexp-in-string "\n" "" current-directory)))
    (start-process "konsole2" "*Process2*" "nautilus" current-directory)))


;;; === For ebook
;;; --------------------------------------------------------------
(defvar d-ebook-index-file-name "~/ebook_list")

;; TODO I don't like dired format for ebook list. I want to see file size
;; and the filepath or just filepath. Create own mode without dired-mode
(defun d-ebook-find (regexp)
  "Search ebook"
  (interactive)
  (let* ((buf-name "*Ebook*")
	 ;; command
	 (args (concat "grep -iE \"" regexp "\" " d-ebook-index-file-name "&")))
    
    (if (get-buffer buf-name)
	(kill-buffer buf-name))
    (other-window 1)
    (switch-to-buffer buf-name)

    (shell-command args (current-buffer))

    (dired-mode "~/" (cdr find-ls-option))
    (set (make-local-variable 'dired-subdir-alist)
	 (list (cons default-directory (point-min-marker))))
    (setq buffer-read-only nil)

    ;; from fired-mode
    ;; Subdir headlerline must come first because the first marker in
    ;; subdir-alist points there.
    (insert "  " "~/" ":\n")
    ;; Make second line a ``find'' line in analogy to the ``total'' or
    ;; ``wildcard'' line.
    (insert "  " args "\n")
    (setq buffer-read-only t)
    (let ((proc (get-buffer-process (current-buffer))))
      (set-process-filter proc (function find-dired-filter))
      (set-process-sentinel proc (function find-dired-sentinel))
      ;; Initialize the process marker; it is used by the filter.
      (move-marker (process-mark proc) 1 (current-buffer)))
    (setq mode-line-process '(":%s"))))

;; Alias
(defun find-dired-ebooks ()
  (interactive)
  (let* ((qqq (read-string "Run find (just words or regexp): " "")))
  (d-ebook-find qqq)))

(defun d-ebook-index-create ()
  ""
  (interactive)
  (message "Listing ebooks")
  (let* ((buf-name "*Ebook*")
	 (args "find /tmp/0-incoming/directories/ /media/data/ebooks/ /media/winda/0ebooks/ /tmp/0-incoming/files/ /media/data/0-incoming/ /media/data100/0ebook/ /media/data50/0ebooks/ \\( -iregex \".*\\(pdf\\|chm\\|rar\\|zip\\|djvu\\|tgz\\|gz\\|bz2\\|7z\\)\" \\) -exec ls -lhd {} \\; > ~/ebook_list &"))
    (if (get-buffer buf-name)
	(kill-buffer buf-name))
    (save-window-excursion
      (switch-to-buffer buf-name)
      (shell-command args (current-buffer))
      (set-process-sentinel (get-buffer-process (current-buffer)) (function d-ebook-sentinel)))))

(defun d-ebook-sentinel (proc event)
  (let* ((args (concat "wc -l " d-ebook-index-file-name))
	 (msg (substring (shell-command-to-string args) 0 -1))
	 (buf (process-buffer proc)))
    ;(if (buffer-name buf)
	;(set-buffer buf))
    ;(message (concat (shell-command-to-string args) "Finished") (current-buffer))
    (kill-buffer buf)
    (d-notify-desktop "Finished" msg)))

(defvar d-ebook-mode-map
  (let ((map (make-sparse-keymap)))
    ;(set-keymap-parent map w3m-mode-map)
    (define-key map [?\C-c ?e] 'd-ebook-ext)
    (define-key map [?\C-c ?c] 'd-ebook-compress)
    (define-key map [?\C-c ?m] 'd-ebook-mov)
    (define-key map [?\C-c ?k] 'd-ebook-kill-bufer)
    ;(define-key map [?\C-c ?K] 'd-sub-kill)
    (define-key map [kp-1] 'd-ebook-choose-1)
    (define-key map [kp-2] 'd-ebook-choose-2)
    map)
  "Keymap used by d-ebook-mode")

;; Fixme: minor mode has a problem. In a directory of dired-mode, I will
;; C-m to see the directory. The subdirectory has no d-ebook-minor-mode.
;; So I can't use minor mode.
(define-minor-mode d-ebook-minor-mode
  "To use d-ebook-mode-map"
  nil " d-ebook-minor" d-ebook-mode-map
  :group 'ebook)

(defun d-ebook-ext ()
  ""
  (interactive)
  (let* ((filename (dired-get-filename))
	 (ext (url-file-extension filename)))
    (cond ((equal ext ".rar")
	   (shell-command (concat "unrar -y e \"" filename "\"")))
	  ((equal ext ".zip")
	   (shell-command (concat "unzip -o \"" filename "\"")))
	  ((equal ext ".7z")
	   (shell-command (concat "7za -y e \"" filename "\""))))))

(defun d-ebook-mov ()
  ""
  (interactive)
  (let* ((dirname (read-directory-name "DIR: " "/media/data/ebooks/computers/"))
	 (filename (dired-get-filename)))
    (shell-command (concat "mv \"" filename "\" " dirname))))

(defun d-ebook-mov-sub ()
  ""
  (interactive)
  (let* ((dirname (shell-command-to-string "cd ..; pwd"))
	 (filename (dired-get-filename)))
    (shell-command (concat "mv \"" filename "\" " dirname))))

(defun d-ebook-kill-bufer ()
  ""
  (interactive)
  (kill-buffer (current-buffer))
  (dired-do-delete))

;; Fixme: To savely delete parent directory
(defun d-ebook-mov-kill ()
  ""
  (interactive)
  (d-ebook-mov-sub)
  (d-ebook-kill-bufer))

(defun d-ebook-choose-2 ()
  "delete 2"
  (interactive)
  (kill-line)
  (forward-line)
  (beginning-of-line)
  (kill-line)
  (kill-line))

(defun d-ebook-choose-1 ()
  "delete 1"
  (interactive)
  (kill-line)
  (beginning-of-line)
  (kill-line)
  (kill-line)
  (forward-line))

(defun d-ebook-compress ()
  ""
  (interactive)
  (let* ((filename (dired-get-filename t)))
    (message "Wait for compressing")
    (shell-command-to-string (concat "tar -cvzf \"" (concat filename "\".tar.tgz \"") filename "\""))
    (message "We finished")))


;;; === Notification
;;; --------------------------------------------------------------
(require 'python-config)
;;from web
(defun d-notify-desktop (title message &optional duration &optional icon)
  "Pop up a message on the desktop with an optional duration (forever otherwise)"
  (pymacs-exec "import pynotify")
  (pymacs-exec "pynotify.init('Emacs')")
  (if icon 
      (pymacs-exec (format "msg = pynotify.Notification('%s','%s','%s')"
                           title message icon))
    (pymacs-exec (format "msg = pynotify.Notification('%s','%s')" title message))
    ) 
  (if duration 
      (pymacs-exec (format "msg.set_timeout(%s)" duration))
    )
  (pymacs-exec "msg.show()")
  )



