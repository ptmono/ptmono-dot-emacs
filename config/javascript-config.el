
;;; === major mode
;;; --------------------------------------------------------------
;; Default for js-mode
;(add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode))
;(autoload 'javascript-mode "javascript" nil t)


;; Use js2-mode

;; a fork of js2-mode is available from mooz's project page. Steve's
;; original repository isn’t used for development anymore.
;; cvs/js2 is steve's repository. cvs/js2-mode is mooz's repository, it
;; requires to use emacs24 branch.

;; (add-to-list 'load-path (concat d-dir-emacs "cvs/js2/build/"))
(add-to-list 'load-path (concat d-dir-emacs "cvs/js2-mode"))
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

(add-hook 'js2-mode-hook 'outline-minor-mode)
(add-hook 'js2-mode-hook 'moz-minor-mode)

;; flymake-jslint


;;; flymake-jshint
;; jshint-mode uses node.js. Basically js2-mode provides basic syntax
;; checking with line. If you want to use jshint, "M-x flymake-mode".
(add-to-list 'load-path (concat d-dir-emacs"cvs/jshint-mode"))
(require 'flymake-jshint)
(add-hook 'javascript-mode-hook
	  (lambda () (flymake-mode t)))



;;; === moz
;;; --------------------------------------------------------------
; from http://wiki.github.com/bard/mozrepl/emacs-integration
;* C-c C-s: open a MozRepl interaction buffer and switch to it
;* C-c C-l: save the current buffer and load it in MozRepl
;* C-M-x: send the current function (as recognized by c-mark-function) to MozRepl
;* C-c C-c: send the current function to MozRepl and switch to the interaction buffer
;* C-c C-r: send the current region to MozRepl
;
;In the interaction buffer:
;
;* C-c c: insert the current name of the REPL plus the dot operator (usually repl.)

(require 'moz)

(autoload 'moz-minor-mode "moz" "Mozilla Minor and Inferior Mozilla Modes" t)


(defun javascript-custom-setup ()
  (moz-minor-mode 1))

(add-hook 'javascript-mode-hook 'javascript-custom-setup)

;; It has problem. I have no idea.
;; (add-to-list 'auto-mode-alist '("\\.js$" . moz-minor-mode))
;; (add-hook 'javascript-mode-hook 'moz-minor-mode)
;; It added js2-mode-hook. Se js2-config.el


; requires d-worknote2 and d-library
; cmd = 'emacsclient -c -e "(d-frame-set-phw \\"84x100+0\\")"'
(defun d-moz-open-worknote (geometry)
  "The function requires d-worknote2.el and d-library.el"
  (d-frame-set-phw geometry)
  (find-file (car d-worknote-list)))


;;; === Shell
;;; --------------------------------------------------------------
;; [[worknote2.muse#1212110230]]
(load-library "js-comint.el")		;The location is etc directory


;; (setq inferior-js-mode-hook
;;       (lambda ()
;;         ;; We like nice colors
;;         (ansi-color-for-comint-mode-on)
;;         ;; Deal with some prompt nonsense
;;         (add-to-list 'comint-preoutput-filter-functions
;;                      (lambda (output)
;;                        (replace-regexp-in-string ".*1G\.\.\..*5G" "..."
;;                      (replace-regexp-in-string ".*1G.*3G" "&gt;" output))))
;; Or use
(setenv "NODE_NO_READLINE" "1")		;Deal with some prompt nonsense
(setq inferior-js-program-command "node --interactive")
