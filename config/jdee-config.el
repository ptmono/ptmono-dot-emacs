
;; Current version jde want less 1.0. but current 1.1beta.
(defconst cedet-version "1.0"
  "Current version of CEDET.")


(setenv "JAVA_HOME" "/usr/lib/jvm/java-1.6.0-openjdk-1.6.0.0.x86_64")
(setenv "CLASSPATH" ".")

(setq debug-on-error t)

;(add-to-list 'load-path (expand-file-name "~/.emacs.d/cvs/jdee/trunk/jdee/build/lisp/"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/cvs/jdee/trunk/jdee/dist/jdee-2.4.1/lisp/"))
;(add-to-list 'load-path (expand-file-name "~/emacs/site/cedet/common"))
;(load-file (expand-file-name "~/emacs/site/cedet/common/cedet.el"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/etc/elib-1.0/"))

;; If you want Emacs to defer loading the JDE until you open a 
;; Java file, edit the following line
(setq defer-loading-jde nil)
;; to read:
;;
;;(setq defer-loading-jde t)
;;

;(require 'semantic-edit)
;(require 'jde)


(if defer-loading-jde
    (progn
      (autoload 'jde-mode "jde" "JDE mode." t)
      (setq auto-mode-alist
	    (append
	     '(("\\.java\\'" . jde-mode))
	     auto-mode-alist)))
  (require 'jde))


(add-hook 'jde-mode-hook
          (lambda()
	    (local-set-key [(control return)] 'jde-complete)
	    (local-set-key [(shift return)] 'jde-complete-minibuf)
	    (local-set-key [(meta return)] 'jde-complete-in-line)))

;; Sets the basic indentation for Java source files
;; to two spaces.
(defun my-jde-mode-hook ()
  (setq c-basic-offset 2))

(add-hook 'jde-mode-hook 'my-jde-mode-hook)

;; Include the following only if you want to run
;; bash as your shell.

;; Setup Emacs to run bash as its primary shell.
(setq shell-file-name "bash")
(setq shell-command-switch "-c")
(setq explicit-shell-file-name shell-file-name)
(setenv "SHELL" shell-file-name)
(setq explicit-sh-args '("-login" "-i"))
(if (boundp 'w32-quote-process-args)
  (setq w32-quote-process-args ?\")) ;; Include only for MS Windows.
