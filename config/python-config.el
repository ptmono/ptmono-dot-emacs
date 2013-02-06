
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
(setq py-install-directory (concat d-dir-emacs "cvs/python-mode"))


;;; === For pymacs
;;; --------------------------------------------------------------

;(load-library "python-mode.el")
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
;;(eval-after-load "pymacs"                                                                                                        
;;  '(add-to-list 'pymacs-load-path YOUR-PYMACS-DIRECTORY"))                                            

;;; === For ipython and python shell
;;; --------------------------------------------------------------
;; Added in init.el
;(add-to-list 'load-path (concat d-dir-emacs "cvs/ipython/docs/emacs/"))
(require 'ipython)
(setq ipython-completion-command-string "print(';'.join(get_ipython().complete('%s', '%s')[1])) #PYTHON-MODE SILENT\n")

;; Let's use python of windows in windows
(when (d-windowp)
  ;(setq python-python-command "c:/Python27/python.exe")
  (setq python-python-command "c:/Program Files (x86)/IronPython 2.7/ipy.exe")
  )

; from http://www.emacswiki.org/emacs/PythonMode
; The definition in ipython.el is wrong.

;; To collect output we have to modify ipyton.bat. Add -u option
;; @C:\Python27\python.exe C:\Python27\scripts\ipython.py %* to
;; @C:\Python27\python.exe -u C:\Python27\scripts\ipython.py %*
;; See more worknote_xp.muse#1102150621
(when (d-windowp)
  (setq ipython-command "C:\Python27\scripts\ipython.bat")
  )
;(setq py-python-command-args '("--autocall" "0"))
;; Default is ("-i" "-colors" "LightBG")
;(setq py-python-command-args '("-pylab" "-colors" "LightBG"))

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
(custom-set-variables
 '(ansi-color-names-vector ["ligth-gray" "red" "green" "yellow" "blue" "magenta" "cyan" "white"]))




;;; === For python-mode
;;; --------------------------------------------------------------
;; python-mode do not include the functions of completion.
(require 'python-mode)
(setq py-complete-function 'ipython-complete
      py-shell-complete-function 'ipython-complete
      py-shell-name "ipython"
      py-which-bufname "IPython")
(setq py-use-local-default t)
(setq py-shell-local-path "/media/cvs/Documents/works/0cvs/trunk/dotemacs.d/cvs/ipython/ipython.py")
(setq py-shell-name "ipython")	 ;For version 6.1.1 of python-mode

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


;;; = abbrev
;; python.el에 포함되어 있습니다. 이유는 모르겠지만, 시작시 로드하지 않아서 여기에
;; 붙여요.
;; Moved to abbrev-config.el


;;; === Completion
;;; --------------------------------------------------------------
;; To enable completion in python-mode
;; Use 'completion-at-point instead 'py-complete.
(load-library "pycomplete.el")
(require 'pycomplete)


;;; === For anything-ipython
;;; --------------------------------------------------------------

; The package requres anything. el file contains following
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



;;; === Inserting with key
;;; --------------------------------------------------------------
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


;;; === For folding
;;; --------------------------------------------------------------
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

  (if (d-not-windowp)
      (flymake-mode))
)




;;; === For cython
;;; --------------------------------------------------------------

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



;;; === For pylookup
;;; --------------------------------------------------------------

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


;;; === Syntax checking
;;; --------------------------------------------------------------
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



;;; === nosetests
;;; --------------------------------------------------------------
;; - Use commands M-x d-nosetest-doctest, M-x d-nosetest-unittest
;; - We can use on dual monitor. M-x d-nosetest/toggle-dualp
;; - To use new frame. M-x d-nosetest/toggle-newFramep
;; - Restore the windows with M-x d-test-restore that binded with C-c d r.

(defvar d-nosetest/testBuffername "*nosetest*")
(defvar d-nosetest/targetBuffername nil)
(defvar d-nosetest/command nil "Full command. It require to create 'd-test.")
(defvar d-nosetest/command-doctest (if (d-not-windowp)
				       (concat "nosetests --with-doctest")
				     (concat "ipy.exe -m doctest")))
(defvar d-nosetest/command-unittest "nosetests")

(defvar d-nosetest/newFramep nil)
(defvar d-nosetest/dualp nil "If t, we use dual monitor mode.")
(defvar d-nosetest/windows-register ?R)

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
  (let* ((buffer-name (file-name-nondirectory (buffer-file-name)))
	 (test-buffer-name d-nosetest/testBuffername)
	 (nose-command-only (if (equal type "doctest")
				d-nosetest/command-doctest
			      d-nosetest/command-unittest))
	 (nose-command (concat nose-command-only " " buffer-name))
	 (frame (selected-frame))
	 (window (selected-window)))

    (setq d-nosetest/command nose-command)
    (condition-case nil
	(d-nosetest/resetTestShell)
      (error nil))

    (defun d-test ()
      ""
      (interactive)

      (let* ((frame (selected-frame))
	     (window (selected-window))
	     )
	(window-configuration-to-register d-nosetest/windows-register)
	;; Frame determination
	(d-nosetest/openTestShell)
      
	(goto-char (point-max))
	(insert d-nosetest/command)
	(comint-send-input)

	;; Restore cursor
	(select-frame-set-input-focus frame)
	(select-window window)))

    (defun d-test-restore ()
      (d-nosetest/restoreWindow))

    ;; Restore cursor
    (select-frame-set-input-focus frame)
    (select-window window)
    ))

(defun d-nosetest/resetTestShell ()
  (let* ((frame (d-nosetest/isFrame d-nosetest/testBuffername))
	 (window (d-nosetest/isWindow d-nosetest/testBuffername)))

    (cond 
     ;; We will use test frame on dual monitor.
     (d-nosetest/dualp
      (if frame
	  (progn
	    (select-frame-set-input-focus frame)
	    (kill-buffer d-nosetest/testBuffername)
	    (shell d-nosetest/testBuffername))
	(d-nosetest/createTestFrame)))
     ;; If window on frame, just re-create testBuffer.
     (window
      (select-window (get-buffer-window d-nosetest/testBuffername))
      (kill-buffer d-nosetest/testBuffername)
      (shell d-nosetest/testBuffername))
     ;; other
     (t
      (condition-case nil
	  (kill-buffer d-nosetest/testBuffername)
	(error nil))
      (shell d-nosetest/testBuffername))
     )))
	
	     

(defun d-nosetest/openTestShell ()
  (cond (d-nosetest/dualp
	 (select-frame-set-input-focus (d-nosetest/isFrame d-nosetest/testBuffername)))
	(d-nosetest/newFramep
	 (switch-to-buffer-other-frame d-nosetest/testBuffername))
	(t
	 (if (d-nosetest/isWindow d-nosetest/testBuffername)
	     ;; It is used if test window exists.
	     (select-window (get-buffer-window d-nosetest/testBuffername))
	   (switch-to-buffer-other-window d-nosetest/testBuffername)))))
    

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

(defalias 'd-python-set-nosetest-doctest 'd-nosetest-doctest)
(defalias 'd-python-set-nosetest-unittest 'd-nosetest-unittest)
  
	

;;; === For etc
;;; --------------------------------------------------------------

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


(provide 'python-config)
