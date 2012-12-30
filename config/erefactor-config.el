
(add-to-list 'load-path (concat d-dir-emacs "cvs/erefactor"))
(require 'erefactor)

(add-hook 'emacs-lisp-mode-hook
	  (lambda ()
	    (define-key emacs-lisp-mode-map [?\C-c ?r] erefactor-map)))
