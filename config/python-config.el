
;;; Logs

;; 1305230532 py-indent-tabs-mode-off
;; If this mode on. python-mode use tab. It will occur many indent errors
;; and mis-execution. Python don't support tab/space mixing. Just use
;; space tab. It is recommened


;; Add in init.el. There is a compile error when auto compiling.
;; (when (d-not-windowp)
;;   (setenv "PYTHONPATH" (concat (getenv "PYTHONPATH") ":" (concat d-home "myscript/pystartup.py")))
;;   (setenv "PYTHONPATH" (concat (getenv "PYTHONPATH") ":" (concat d-dir-emacs "cvs/ropemacs/ropemacs")))
;;   (setenv "PYTHONPATH" (concat (getenv "PYTHONPATH") ":" (concat d-dir-emacs "cvs/ropemode/ropemode")))
;;   (setenv "PYTHONPATH" (concat (getenv "PYTHONPATH") ":" (concat d-dir-emacs "cvs/Pymacs")))
;;   ;; To add pycomplete.py
;;   (setenv "PYTHONPATH" (concat (getenv "PYTHONPATH") ":" (concat d-dir-emacs "cvs/python-mode/completion")))
;;   (setenv "PYTHONSTARTUP" (concat d-dir-emacs "myscript/pystartup.py")))

;; (add-to-list 'load-path (concat d-dir-emacs "cvs/python-mode/"))
;; (add-to-list 'load-path (concat d-dir-emacs "cvs/python-mode/completion/"))
;; (add-to-list 'load-path (concat d-dir-emacs "cvs/python-mode/devel/"))
;; (add-to-list 'load-path (concat d-dir-emacs "cvs/python-mode/extensions/"))
(add-to-list 'load-path (concat d-dir-emacs "cvs/Pymacs"))
(add-to-list 'load-path (concat d-dir-emacs "cvs/ipython/docs/emacs/"))
;; (add-to-list 'load-path (concat d-dir-emacs "cvs/python-mode"))
;; (add-to-list 'load-path (concat d-dir-emacs "cvs/python-mode/completion"))
;; (add-to-list 'load-path (concat d-dir-emacs "cvs/python-mode/devel/"))
;; (add-to-list 'load-path (concat d-dir-emacs "cvs/python-mode/extensions/"))
(add-to-list 'load-path (concat d-dir-emacs "cvs/ipython/docs/emacs/"))
(add-to-list 'load-path (concat d-dir-emacs "cvs/pylookup/"))

(setq py-install-directory (concat d-dir-emacs "cvs/python-mode"))
(add-to-list 'load-path py-install-directory)
(when (featurep 'python) (unload-feature 'python t)) ; from readme
;(require 'python-mode)


;;; .
;;; === For pymacs
;;; ______________________________________________________________

;(load-library "python-mode.el")
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
(autoload 'pymacs-autoload "pymacs")
;;(eval-after-load "pymacs"
;;  '(add-to-list 'pymacs-load-path YOUR-PYMACS-DIRECTORY"))                                            

;;; .
;;; === For python-mode
;;; ______________________________________________________________
;; python-mode do not include the functions of completion.
;; (when (featurep 'python) (unload-feature 'python t)) ; from readme
;; (require 'python-mode)
(setq py-complete-function 'ipython-complete
      py-shell-complete-function 'ipython-complete
      py-shell-name "ipython"
      py-which-bufname "IPython")
(setq py-use-local-default t)
(if (d-windowp)
    (setq py-shell-local-path (concat d-dir-emacs "/cvs/ipython/ipython.bat"))
  (setq py-shell-local-path (concat d-dir-emacs "/cvs/ipython/ipython.py")))
  
;(setq py-shell-local-path "c:\\emacsd\\cygwin\\home\\ptmono\\.emacs.d\\cvs\\ipython\\ipython.bat")
;(setq py-shell-local-path (concat d-dir-emacs "/cvs/ipython/ipython.py"))
;(setq py-python-command "ipython")
;(setq pymacs-python-command "python")



;; python-mode 6.1.1 defines ipython-completion-command-string as nil.
;; We need this it defined in ipython.el

(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
(setq interpreter-mode-alist (cons '("python" . python-mode)
				   interpreter-mode-alist))
(autoload 'python-mode "python-mode" "Python editing mode." t)


(setq auto-mode-alist
      (cons '("SConstruct" . python-mode) auto-mode-alist))
(setq auto-mode-alist
      (cons '("SConscript" . python-mode) auto-mode-alist))
;; To enable completion in python-mode
;;(load-library "pycomplete.el")
;; It has a problem. conflict with ropemacs. So moved to ropemacs-config.el

;; In XEmacs syntax highlighting should be enabled automatically.  In GNU
;; Emacs you may have to add these lines to your ~/.emacs file:
;;    (global-font-lock-mode t)
;;    (setq font-lock-maximum-decoration t)


;;; .
;;; == Font-lock
;;; ______________________________________________________________
(defvar d-python-section-face 'd-python-section-face)
(defface d-python-section-face
  '((t (:foreground "#298727" :bold nil))) 
  "Face for the python-mode ."
  :group 'font-lock-faces)

(defvar d-python-section-bold-face 'd-python-section-bold-face)
(defface d-python-section-bold-face
  '((t (:foreground "#4eff4b" :bold t))) 
  "Face for the python-mode ."
  :group 'font-lock-faces)


(defvar d-python-doc-result-face 'd-python-doc-result-face)
(defface d-python-doc-result-face
  '((t (:foreground "#FF787A" :bold nil))) 
  "Face for the python-mode ."
  :group 'font-lock-faces)


(defvar d-python-doctest-comment-face 'd-python-doctest-comment-face)
(defface d-python-doctest-comment-face
  '((t (:foreground "#FF787A" :bold nil))) 
  "Face for the python-mode ."
  :group 'font-lock-faces)


(defvar d-python-doctest-input-face 'd-python-doctest-input-face)
(defface d-python-doctest-input-face
  '(;(t (:foreground "#FFBB00" :bold nil))) 
    (t (:foreground "#FFD500" :bold nil))) 
  "Face for the python-mode ."
  :group 'font-lock-faces)


(defvar d-python-doctest-input-face 'd-python-doctest-input-face)
(defface d-python-doctest-input-face
  '(;(t (:foreground "#FFBB00" :bold nil))) 
    (t (:foreground "#FFD500" :bold nil))) 
  "Face for the python-mode ."
  :group 'font-lock-faces)



(defvar d-python/font-lock-keywords
  '(;("^[ \t]+>>> \\(.+\\)" 0 d-python-doctest-input-face t)
    ("^[ \t]+>>> \\(#.+\\)$" 1 d-python-doctest-comment-face t)
    ("^[ \t]+>>> \\(##+.+\\)$" 1 d-python-section-face t)
    
    ("^### =+ \\(.*\\)$" 1 d-python-section-bold-face t)
    ("\\(.*\\)\n[ \t]*#==>$" 1 d-python-doc-result-face t)

    ;; Fixme: more correct regexp
    ;; refer to
    ;; http://stackoverflow.com/questions/466053/regex-matching-by-exclusion-without-look-ahead-is-it-possible
    ;; http://stackoverflow.com/questions/2217928/how-do-i-write-a-regular-expression-that-excludes-rather-than-matches-e-g-not

    ;; Currently using doctest
    ;; (">>> .*\\([^>']*\\(\\(['>][^>']+\\)*\\)\\)[ \n]*" 1 font-lock-doc-face t)

    ))


;;; .
;;; === For ipython and python shell
;;; ______________________________________________________________
;; Added in init.el
;(add-to-list 'load-path (concat d-dir-emacs "cvs/ipython/docs/emacs/"))
(require 'ipython)
(setq ipython-completion-command-string "print(';'.join(get_ipython().complete('%s', '%s')[1])) #PYTHON-MODE SILENT\n")

;; Let's use python of windows in windows
;; (when (d-windowp)
;;   ;(setq python-python-command "c:/Python27/python.exe")
;;   (setq python-python-command "c:/Program Files (x86)/IronPython 2.7/ipy.exe")
;;   )

; from http://www.emacswiki.org/emacs/PythonMode
; The definition in ipython.el is wrong.

;; To collect output we have to modify ipyton.bat. Add -u option
;; @C:\Python27\python.exe C:\Python27\scripts\ipython.py %* to
;; @C:\Python27\python.exe -u C:\Python27\scripts\ipython.py %*
;; See more worknote_xp.muse#1102150621
(when (d-windowp)
  ;(setq ipython-command "C:\Python27\scripts\ipython.bat")
  (setq ipython-command (concat d-dir-emacs "/cvs/ipython/ipython.py"))
  )
;(setq py-python-command-args '("--autocall" "0"))
;; Default is ("-i" "-colors" "LightBG")
;; (setq py-python-command-args '("-pylab" "-colors" "LightBG"))
;(setq py-python-command-args '("--colors=LightBG" "-i"))


; To completion
;(setq ipython-completion-command-string "print(';'.join(__IP.Completer.all_completions('%s')))\n")

;(require 'comint)
;(define-key comint-mode-map [(meta p)]
;  'comint-previous-matching-input-from-input)
;(define-key comint-mode-map [(meta n)]
;  'comint-next-matching-input-from-input)
;(define-key comint-mode-map [(control meta n)]
;  'comint-next-input)
;(define-key comint-mode-map [(control meta p)]
;  'comint-previous-input)

;;; To solve ipython color problem with color-theme
;; In 'M-x py-shell' with ipython, the color of default content is black.
;; My default background color is also black. ipython.el uses the output
;; of ipython.py(?). It has the format of ansi color. To determine the
;; color of ansi format, ipython.el use ansi-color.el. The variable
;; ansi-color-names-vector defines the color of ansi format.
;; (custom-set-variables
;;  '(ansi-color-names-vector ["ligth-gray" "red" "green" "yellow" "blue" "magenta" "cyan" "white"]))




;;; .
;;; = abbrev
;; python.el에 포함되어 있습니다. 이유는 모르겠지만, 시작시 로드하지 않아서 여기에
;; 붙여요.
;; Moved to abbrev-config.el

;;; .
;;; === Completion
;;; ______________________________________________________________
;; To enable completion in python-mode
;; Use 'completion-at-point instead 'py-complete.
;; (require 'pycomplete)
;; Normal require conflict when using package. It is a trick.
(add-hook 'python-mode-hook (lambda () (require 'pycomplete)))



;;; .
;;; === For anything-ipython
;;; ______________________________________________________________

; The package requires anything. el file contains following
;---------------
;; Tested on emacs23.1 with python2.6, ipython-9.1 and python-mode.el.
;; This file fix also normal completion (tab without anything) in the ipython-shell.
;; This file reuse some code of ipython.el.
;---------------
; current emacs version is 23.0.95.1

;(require 'anything)
;(require 'anything-ipython)

;(add-hook 'python-mode-hook #'(lambda ()
;                                (define-key py-mode-map (kbd "M-<tab>") 'anything-ipython-complete)))
;(add-hook 'ipython-shell-hook #'(lambda ()
;                                  (define-key py-mode-map (kbd "M-<tab>") 'anything-ipython-complete)))



;;; .
;;; === Inserting with key
;;; ______________________________________________________________
(defvar d-python-key-insert-alist
  '(("docskip" "#doctest: +SKIP")
    ("docignore" "#doctest: +IGNORE_EXCEPTION_DETAIL")
    ("docellipsis" "#doctest: +ELLIPSIS")
     ;; Alias
    ("skip" "#doctest: +SKIP")
    ("ignore" "#doctest: +IGNORE_EXCEPTION_DETAIL")
    ("ellipsis" "#doctest: +ELLIPSIS")
    ("pdb" "import pdb, sys; pdb.Pdb(stdin=sys.__stdin__,stdout=sys.__stdout__).set_trace()")
    ("docsec" d-python/insert/docsec)
    ("ddsec" d-python/insert/docsec)
    )
  "")

(defun d-python/insert ()
  (interactive)
  (let* ((key (completing-read "Choose : " d-python-key-insert-alist))
	 (value (car (cdr (assoc key d-python-key-insert-alist)))))
    (if (stringp value)
	(insert value)
      (funcall value))))

(defun d-python/insert/docsec ()
  (let* ((title (read-string "Section: "))
	 (len (length title))
	 ;(bottom (make-string (+ 4 len) ?\_)))
	 (bottom (make-string (- fill-column 16) ?_)))
    (newline)
    (newline)
    (indent-for-tab-command)
    (insert (concat "### === " title))
    (newline)
    (indent-for-tab-command)
    (insert (concat "### " bottom))
    (newline)
    (indent-for-tab-command)
    (insert ">>> ")))


;;; .
;;; === For folding
;;; ______________________________________________________________
; from mailing list

(add-hook 'python-mode-hook 'my-python-hook)

(defun py-outline-level ()
  "This is so that `current-column` DTRT in otherwise-hidden text"
  ;; from ada-mode.el
  (let (buffer-invisibility-spec)
    (save-excursion
      (skip-chars-forward "\t ")
      (current-column))))

; this fragment originally came from the web somewhere, but the outline-regexp
; was horribly broken and is broken in all instances of this code floating
; around.  Finally fixed by Charl P. Botha <<a href="http://cpbotha.net/">http://cpbotha.net/</a>>
(defun my-python-hook ()
  (setq outline-regexp "[^ \t\n]\\|[ \t]*\\(def[ \t]+\\|class[ \t]+\\)")
  ; enable our level computation
  (setq outline-level 'py-outline-level)
  ; do not use their \C-c@ prefix, too hard to type. Note this overides 
  ;some python mode bindings
  (setq outline-minor-mode-prefix "\C-c")
  ; turn on outline mode
  (outline-minor-mode t)
  ; initially hide all but the headers
  ; (hide-body)
  (show-paren-mode 1)

  ;; With Some problem, use manually
  ;; (if (d-not-windowp)
  ;;     (flymake-mode))

  (font-lock-add-keywords nil d-python/font-lock-keywords)
  ;; with tab mode I meet may indent error.
  (py-indent-tabs-mode-off 1)
)

;;; .
;;; === For cython
;;; ______________________________________________________________

(add-to-list 'auto-mode-alist '("\\.pyx\\'" . cython-mode))

(define-derived-mode cython-mode python-mode "Cython"
  (font-lock-add-keywords
   nil
   `((,(concat "\\<\\(NULL"
               "\\|c\\(def\\|har\\|typedef\\)"
               "\\|e\\(num\\|xtern\\)"
               "\\|float"
               "\\|in\\(clude\\|t\\)"
               "\\|object\\|public\\|struct\\|type\\|union\\|void"
               "\\)\\>")
      1 font-lock-keyword-face t)))) 



;;; .
;;; === For pylookup
;;; ______________________________________________________________

(setq pylookup-dir "~/.emacs.d/cvs/pylookup")
(add-to-list 'load-path pylookup-dir)

;; load pylookup when compile time
(eval-when-compile (require 'pylookup))


;; set executable file and db file
(setq pylookup-program (concat pylookup-dir "/pylookup.py"))
(setq pylookup-db-file (concat pylookup-dir "/pylookup.db"))

;; to speedup, just load it on demand
(autoload 'pylookup-lookup "pylookup"
  "Lookup SEARCH-TERM in the Python HTML indexes." t)

(autoload 'pylookup-update "pylookup" 
  "Run pylookup-update and create the database at `pylookup-db-file'." t)


;;; .
;;; === Syntax checking
;;; ______________________________________________________________
;; from
;; - https://bitbucket.org/tavisrudd/pylint_etc_wrapper.py/src/5a5d4d4cff2e/pylint_etc_wrapper.py
;; - http://www.emacswiki.org/emacs/?action=browse;oldid=PythonMode;id=PythonProgrammingInEmacs
;; requires
;; sudo yum install python-pep8 pychecker pyflakes pylint pylint-gui

(setq pycodechecker "pylint_etc_wrapper.py")
(when (load "flymake" t)
  (load-library "flymake-cursor")
  (defun dss/flymake-pycodecheck-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list pycodechecker (list local-file))))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" dss/flymake-pycodecheck-init)))

(defun dss/pylint-msgid-at-point ()
  (interactive)
  (let (msgid
        (line-no (line-number-at-pos)))
    (dolist (elem flymake-err-info msgid)
      (if (eq (car elem) line-no)
            (let ((err (car (second elem))))
              (setq msgid (second (split-string (flymake-ler-text err)))))))))

(defun dss/pylint-silence (msgid)
  "Add a special pylint comment to silence a particular warning."
  (interactive (list (read-from-minibuffer "msgid: " (dss/pylint-msgid-at-point))))
  (save-excursion
    (comment-dwim nil)
    (if (looking-at "pylint:")
        (progn (end-of-line)
               (insert ","))
        (insert "pylint: disable-msg="))
    (insert msgid)))


;;; .
;;; === nosetests
;;; ______________________________________________________________
;; - Use commands M-x d-nosetest-doctest, M-x d-nosetest-unittest
;; - We can use on dual monitor. M-x d-nosetest/toggle-dualp
;; - To use new frame. M-x d-nosetest/toggle-newFramep
;; - Restore the windows with M-x d-test-restore that binded with C-c d r.

(defvar d-nosetest/testBuffername "*nosetest*")
(defvar d-nosetest/latestTestType nil)
(defvar d-nosetest/targetBuffername nil)
(defcustom d-nosetest/command nil "Full command. It require to create 'd-test." :group 'python-config)

(defvar d-nosetest/python-version "2.7")

;; some problem this variable is repalce with function
(defcustom d-nosetest/command-doctest (if (d-not-windowp)
				       (concat "nosetests-" d-nosetest/python-version " -v --with-doctest --doctest-tests")
				     "nosetests.exe -v --with-doctest")
  ""
  :group 'python-config
)
				     ;(concat "ipy.exe -m doctest")))
(defcustom d-nosetest/command-unittest (if (d-not-windowp)
					(concat "nosetests-" d-nosetest/python-version " -v")
				      "nosetests.exe -v")
  ""
  :group 'python-config
)

(defvar d-nosetest/newFramep nil)
(defvar d-nosetest/dualp nil "If t, we use dual monitor mode.")
(defvar d-nosetest/windows-register ?R)

(defun d-nosetest/command-doctest()
  (if (d-not-windowp)
      (concat "nosetests-" d-nosetest/python-version " -v --with-doctest --doctest-tests")
    "nosetests.exe -v --with-doctest"))

(defun d-nosetest/command-unittest()
  (if (d-not-windowp)
      (concat "nosetests-" d-nosetest/python-version " -v")
    "nosetests.exe -v"))

(defun d-nosetest/command-pure-doctest()
  (if (d-not-windowp)
      (concat "python" d-nosetest/python-version " -m doctest")
    "pythonw.exe -v --with-doctest"))

(defun d-nosetest/is-pure-doctest(buffer-name)
  (if (equal (file-name-extension buffer-name) "doctest")
      t
    nil))



(defun d-nosetest/toggle-python-version()
  (interactive)
  (let* ((prev-version (if (equal d-nosetest/python-version "3.3")
			   "3.3"
			 "2.7"))
	 (new-version (if (equal d-nosetest/python-version "3.3")
			  "2.7"
			"3.3")))
    (setq d-nosetest/python-version new-version)
    (if d-nosetest/command
	(setq d-nosetest/command
	      (replace-regexp-in-string prev-version new-version d-nosetest/command)))
  (message d-nosetest/python-version)))

(defun d-nosetest/toggle-newFramep()
  (interactive)
  (setq d-nosetest/newFramep
	(not d-nosetest/newFramep))
  (if d-nosetest/newFramep
      (message "t")
    (message "nil")))

(defun d-nosetest/toggle-dualp()
  (interactive)
  (setq d-nosetest/dualp
	(not d-nosetest/dualp))
  (if d-nosetest/dualp
      (message "t")
    (message "nil")))

(defun d-nosetest/restoreWindow()
  (interactive)
  (jump-to-register d-nosetest/windows-register))

(defun d-nosetest/set (type)
  (setq d-nosetest/latestTestType type)
  (let* ((buffer-name (file-name-nondirectory (buffer-file-name)))
	 (test-buffer-name d-nosetest/testBuffername)
	 (nose-command-only (cond ((equal t (d-nosetest/is-pure-doctest buffer-name))
				   (d-nosetest/command-pure-doctest))
				  ((equal type "doctest")
				   (d-nosetest/command-doctest))
				  ((equal type "custom")
				   (read-string "Command: "))
				  
				  (t
				   (d-nosetest/command-unittest))))
	 (nose-command (if (equal type "custom")
			   (progn
			     (setq d-nosetest/latestTestType (read-string "Command Type: " "doctest"))
			     nose-command-only)
			 (concat nose-command-only " " buffer-name)))
	 (frame (selected-frame))
	 (window (selected-window))
	 )

    (setq d-nosetest/command nose-command)
    (condition-case nil
	(d-nosetest/resetTestShell)
      (error nil))

    (defun d-test ()
      ""
      (interactive)

      (let* ((frame (selected-frame))
	     (window (selected-window))
	     target-window
	     )
	(window-configuration-to-register d-nosetest/windows-register)
	;; Frame determination
	(d-nosetest/openTestShell)
      
	(goto-char (point-max))
	(insert d-nosetest/command)
	(comint-send-input)

	;; Restore cursor
	(unless d-nosetest/newFramep
	  (select-frame-set-input-focus frame)
	  (select-window window))))

    (defun d-test-restore ()
      (d-nosetest/restoreWindow))

    ;; Restore cursor
    (select-frame-set-input-focus frame)
    (select-window window)
    ))

(defun d-nosetest/resetTestShell ()
  (let* ((current-buffer (current-buffer))
	 (default-directory (file-name-directory (buffer-file-name)))
	 (frame (d-nosetest/isFrame d-nosetest/testBuffername))
	 (window (d-nosetest/isWindow d-nosetest/testBuffername))
	 target-window
	 )

    (condition-case nil
	(kill-buffer d-nosetest/testBuffername)
      (error nil))
    (shell d-nosetest/testBuffername)
    (bury-buffer)

    (cond 
     ;; We will use test frame on dual monitor.
     (d-nosetest/dualp
      (if frame
	  (progn
	    (select-frame-set-input-focus frame)
	    (switch-to-buffer d-nosetest/testBuffername)
	    (delete-other-windows))
	(d-nosetest/createTestFrame)))

     ;; If window on frame, just re-create testBuffer. Current window
     ;; contains testbuffer.
     (window
      (select-window (get-buffer-window d-nosetest/testBuffername))
      (switch-to-buffer d-nosetest/testBuffername))

     ;; other
     (t
      (switch-to-buffer current-buffer)
      (message (concat "*nosetest* is ready. Version is " d-nosetest/python-version  " !!"))
     ))))
	
	     
(defun d-nosetest/openTestShell ()
  (cond (d-nosetest/dualp
	 (select-frame-set-input-focus (d-nosetest/isFrame d-nosetest/testBuffername)))
	(d-nosetest/newFramep
	 (switch-to-buffer-other-frame d-nosetest/testBuffername))
	(t
	 (if (d-nosetest/isWindow d-nosetest/testBuffername)
	     ;; It is used if test window exists.
	     (select-window (get-buffer-window d-nosetest/testBuffername))
	   (select-window (d-window-open-other-window d-nosetest/testBuffername))
	   ;; (switch-to-buffer-other-window d-nosetest/testBuffername)
	   ))))
    

(defun d-nosetest/isFrame (buffername)
  (let* ((frames (visible-frame-list))
	 (is-frame nil)
	 frame
	 frame-name)
    (while (and frames (not is-frame))
      (setq frame (car frames))
      (setq frames (cdr frames))

      (setq frame-name (frame-parameter frame 'name))
      (if (equal frame-name buffername)
	  (setq is-frame frame)))
    is-frame))

(defun d-nosetest/isWindow (buffername)
  (let* ((windows (window-list))
	 (is-window nil)
	 window
	 buffer-name)
    (while (and windows (not is-window))
      (setq window (car windows))
      (setq windows (cdr windows))

      (setq buffer-name (buffer-name (window-buffer window)))
      (if (equal buffer-name buffername)
	  (setq is-window window)))
    is-window))

(defun d-nosetest/isBuffer (buffername)
  (let* ((buffers (buffer-list))
	 (is-buffer nil)
	 buffer
	 buffer-name)
    (while (and buffers (not is-buffer))
      (setq buffer (car buffers))
      (setq buffers (cdr buffers))

      (setq buffer-name (buffer-name buffer))
      (if (equal buffer-name buffername)
	  (setq is-buffer buffer)))
    is-buffer))

(defun d-nosetest/createTestFrame ()
  (let* ((frame (make-frame-command)))
    (set-frame-parameter frame 'left 1918)
    (set-frame-parameter frame 'top 1201)
    (set-frame-parameter frame 'height 46)
    (set-frame-parameter frame 'width 131)
    (select-frame-set-input-focus frame)
    (d-nosetest/createTestBuffer)
    ))

(defun d-nosetest/createTestBuffer ()
  (if (d-nosetest/isBuffer "*nosetest*")
      (switch-to-buffer "*nosetest*")
    (shell "*nosetest*")))


(defun d-nosetest-doctest ()
  (interactive)
  (d-nosetest/set "doctest"))
(defun d-nosetest-unittest ()
  (interactive)
  (d-nosetest/set "unittest"))
(defun d-nosetest-custom ()
  (interactive)
  (d-nosetest/set "custom"))

(defalias 'd-python-set-nosetest-doctest 'd-nosetest-doctest)
(defalias 'd-python-set-nosetest-unittest 'd-nosetest-unittest)
  



;;; unittest

(defvar d-unittest-output-assert/process-buffer-name "*py-unittest-proc*")

(defun d-nosetest-output-assert/getOutput (id)
  (let* (anc)
    (save-excursion

      (message "fsjklfd")
      (cond ((equal d-nosetest/latestTestType "unittest")
	     (re-search-backward (concat "AssertionError: \\(.*\\) != " id) nil t)
	     (setq anc (match-string 1)))

	    ((equal d-nosetest/latestTestType "doctest")
	     ;; id will be line number
	     (re-search-backward (format "\\(--\\|\\*\\*\\)\nFile.*, line %s, in " id) nil t)
	     (goto-char (match-beginning 0))
	     (re-search-forward "^Got:\\(\n.*$\\)" nil t)
	     (setq anc (match-string 1))
	     (message anc)
	     )))
    anc
  ))



(defun d-nosetest-output-assert/line-info()
  "Return (ASSERTP START END DATA). 

ASSERT: non-nil or nil. non-nil means that it is assert line. nil
means it is command.

START: If ASSERT is non-nil, the start point of the result of
assert. If ASSERT is nil, It is the start point of the command
function.

END: If ASSERT is non-nil, the end point of the result of
assert. If ASSERT is nil, It is the end point of the command
function.

data: a string

LINE-NUMBER: a string
"
  (interactive)
  (let* ((str (thing-at-point 'line))
	 (point-at-bol (point-at-bol))
	 (line-number (line-number-at-pos))
	 (doc-regexp "[ \t]*>>> \\(.*\\)")
	 ;; Fixme: don't parse folowing
	 ;; self.assertEqual(list_range_to_list(url_range), [1, 2, 3, 4, 5, 6, 7, 8, 9])
	 ;; self.assertEqual(list(iterateUrls(url_format, url_range)), 5442)
	 (assert-regexp "self.assert[^,]+, *\\(.*\\))$")
	 (cmd-regexp "^[ \t]*\\(.*\\)$")
	 result result-pos assertp start end data
	 )
    (cond ((equal d-nosetest/latestTestType "unittest")
	   (setq assertp (string-match assert-regexp str))
    
	   (unless assertp (string-match cmd-regexp str))

	   (setq start (+ point-at-bol (match-beginning 1)))
	   (setq end (+ point-at-bol (match-end 1)))
	   (setq data (match-string 1 str))

	   (setq result (list assertp start end data line-number))
	   )

	  ((equal d-nosetest/latestTestType "doctest")
	   (save-excursion
	     (goto-char (point-at-eol))
	     (setq start (point)) ; the start to be deleted line
	     ;(re-search-backward doc-regexp nil t)
	     ;(goto-char (match-beginning 0))
	     (setq line-number (line-number-at-pos))

	     )

	   (setq assertp nil)
	   (setq end nil)
	   (setq data nil)
	   (setq line-number (number-to-string line-number))
	   (setq result (list assertp start end data line-number)))
	  )
    result
    ))

(defun d-nosetest-output-assert/init (line-info)
  (let* ((assertp (nth 0 line-info))
	 (start (nth 1 line-info))
	 (end (nth 2 line-info))
	 (line-number (nth 4 line-info))
	 (id (d-random-number 9000)) ; It is string
	 (cmd (condition-case nil
		  (buffer-substring start end)
		(error "")))
	 ;; Remove strange end spaces
	 (cmd (replace-regexp-in-string " *$" "" cmd))
	 result
	 )
    (cond ((equal d-nosetest/latestTestType "unittest")
	   (delete-region start end)
	   (goto-char start)
	   
	   (if assertp
	       (insert id)
	     (insert (concat "self.assertEqual(" cmd ", " id ")")))

	   (save-buffer)
	   (setq result (list id start)))

	  ((equal d-nosetest/latestTestType "doctest")
	   ;; start is point-at-bol of next line of function
	   (setq result (list line-number start))))
    result
    ))


;; TODO: Use process

(defun d-nosetest-output-assert/do ()
  (interactive)
  (let* ((assert-info (d-nosetest-output-assert/line-info))
	 (id-info (d-nosetest-output-assert/init assert-info))
	 (id (nth 0 id-info))
	 (start (nth 1 id-info))
	 (end (+ start (length id)))

	 (current-window (selected-window))
	 (test-bufferp (d-nosetest/isBuffer d-nosetest/testBuffername))
	 test-window output
	 )

    (if test-bufferp
	(progn
	  (d-test)
	  ;;(setq test-window (get-buffer-window d-nosetest/testBuffername))
	  ;;(select-window test-window)

	  ))))


    ;; (call-process "nosetests" nil d-unittest-output-assert/process-buffer-name t
    ;; 		  (buffer-file-name))
    

(defun d-nosetest-output-assert/insertOutput ()
  (interactive)
  (let* ((id-info (d-nosetest-output-assert/line-info))
	 ;; id is used to find assert output. On unittest we use custom
	 ;; number. On doctest it is line number.
	 (id (if (equal d-nosetest/latestTestType "unittest")
		 ;; custom number
		 (nth 3 id-info)
	       ;; line-number
	       (nth 4 id-info)))

	 (start (nth 1 id-info))
	 (end (+ start (length id)))

	 (current-window (selected-window))
	 (current-frame (selected-frame))
	 (test-bufferp (d-nosetest/isBuffer d-nosetest/testBuffername))
	 test-window output
	 )

    (cond (d-nosetest/dualp
	   (select-frame-set-input-focus (d-nosetest/isFrame d-nosetest/testBuffername)))
	  (d-nosetest/newFramep
	   (switch-to-buffer-other-frame d-nosetest/testBuffername))
	  (t
	   (setq test-window (get-buffer-window d-nosetest/testBuffername))
	   (select-window test-window)))

    (setq output (d-nosetest-output-assert/getOutput id))
    
    (if (or d-nosetest/dualp d-nosetest/newFramep)
    	(select-frame-set-input-focus current-frame))
    (select-window current-window)
    (if (equal d-nosetest/latestTestType "unittest")
    	(delete-region start end))
    (goto-char start)
    (insert output)))

(defun d-nosetest-output-assert/getUnittestCommand ()
  (let* ((class-name (save-excursion
		       (re-search-backward "class \\(.*\\)\(.*\):" nil t)
		       (match-string 1)))
	 (file-name-sans-extension (file-name-sans-extension (buffer-name)))
	 (command (concat "python -m unittest " file-name-sans-extension "." class-name))
	 )
    command))

(defun d-nosetest-output-assert/setUnittestCommand ()
  "We couldn't use libs.logger to save file with nosetest.
Command-line unitest can save file. So we specify the command."
  (interactive)
  (setq d-nosetest/command (d-nosetest-output-assert/getUnittestCommand))
  (message (concat d-nosetest/command " is seted as command")))



;;; .
;;; === epydoc
;;; ______________________________________________________________
(require 'epydoc)


;;; .
;;; === For etc
;;; ______________________________________________________________

;(require 'python-mode)
;(require 'doctest-mode)
;;(require 'pycomplete)
;;
;;
;;(autoload 'python-mode "python-mode" "Python editing mode." t)
;;(autoload 'jython-mode "python-mode" "Python editing mode." t)
;;(autoload 'py-shell "python-mode" "Start an interactive Python interpreter in another window." t)
;;(autoload 'doctest-mode "doctest-mode" "Editing mode for Python Doctest examples." t)
;;(autoload 'py-complete "pycomplete" "Complete a symbol at point using Pymacs." t)
;;
;;(add-to-list 'auto-mode-alist '("\\.py$" . python-mode))
;;(add-to-list 'auto-mode-alist '("\\.doctest$" . doctest-mode))
;;
;;(add-to-list 'interpreter-mode-alist '("python" . python-mode))
;;(add-to-list 'interpreter-mode-alist '("jython" . jython-mode))
;;
;;(add-to-list 'load-path "/usr/share/emacs/site-lisp/pymacs")
;;


;(load-library "python-mode.el")
;(load-library "ipython.el")
;
;(require 'pycomplete)
;(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
;(autoload 'python-mode "python-mode" "Python editing mode." t)
;
;(autoload 'pymacs-load "pymacs" nil t)
;(autoload 'pymacs-eval "pymacs" nil t)
;(autoload 'pymacs-apply "pymacs")
;(autoload 'pymacs-call "pymacs")
;
;(setq interpreter-mode-alist(cons '("python" . python-mode) 
;                                  interpreter-mode-alist))
;(setq python-mode-hook
;      '(lambda () (progn
;                    (set-variable 'py-python-command "/usr/bin/python2.5")
;                    (set-variable 'py-indent-offset 4)
;                    (set-variable 'py-smart-indentation nil)
;                    (set-variable 'indent-tabs-mode nil))))
;



;(defun my-python-documentation (w)
;  "Launch PyDOC on the Word at Point"
;  (interactive
;   (list (let* ((word (thing-at-point 'word))
;		(input (read-string 
;			(format "pydoc entry%s: " 
;				(if (not word) "" (format " (default %s)" word))))))
;	   (if (string= input "") 
;	       (if (not word) (error "No pydoc args given")
;		 word) ;sinon word
;	     input)))) ;sinon input
;  (shell-command (concat py-python-command " -c \"from pydoc import help;help(\'" w "\'\")") "*PYDOCS*")
;  (view-buffer-other-window "*PYDOCS*" t 'kill-buffer-and-window))


;;; .
;;; === Re-define functions
;;; ______________________________________________________________
;; I have no idea why I have to re-define this functions, but to use these
;; functions I have to re-define the functions.

;; #1305101300 The cause of the problem is "(require 'python)" conflict
;; with (require 'python-mode). To solve this, I have replace python -->
;; python-mode.

;; This is not tested on Windows. So this section is commented.

;; py-shell is modified. (sit-for 2) is added after call of
;; make-comint-in-buffer.


;; (defun py-shell (&optional argprompt dedicated pyshellname switch sepchar py-buffer-name done split)
;;   "Start an interactive Python interpreter in another window.
;; Interactively, \\[universal-argument] 4 prompts for a buffer.
;; \\[universal-argument] 2 prompts for `py-python-command-args'.
;; If `default-directory' is a remote file name, it is also prompted
;; to change if called with a prefix arg.

;; Returns py-shell's buffer-name.
;; Optional string PYSHELLNAME overrides default `py-shell-name'.
;; Optional symbol SWITCH ('switch/'noswitch) precedes `py-switch-buffers-on-execute-p'
;; When SEPCHAR is given, `py-shell' must not detect the file-separator.
;; BUFFER allows specifying a name, the Python process is connected to
;; When DONE is `t', `py-shell-manage-windows' is omitted
;; Optional symbol SPLIT ('split/'nosplit) precedes `py-split-buffers-on-execute-p'
;; "
;;   (interactive "P")
;;   (let* ((coding-system-for-read 'utf-8)
;;          (coding-system-for-write 'utf-8)
;;          (switch (or switch py-switch-buffers-on-execute-p))
;;          (split (or split py-split-windows-on-execute-p))
;;          (sepchar (or sepchar (char-to-string py-separator-char)))
;;          (args py-python-command-args)
;;          (oldbuf (current-buffer))
;;          (path (getenv "PYTHONPATH"))
;;          ;; make classic python.el forms usable, to import emacs.py
;;          (process-environment
;;           (cons (concat "PYTHONPATH="
;;                         (if path (concat path path-separator))
;;                         data-directory)
;;                 process-environment))
;;          ;; reset later on
;;          (py-buffer-name
;;           (or py-buffer-name
;;               (when argprompt
;;                 (cond
;;                  ((eq 4 (prefix-numeric-value argprompt))
;;                   (setq py-buffer-name
;;                         (prog1
;;                             (read-buffer "Py-Shell buffer: "
;;                                          (generate-new-buffer-name (py-buffer-name-prepare (or pyshellname py-shell-name) sepchar)))
;;                           (if (file-remote-p default-directory)
;;                               ;; It must be possible to declare a local default-directory.
;;                               (setq default-directory
;;                                     (expand-file-name
;;                                      (read-file-name
;;                                       "Default directory: " default-directory default-directory
;;                                       t nil 'file-directory-p)))))))
;;                  ((and (eq 2 (prefix-numeric-value argprompt))
;;                        (fboundp 'split-string))
;;                   (setq args (split-string
;;                               (read-string "Py-Shell arguments: "
;;                                            (concat
;;                                             (mapconcat 'identity py-python-command-args " ") " ")))))))))
;;          (pyshellname (or pyshellname (py-choose-shell)))
;;          ;; If we use a pipe, Unicode characters are not printed
;;          ;; correctly (Bug#5794) and IPython does not work at
;;          ;; all (Bug#5390). python.el
;;          (process-connection-type t)
;;          ;; already in py-choose-shell
;;          (py-use-local-default
;;           (if (not (string= "" py-shell-local-path))
;;               (expand-file-name py-shell-local-path)
;;             (when py-use-local-default
;;               (error "Abort: `py-use-local-default' is set to `t' but `py-shell-local-path' is empty. Maybe call `py-toggle-local-default-use'"))))
;;          (py-buffer-name-prepare (unless (and py-buffer-name (not dedicated))
;;                                    (py-buffer-name-prepare (or pyshellname py-shell-name) sepchar dedicated)))
;;          (py-buffer-name (or py-buffer-name-prepare py-buffer-name))
;;          (executable (cond (pyshellname)
;;                            (py-buffer-name
;;                             (py-report-executable py-buffer-name))))
;;          proc)
;;     (unless (comint-check-proc py-buffer-name)
;;       (set-buffer (apply 'make-comint-in-buffer executable py-buffer-name executable nil args))
;;       (sit-for 2)
;;       (set (make-local-variable 'comint-prompt-regexp)
;;            (cond ((string-match "[iI][pP]ython[[:alnum:]*-]*$" py-buffer-name)
;;                   (concat "\\("
;;                           (mapconcat 'identity
;;                                      (delq nil (list py-shell-input-prompt-1-regexp py-shell-input-prompt-2-regexp ipython-de-input-prompt-regexp ipython-de-output-prompt-regexp py-pdbtrack-input-prompt py-pydbtrack-input-prompt))
;;                                      "\\|")
;;                           "\\)"))
;;                  (t (concat "\\("
;;                             (mapconcat 'identity
;;                                        (delq nil (list py-shell-input-prompt-1-regexp py-shell-input-prompt-2-regexp py-pdbtrack-input-prompt py-pydbtrack-input-prompt))
;;                                        "\\|")
;;                             "\\)"))))
;;       (set (make-local-variable 'comint-input-filter) 'py-history-input-filter)
;;       (set (make-local-variable 'comint-prompt-read-only) py-shell-prompt-read-only)
;;       (set (make-local-variable 'comint-use-prompt-regexp) nil)
;;       (set (make-local-variable 'compilation-error-regexp-alist)
;;            python-compilation-regexp-alist)
;;       ;; (setq completion-at-point-functions nil)
;;       (when py-fontify-shell-buffer-p
;;         (set (make-local-variable 'font-lock-defaults)
;;              '(py-font-lock-keywords nil nil nil nil
;;                                      (font-lock-syntactic-keywords
;;                                       . py-font-lock-syntactic-keywords))))
;;       (set (make-local-variable 'comment-start) "# ")
;;       (set (make-local-variable 'comment-start-skip) "^[ \t]*#+ *")
;;       (set (make-local-variable 'comment-column) 40)
;;       (set (make-local-variable 'comment-indent-function) #'py-comment-indent-function)
;;       (font-lock-fontify-buffer))
;;     (set (make-local-variable 'indent-region-function) 'py-indent-region)
;;     (set (make-local-variable 'indent-line-function) 'py-indent-line)
;;     ;; (font-lock-unfontify-region (point-min) (line-beginning-position))
;;     (setq proc (get-buffer-process py-buffer-name))
;;     ;; (goto-char (point-max))
;;     (move-marker (process-mark proc) (point-max))
;;     ;; (funcall (process-filter proc) proc "")
;;     (py-shell-send-setup-code proc)
;;     ;; (accept-process-output proc 1)
;;     (compilation-shell-minor-mode 1)
;;     ;;(sit-for 0.1)
;;     (setq comint-input-sender 'py-shell-simple-send)
;;     (setq comint-input-ring-file-name
;;           (cond ((string-match "[iI][pP]ython[[:alnum:]*-]*$" py-buffer-name)
;;                  (if py-honor-IPYTHONDIR-p
;;                      (if (getenv "IPYTHONDIR")
;;                          (concat (getenv "IPYTHONDIR") "/history")
;;                        py-ipython-history)
;;                    py-ipython-history))
;;                 (t
;;                  (if py-honor-PYTHONHISTORY-p
;;                      (if (getenv "PYTHONHISTORY")
;;                          (concat (getenv "PYTHONHISTORY") "/" (py-report-executable py-buffer-name) "_history")
;;                        py-ipython-history)
;;                    py-ipython-history))
;;                 ;; (dedicated
;;                 ;; (concat "~/." (substring py-buffer-name 0 (string-match "-" py-buffer-name)) "_history"))
;;                 ;; .pyhistory might be locked from outside Emacs
;;                 ;; (t "~/.pyhistory")
;;                 ;; (t (concat "~/." (py-report-executable py-buffer-name) "_history"))
;;                 ))
;;     (comint-read-input-ring t)
;;     (set-process-sentinel (get-buffer-process py-buffer-name)
;;                           #'shell-write-history-on-exit)
;;     ;; (comint-send-string proc "import emacs\n")
;;     ;; (process-send-string proc "import emacs")
;;     (add-hook 'comint-output-filter-functions
;;               'ansi-color-process-output)

;;     ;; (add-hook 'comint-preoutput-filter-functions
;;     ;; '(ansi-color-filter-apply
;;     ;; (lambda (string) (buffer-substring comint-last-output-start
;;     ;; (process-mark (get-buffer-process (current-buffer)))))))
;;     ;; (ansi-color-for-comint-mode-on)
;;     (use-local-map py-shell-map)
;;     ;; pdbtrack
;;     (add-hook 'comint-output-filter-functions 'py-pdbtrack-track-stack-file t)
;;     (remove-hook 'comint-output-filter-functions 'python-pdbtrack-track-stack-file t)
;;     (setq py-pdbtrack-do-tracking-p t)
;;     (set-syntax-table python-mode-syntax-table)
;;     ;; (add-hook 'py-shell-hook 'py-dirstack-hook)
;;     (when py-shell-hook (run-hooks 'py-shell-hook))
;;     (unless done (py-shell-manage-windows switch split oldbuf py-buffer-name))
;;     py-buffer-name))



;; (defun ipython-complete ()
;;   "Try to complete the python symbol before point. Only knows about the stuff
;; in the current *Python* session."
;;   (interactive)
;;   (let* ((ugly-return nil)
;; 	 (sep ";")
;; 	 (python-process (or (get-buffer-process (current-buffer))
;;                                         ;XXX hack for .py buffers
;; 			     (get-process py-which-bufname)))
;; 	 ;; XXX currently we go backwards to find the beginning of an
;; 	 ;; expression part; a more powerful approach in the future might be
;; 	 ;; to let ipython have the complete line, so that context can be used
;; 	 ;; to do things like filename completion etc.
;; 	 (beg (save-excursion (skip-chars-backward "a-z0-9A-Z_./\-" (point-at-bol))
;; 			      (point)))
;; 	 (end (point))
;; 	 (line (buffer-substring-no-properties (point-at-bol) end))
;; 	 (pattern (buffer-substring-no-properties beg end))
;; 	 (completions nil)
;; 	 (completion-table nil)
;; 	 completion
;;          (comint-preoutput-filter-functions
;;           (append comint-preoutput-filter-functions
;;                   '(ansi-color-filter-apply
;;                     (lambda (string)
;;                       (setq ugly-return (concat ugly-return string))
;;                       "")))))
;;     (process-send-string python-process
;; 			 (format ipython-completion-command-string pattern line))
;;     (accept-process-output python-process)
;;     (setq completions
;; 	  (split-string (substring ugly-return 0 (position ?\n ugly-return)) sep))
;;                                         ;(message (format "DEBUG completions: %S" completions))
;;     (setq completion-table (loop for str in completions
;; 				 collect (list str nil)))
;;     (setq completion (try-completion pattern completion-table))
;;     (cond ((eq completion t))
;; 	  ((null completion)
;; 	   (message "Can't find completion for \"%s\" based on line %s" pattern line)
;; 	   (ding))
;; 	  ((not (string= pattern completion))
;; 	   (delete-region (- end (length pattern)) end)
;; 	   (insert completion))
;; 	  (t
;; 	   (message "Making completion list...")
;; 	   (with-output-to-temp-buffer "*IPython Completions*"
;; 	     (display-completion-list (all-completions pattern completion-table)))
;; 	   (message "Making completion list...%s" "done")))))

;; (defun py-complete ()
;;   "Complete symbol before point using Pymacs. "
;;   (interactive)
;;   (let ((symbol (py-complete-enhanced-symbol-before-point)))
;;     (if (string= "" symbol)
;;         (tab-to-tab-stop)
;;       (let ((completions
;;              (py-complete-completions-for-symbol symbol)))
;;         (if completions
;;             (let* (completion
;;                    (lastsym (car (last (split-string symbol "\\."))))
;;                    (lastlen (length lastsym)))
;;               (cond ((null (cdr completions))
;;                      (setq completion (car completions)))
;;                     (t
;;                      (setq completion (try-completion lastsym completions))
;;                      (message "Making completion list...")
;;                      (with-output-to-temp-buffer "*PythonCompletions*"
;;                        (display-completion-list completions))
;;                      (message "Making completion list...%s" "done")))
;;               (when (and (stringp completion)
;;                          (> (length completion) lastlen))
;;                 (insert (substring completion lastlen))))
;;           (message "Can't find completion for \"%s\"" symbol)
;;           (ding))))))


(provide 'python-config)
