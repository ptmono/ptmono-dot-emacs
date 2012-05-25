

(defvar font-lock-format-specifier-face		'font-lock-format-specifier-face
  "Face name to use for format specifiers.")

(defface font-lock-format-specifier-face
  '((t (:foreground "OrangeRed1")))
  "Font Lock mode face used to highlight format specifiers."
  :group 'font-lock-faces)

(defvar d-cc-format-specifier-regexp
  (concat "[^%]\\(%\\([[:digit:]]+\\$\\)?[-+' #0*]*"
					"\\([[:digit:]]*"
					"\\|\\*"
					"\\|\\*[[:digit:]]+\\$\\)\\(\\.\\([[:digit:]]*"
					"\\|\\*"
					"\\|\\*[[:digit:]]+\\$\\)\\)?\\([hlLjzt]"
					"\\|ll"
					"\\|hh\\)?\\([aAbdiuoxXDOUfFeEgGcCsSpn]"
					"\\|\\[\\^?.[^]]*\\]\\)"
					"\\)"))

;;; === Coding Style
;;; --------------------------------------------------------------
;; There are coding styles in emacs. c-style-alist contains the list. Each
;; styles are determined by few variables such as c-basic-offset,
;; c-comment-only-line-offset, c-offsets-alist.

(require 'cc-mode)
(add-to-list 'c-style-alist
	     ;; vitual studio
	     '("vbs"
	       (c-basic-offset  . 8)
	       (c-comment-only-line-offset . 0)
	       (c-hanging-braces-alist . ((brace-list-open)
					  (brace-entry-open)
					  (substatement-open after)
					  (block-close . c-snug-do-while)
					  (arglist-cont-nonempty)))
	       (c-cleanup-list . (brace-else-brace))
	       (c-offsets-alist . ((statement-block-intro . +)
				   (knr-argdecl-intro     . 0)
				   (substatement-open     . 0)
				   (substatement-label    . 0)
				   (label                 . 0)
				   (statement-cont        . +)
				   ;; For argument list
				   (arglist-intro . (add c-lineup-whitesmith-in-block
							 c-indent-multi-line-block))
				   (arglist-cont . (add c-lineup-after-whitesmith-blocks
							c-indent-multi-line-block))
				   (arglist-cont-nonempty . (add c-lineup-whitesmith-in-block
								 c-indent-multi-line-block))
				   (arglist-close . c-lineup-whitesmith-in-block)))))


;; (custom-set-variables
;;  '(c-default-style '((java-mode . "java")
;; 		     (awk-mode . "awk")
;; 		     (c++-mode . "vbs")
;; 		     (other . "gnu"))))



;;; === C-mode
;;; --------------------------------------------------------------
(font-lock-add-keywords 'c-mode
			'(("\\<\\(FIXME\\):" 1 font-lock-warning-face prepend)
			  ("\\<\\(and\\|or\\|not\\)\\>" . font-lock-keyword-face)))

;; d-cc-format-specifier-regexp is so long. So I want to create that with
;; concat. To apply that we use list function. It is from
;; whitespace.el(the function whitespace-color-on
(font-lock-add-keywords 'c-mode
			(list
			 (list d-cc-format-specifier-regexp 1 font-lock-format-specifier-face t)
			 (list "\\(%%\\)" 1 font-lock-format-specifier-face t)
			 ))


;;; === C++-mode
;;; --------------------------------------------------------------
; - http://www.emacswiki.org/emacs/CPlusPlusMode
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))


;;; syntax check
(when (load "flymake" t)
  (load-library "flymake-cursor")
  ;;; ccplint.py
  ;; ccplint.py is
  ;; from http://google-styleguide.googlecode.com/svn/trunk/cpplint/cpplint.py
  ;; It follows google c++ style
  ;; http://google-styleguide.googlecode.com/svn/trunk/cppguide.xml
  (defvar d-cc-codechecker
    "clang" ;"cpplint.py"
    "You can choose the checker. Currently we can use 'clang' or 'cpplint.py'"
    )

  ;; cpplint.py --filter= shows the options. We can disable/enable chekings
  (defvar d-cc-codechecker/cpplint-filter
    "--filter=-legal/copyright,-whitespace/tab,-build/include,
-whitespace/line_length,-whitespace/labels,
-runtime/explicit")
  (defun d-cc-codechecker/cpplint-flymake-int ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
		       'flymake-create-temp-inplace))
	   (local-file (file-relative-name
			temp-file
			(file-name-directory buffer-file-name))))
      (list "cpplint.py" (list d-cc-codechecker/cpplint-filter local-file))))
  
;;; Using clang and flymake
  (require 'auto-complete-clang)		;requires ac-clang-lang-option
  (require 'autocomplete-config)		;requires d-ac-clang-flags
  
  (defun d-cc-codechecker/clang-flymake-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
		       'flymake-create-temp-inplace))
	   (local-file (file-relative-name
			temp-file
			(file-name-directory buffer-file-name)))
	   (language (ac-clang-lang-option))
	   (pre-arguments (list
			  "-x" language
			  "-fsyntax-only" "-fno-color-diagnostics" local-file))
	   (arguments (append d-ac-clang-flags pre-arguments)))
      (list "clang" arguments)))
  
  (defun d-cc-codechecker/flymake-init ()
    (cond ((equal d-cc-codechecker "clang")
	   (d-cc-codechecker/clang-flymake-init))
	  ((equal d-cc-codechecker "cpplint.py")
	   (d-cc-codechecker/cpplint-flymake-int))))
  
  (add-to-list 'flymake-allowed-file-name-masks
	       '("\\.c$" d-cc-codechecker/flymake-init))
  (add-to-list 'flymake-allowed-file-name-masks
	       '("\\.cc$" d-cc-codechecker/flymake-init))
  (add-to-list 'flymake-allowed-file-name-masks
	       '("\\.h$" d-cc-codechecker/flymake-init))
  (add-to-list 'flymake-allowed-file-name-masks
	       '("\\.hh$" d-cc-codechecker/flymake-init))
  (add-to-list 'flymake-allowed-file-name-masks
	       '("\\.hpp$" d-cc-codechecker/flymake-init))
  (add-to-list 'flymake-allowed-file-name-masks
	       '("\\.cpp$" d-cc-codechecker/flymake-init)))

(defun d-cc-codechecker/flymake-hook ()
  ;; If you need then load.
  ;(flymake-mode)

  ;; We re-define flymake-post-syntax-check by the problem of clang with
  ;; c++. FC15/clang2.8, FC16/clang2.9 has a problem called "_ValueTypeI"
  ;; myself. These version clangs couldn't exactly read c++ header
  ;; files(libstdc++-devel). It allways produce error message. The process
  ;; of clang in emacs recognize this as "process exited with code 1".
  ;; Then flymake switch off itself and popup "CFGERR" message. See more
  ;; worknote2.muse#1202170336
  (defun flymake-post-syntax-check (exit-status command)
    (setq flymake-err-info flymake-new-err-info)
    (setq flymake-new-err-info nil)
    (setq flymake-err-info
	  (flymake-fix-line-numbers
	   flymake-err-info 1 (flymake-count-lines)))
    (flymake-delete-own-overlays)
    (flymake-highlight-err-lines flymake-err-info)
    (let (err-count warn-count)
      (setq err-count (flymake-get-err-count flymake-err-info "e"))
      (setq warn-count  (flymake-get-err-count flymake-err-info "w"))
      (flymake-log 2 "%s: %d error(s), %d warning(s) in %.2f second(s)"
		   (buffer-name) err-count warn-count
		   (- (flymake-float-time) flymake-check-start-time))
      (setq flymake-check-start-time nil)

      (if (and (equal 0 err-count) (equal 0 warn-count))
	  ;; Just pass in c++-mode
	  (if (or (equal 0 exit-status) (equal major-mode 'c++-mode))
	      (flymake-report-status "" "")	; PASSED
	    (if (not flymake-check-was-interrupted)
		(flymake-report-fatal-status "CFGERR"
					     (format "Configuration error has occurred while running %s" command))
	      (flymake-report-status nil ""))) ; "STOPPED"
	(flymake-report-status (format "%d/%d" err-count warn-count) "")))))

(add-hook 'c-mode-common-hook 'd-cc-codechecker/flymake-hook)

;;; member-function
;; expand-member-functions will insert all methods into cpp file from
;; header file.
(require 'member-functions)


;;; === doxymacs
;;; --------------------------------------------------------------
;; To change keymap original source was modified. See keybinding.el
(require 'doxymacs)
(add-hook 'c-mode-common-hook 'doxymacs-mode)

(defun my-doxymacs-font-lock-hook ()
  (if (or (eq major-mode 'c-mode) (eq major-mode 'c++-mode))
      (doxymacs-font-lock)))
(add-hook 'font-lock-mode-hook 'my-doxymacs-font-lock-hook)

;; from http://www.emacswiki.org/emacs/DoxyMacs
(defun my-javadoc-return () 
  "Advanced `newline' command for Javadoc multiline comments.   
Insert a `*' at the beggining of the new line if inside of a comment."
  (interactive "*")
  (let* ((last (point))
         (is-inside
          (if (search-backward "*/" nil t)
              ;; there are some comment endings - search forward
              (search-forward "/*" last t)
            ;; it's the only comment - search backward
            (goto-char last)
            (search-backward "/*" nil t))))
    ;; go to last char position
    (goto-char last)
    ;; the point is inside some comment, insert `*'
    (if is-inside
        (progn
          (newline-and-indent)
          (insert "*"))
      ;; else insert only new-line
      (newline))))

(add-hook 'c++-mode-hook
          (lambda ()
            (local-set-key (kbd "<RET>") 'my-javadoc-return)))


;;; === Qt
;;; --------------------------------------------------------------
(c-add-style "qt-gnu" '("gnu" 
                        (c-access-key .
"\\<\\(signals\\|public\\|protected\\|private\\|public slots\\|protected slots\\|private slots\\):")
                         (c-basic-offset . 4)))


;; syntax-highlighting for Qt
;; (based on work by Arndt Gulbrandsen, Troll Tech)
(defun jk/c-mode-common-hook ()
  "Set up c-mode and related modes.

Includes support for Qt code (signal, slots and alikes)."

  ;; base-style
  (c-set-style "stroustrup")
  ;; set auto cr mode
  (c-toggle-auto-hungry-state 1)

  ;; qt keywords and stuff ...
  ;; set up indenting correctly for new qt kewords
  (setq c-protection-key (concat "\\<\\(public\\|public slot\\|protected"
                                 "\\|protected slot\\|private\\|private slot"
                                 "\\)\\>")
        c-C++-access-key (concat "\\<\\(signals\\|public\\|protected\\|private"
                                 "\\|public slots\\|protected slots\\|private slots"
                                 "\\)\\>[ \t]*:"))
  (progn
    ;; modify the colour of slots to match public, private, etc ...
    (font-lock-add-keywords 'c++-mode
                            '(("\\<\\(slots\\|signals\\)\\>" . font-lock-type-face)))
    ;; make new font for rest of qt keywords
    (make-face 'qt-keywords-face)
    (set-face-foreground 'qt-keywords-face "BlueViolet")
    ;; qt keywords
    (font-lock-add-keywords 'c++-mode
                            '(("\\<Q_OBJECT\\>" . 'qt-keywords-face)))
    (font-lock-add-keywords 'c++-mode
                            '(("\\<SIGNAL\\|SLOT\\>" . 'qt-keywords-face)))
    (font-lock-add-keywords 'c++-mode
                            '(("\\<Q[A-Z][A-Za-z]*" . 'qt-keywords-face)))
    ))
(add-hook 'c-mode-common-hook 'jk/c-mode-common-hook)

;; Other things I like are, for example,


;; cc-mode
(require 'cc-mode)

;; To fix indenting and highlighting
(setq c-C++-access-key "\\<\\(slots\\|signals\\|private\\|protected\\|public\\)\\>[ \t]*[(slots\\|signals)]*[ \t]*:")
(font-lock-add-keywords 'c++-mode '(("\\<\\(Q_OBJECT\\|public slots\\|public signals\\|private slots\\|private signals\\|protected slots\\|protected signals\\)\\>" . font-lock-constant-face)))

;; automatic indent on return in cc-mode
;(define-key c-mode-base-map [RET] 'newline-and-indent)

;; Do not check for old-style (K&R) function declarations;
;; this speeds up indenting a lot.
(setq c-recognize-knr-p nil)

;; Switch fromm *.<impl> to *.<head> and vice versa
(defun switch-cc-to-h ()
  (interactive)
  (when (string-match "^\\(.*\\)\\.\\([^.]*\\)$" buffer-file-name)
    (let ((name (match-string 1 buffer-file-name))
         (suffix (match-string 2 buffer-file-name)))
      (cond ((string-match suffix "c\\|cc\\|C\\|cpp")
            (cond ((file-exists-p (concat name ".h"))
                   (find-file (concat name ".h"))
                  )
                  ((file-exists-p (concat name ".hh"))
                   (find-file (concat name ".hh"))
                  )
           ))
           ((string-match suffix "h\\|hh")
            (cond ((file-exists-p (concat name ".cc"))
                   (find-file (concat name ".cc"))
                  )
                  ((file-exists-p (concat name ".C"))
                   (find-file (concat name ".C"))
                  )
                  ((file-exists-p (concat name ".cpp"))
                   (find-file (concat name ".cpp"))
                  )
                  ((file-exists-p (concat name ".c"))
                   (find-file (concat name ".c"))
                  )))))))

;;; For qt doc
(require 'qtdoc)
;; Use M-x qtdoc-lookup

;;; To edit qt pro file
(require 'qt-pro)
(add-to-list 'auto-mode-alist '("\\.pr[io]$" . qt-pro-mode))

;;; - Examples

;; (font-lock-add-keywords 'c++-mode
;;   '(("\\<[[:alnum:]]+_cast[[:space:]]*<\\([[:alnum:][:space:]*]+\\)>[[:space:]]*(\\([[:alnum:][:space:]*]+\\))"
;;   (1 font-lock-type-face t)
;;   (2 font-lock-type-face t))))


;; (defface font-lock-bracket-face
;;   '((t (:foreground "cyan3")))
;;   "Font lock mode face for brackets, e.g. '(', ']', etc."
;;   :group 'font-lock-faces)
;; (defvar font-lock-bracket-face 'font-lock-bracket-face
;;   "Font lock mode face for backets.  Changing this directly
;;   affects only new buffers.")

;; (setq c-operators-regexp
;;       (regexp-opt '("+" "-" "*" "/" "%" "!"
;;                     "&" "^" "~" "|"
;;                     "=" "<" ">"
;;                     "." "," ";" ":")))
;; (setq c-brackets-regexp
;;       (regexp-opt '("(" ")" "[" "]" "{" "}")))
;; (setq c-types-regexp
;;       (concat
;;        "\\<[_a-zA-Z][_a-zA-Z0-9]*_t\\>" "\\|"
;;        (regexp-opt '("unsigned" "int" "char" "float" "void") 'words)))

;; (setq warning-words-regexp
;;       (regexp-opt '("FIXME" "TODO" "BUG" "XXX" "DEBUG")))

;; (eval-after-load "cc-mode"
;;   '(progn
;;      (font-lock-add-keywords
;;       'c-mode
;;       (list
;;        (cons c-operators-regexp 'font-lock-builtin-face)
;;        (cons c-brackets-regexp 'font-lock-bracket-face)
;;        (cons c-types-regexp 'font-lock-type-face)
;;        (cons warning-words-regexp 'font-lock-warning-face)))
;;      ))


;;; === csharp
;;; --------------------------------------------------------------
(autoload 'csharp-mode "csharp-mode" "Major mode for editing C# code." t)
(setq auto-mode-alist
      (append '(("\\.cs$" . csharp-mode)) auto-mode-alist))

;; (defun my-csharp-mode-fn ()
;;   "function that runs when csharp-mode is initialized for a buffer."
;;   (turn-on-auto-revert-mode)
;;   (setq indent-tabs-mode nil)
;;   (require 'flymake)
;;   (flymake-mode 1)
;;   (require 'yasnippet)
;;   (yas/minor-mode-on)
;;   (require 'rfringe)
;;    ...insert more code here...
;;    ...including any custom key bindings you might want ...
;;    )
;; (add-hook  'csharp-mode-hook 'my-csharp-mode-fn t)



;;; === Tools
;;; --------------------------------------------------------------
(defun d-scons-set ()
  "Set scons test environemnt of current directory."
  (interactive)
  (condition-case nil
      (kill-buffer "*test*")
    (error nil))
  (shell "*test*")
  (defun d-test ()
    (interactive)
    (split-window-vertically)
    (other-window 1)
    (switch-to-buffer "*test*" nil nil)
    (insert "scons; build/Test")
    (comint-send-input)
    )
  )
