
; There is no plan. There is only purpose more useful emacs to me.

;;; TODO

; DOING debugging environment
; - documentation
; DONE porting for windows


; paths
;(defvar d-dir-cvs (concat d-dir-emacs "cvs" ""))

;;; Logs

;; 1304281137 Few clean up of init.el
;; 0910110825 23.0.95.1 --> 23.1.50.1 No problem
;; 0910092159 Config d-home or d-dir-emacs on other computer. In windows
;; we require environment variables "HOME" and "D-EMACSD". "HOME"
;; directory contains .emacs.d/init.el. Cygwin is useful. Current init.el
;; assumes the location of cygwin is D-EMACSD/cygwin. Also assumes HOME is
;; D-EMACSD/home/ptmono when cygwin is used.
;; 0906220921 23.0.90.1 --> 23.0.95.1
;; 0810281513 kor.el : is for korean environment and font

;;; === For portable
;;; --------------------------------------------------------------
(defun d-windowp ()
  (if (equal window-system 'w32) t nil))
(defun d-not-windowp ()
  (if (equal window-system 'w32) nil t))

(defvar d-TEST nil)
(defvar d-home (getenv "HOME"))
(defvar d-cygwin-p t 
  "If t emacs use cygwin, nil means you do not use cygwin")

(defvar d-dir-emacs (concat d-home "/.emacs.d/")
  "The directory for emacs. configuration, packages.Note that
  this contains last /")
;; On M$ d-dir-emacs is "C:\\emacsd/cygwin/home/ptmono"

;; cedet have to load before other. See worknote2#1109230830
(load (concat d-dir-emacs "config/cedet-config.el") nil t t) 

;;; === Load Windows environment
(when (d-windowp)
  (load-file (concat d-dir-emacs "config/windows-config.el")))


;; 
(when (d-not-windowp)
  (setenv "PYTHONPATH" (concat (getenv "PYTHONPATH") ":" (concat d-home "myscript/pystartup.py")))
  (setenv "PYTHONPATH" (concat (getenv "PYTHONPATH") ":" (concat d-dir-emacs "cvs/ropemacs/ropemacs")))
  (setenv "PYTHONPATH" (concat (getenv "PYTHONPATH") ":" (concat d-dir-emacs "cvs/ropemode/ropemode")))
  (setenv "PYTHONPATH" (concat (getenv "PYTHONPATH") ":" (concat d-dir-emacs "cvs/Pymacs")))
  ;; To add pycomplete.py
  (setenv "PYTHONPATH" (concat (getenv "PYTHONPATH") ":" (concat d-dir-emacs "cvs/python-mode/completion")))
  (setenv "PYTHONSTARTUP" (concat d-dir-emacs "myscript/pystartup.py")))


;; For utf-8. You can edit a file with utf-8 when you failed to load
;; init.el.
;; Why load this? It is duplicated. See init-load.el
(when (d-windowp)
  (load-file (concat d-dir-emacs "config/kor.el")))

;;; === Load packages
;; TODO: I adding a stuff of automatic installation of packages. I think
;; that el-get helps to deal cvs/etc packages.
;;  - http://nic.ferrier.me.uk/blog/2012_07/emacs-packages-for-programmers
;;  - http://bytes.inso.cc/2011/08/13/auto-installing-packages-in-emacs-with-elpa-and-el-get/
(load-file (concat d-dir-emacs "init-load.el"))

;;; === Starting actions
(unless d-TEST (load-file (concat d-dir-emacs "init-action.el")))
