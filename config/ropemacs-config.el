
;; ropemacs requires rope that is a python refactoring library. Just use 'yum
;; install python-rope'.

(require 'pymacs)

;;--------------------------------------------------------------------------------
;; It has a problem. SOLVED
;;--------------------------------------------------------------------------------
;; I didn't install ropemacs and ropemode. So load.
;;DONE Solve following problem.
;;SOLVED  I failed this configuration. I couldn't load ropemacs and ropemode
;;        with pymacs-load-path. So I configure 'PYTHONPATH' in ~/.bash_profile.
;;        So ropemacs will not apply to win32 environment.
;;
;;The reason is the path. cvs/ropemode/ropemode/ contains python source with
;;__ini__.py. I used (concat d-dir-emacs "cvs/ropemacs/ropemacs/"). It's bad.
;;Use (concat d-dir-emacs "cvs/ropemacs/")

;; PROBLEM Why meet stringp error with (concat ...
;(setq pymacs-load-path '(
;			 ;; ropemacs is a minor mode of rope to use rope in
;			 ;; emacs. ropemacs is created by python language with
;			 ;; Pymacs.lisp module. You can see the source to the
;			 ;; following directory.
;			 (concat d-dir-emacs "cvs/ropemacs/")
;			 ;; Currently I use repository version ropemacs that
;			 ;; requirs ropemode.
;			 ;; See http://rope.sourceforge.net/ropemacs.html
;			 (concat d-dir-emacs "cvs/ropemode/")
;			 ))

;; Instead above
(eval-after-load "pymacs"
  '(add-to-list 'pymacs-load-path (concat d-dir-emacs "cvs/ropemacs/")))
(eval-after-load "pymacs"
  '(add-to-list 'pymacs-load-path (concat d-dir-emacs "cvs/ropemode/")))

;  '(add-to-list 'pymacs-load-path "/home/ptmono/.emacs.d/cvs/ropemode/ropemode/"))
;;--------------------------------------------------------------------------------  


(pymacs-load "ropemacs" "rope-")

; ropemacs may redefine some standard Emacs and your custom key bindings. To
; prevent
(setq ropemacs-enable-shortcuts nil)
(setq ropemacs-local-prefix "C-c C-p")


;If you want to load ropemacs only when you really need it, you can use
;a function like this in your ``~/.emacs``::
;
;  (defun load-ropemacs ()
;    "Load pymacs and ropemacs"
;    (interactive)
;    (require 'pymacs)
;    (pymacs-load "ropemacs" "rope-")
;    ;; Automatically save project python buffers before refactorings
;    (setq ropemacs-confirm-saving 'nil)
;  )
;  (global-set-key "\C-xpl" 'load-ropemacs)


;; To enable completion in python-mode
;; Use 'completion-at-point instead 'py-complete.
(load-library "pycomplete.el")

