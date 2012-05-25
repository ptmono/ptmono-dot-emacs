

; There is no plan. There is only purpose more useful emacs to me.

;;; TODO

; - debugging environment
; - documentation
; DONE porting for windows


; paths
;(defvar d-dir-cvs (concat d-dir-emacs "cvs" ""))

;;; Logs

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
  ""
  (if (equal window-system 'w32)
      t
    nil))

(defun d-not-windowp ()
  ""
  (if (equal window-system 'w32)
      nil
    t))


(defvar d-home (getenv "HOME"))
(defvar d-cygwin-p t 
  "If t emacs use cygwin, nil means you do not use cygwin")

(defvar d-dir-emacs (concat d-home "/.emacs.d/")
  "The directory for emacs. configuration, packages.Note that
  this contains last /")
;; On M$ d-dir-emacs is "C:\\emacsd/cygwin/home/ptmono"

(when (d-windowp)
  (defvar d-windows-emacsd-dir
    (getenv "d-emacsd")
    "I create a package that contains cygwin, emacs for win32, my
.emacs.d, some script and tools for windows such as autoruns.exe.
The directory is the path of the package in Windows. I am using
C:\\emacsd.

To execute emacs run.vbs is used in Windows. The script
determines this value.")
  (unless d-windows-emacsd-dir
    (error "Set D-EMACSD variable. Or set manually d-cygwin-p and
    d-dir-emacs. You maybe do not use cygwin. You load init file
    manually. Set d-cygwin-p nil. And set d-dir-emacs as the
    directory that contains init.el."))
  ;; Set home directory and exec path. requires cygwin
  (when d-cygwin-p
    ;; from http://www.emacswiki.org/emacs/CategoryWThirtyTwo
    ;; from http://stackoverflow.com/questions/2075504/how-to-best-integrate-emacs-and-cygwin
    (let* ((cygwin-root (concat d-windows-emacsd-dir "/cygwin"))
	   (cygwin-bin (concat cygwin-root "/bin"))
	   (cygwin-home (concat cygwin-root"/home/ptmono")))
      (setenv "HOME" cygwin-home)
      (setenv "PATH" (concat cygwin-bin ";" (getenv "PATH")))
      ;; For csc.exe
      (setenv "PATH" (concat "C:\\Windows\\Microsoft.NET\\Framework\\v4.0.30319\\" ";" (getenv "PATH")))
      ;; For mingw32-g++.exe
      (setenv "PATH" (concat "C:\\MinGW\\bin\\" ";" (getenv "PATH")))
      ;; For cl.exe
      (setenv "MS_VC" "C:\\Program\ Files\ \(x86\)\\Microsoft\ Visual\ Studio 10.0\\VC\\bin\\")
      (setenv "PATH" (concat "C:\\Program Files (x86)\\Microsoft Visual Studio 10.0\\VC\\bin\\amd64\\" ";" (getenv "PATH")))
      (setenv "PYTHONPATH" (concat cygwin-home "/lib/python2.6/site-packages"))
      (setenv "PYTHONPATH" (concat (getenv "PYTHONPATH") ";" (concat cygwin-home "/myscript/pystartup.py")))
      (setenv "PYTHONPATH" (concat (getenv "PYTHONPATH") ";" (concat cygwin-home "/.emacs.d/cvs/ropemacs/ropemacs")))
      (setenv "PYTHONPATH" (concat (getenv "PYTHONPATH") ";" (concat cygwin-home "/.emacs.d/cvs/ropemode/ropemode")))
      (setenv "PYTHONPATH" (concat (getenv "PYTHONPATH") ";" (concat cygwin-home "/.emacs.d/etc/pymacs")))
      (setenv "PYTHONSTARTUP" (concat cygwin-home "/myscript/pystartup.py"))
      (setq exec-path (cons cygwin-bin exec-path))
  
      (setq shell-file-name "bash") ; default value is emacs/bin/cmdproxy.exe
      (setenv "SHELL" shell-file-name)
      (setq explicit-shell-file-name shell-file-name)

      ;(setq w32shell-cygwin-bin cygwin-bin)
      (load-file (concat d-dir-emacs "etc/w32shell.el"))
      ;(require 'w32shell)
      ;(w32shell-add-emacs)
      ;(w32shell-set-shell "cygwin")

      ;; Add Cygwin Info pages
      (add-to-list 'Info-default-directory-list
		   (concat cygwin-root "usr/share/info/"))

      ;; To see junction link and the dired directory space problem
      (setq ls-lisp-use-insert-directory-program t)
      )
    (defun shell-cmd ()
      "We need an environment to use Visual C++ compiler. The
function will provide the shell to use Visual C++ compiler."
      (interactive)
      (let* ((cygwin-root (concat d-windows-emacsd-dir "/cygwin"))
	     (cygwin-bin (concat cygwin-root "/bin"))
	     (cygwin-home (concat cygwin-root"/home/ptmono")))
	
	(setq shell-file-name "C:/emacsd/emacs/bin/cmdproxy.exe") ; default value is emacs/bin/cmdproxy.exe
	(setenv "SHELL" shell-file-name)
	(setq explicit-shell-file-name shell-file-name)
	
	(setq w32shell-cygwin-bin cygwin-bin)
	(load-file (concat d-dir-emacs "etc/w32shell.el"))
	(require 'w32shell)
	(w32shell-add-emacs)
	(w32shell-set-shell "cygwin")
	
	(shell "*cmd*")
	(setq shell-file-name "bash") ; default value is emacs/bin/cmdproxy.exe
	(setenv "SHELL" shell-file-name)
	(setq explicit-shell-file-name shell-file-name)
	
	(setq w32shell-cygwin-bin cygwin-bin)
	(load-file (concat d-dir-emacs "etc/w32shell.el"))
	(require 'w32shell)
	(w32shell-add-emacs)
	(w32shell-set-shell "cygwin")

	(insert "vcvars64.bat")
	(comint-send-input)))
    ))

;; For utf-8. You can edit a file with utf-8 when you failed to load
;; init.el.
(when (d-windowp)
  (load-file (concat d-dir-emacs "config/kor.el")))

;(setq load-path (cons (expand-file-name (concat d-dir-emacs "")) load-path))
(add-to-list 'load-path d-dir-emacs)
(add-to-list 'load-path (concat d-dir-emacs "etc"))
(add-to-list 'load-path (concat d-dir-emacs "config"))
(add-to-list 'load-path (concat d-dir-emacs "myel"))


(add-to-list 'load-path (concat d-dir-emacs "etc/mldonkey-el-0.0.4b"))

(add-to-list 'load-path (concat d-dir-emacs "cvs/color-theme/"))
(add-to-list 'load-path (concat d-dir-emacs "cvs/color-theme/themes/"))
(add-to-list 'load-path (concat d-dir-emacs "cvs/bbdb/lisp"))
(add-to-list 'load-path (concat d-dir-emacs "cvs/mmm-mode/"))
(add-to-list 'load-path (concat d-dir-emacs "cvs/jd-el/"))
(add-to-list 'load-path (concat d-dir-emacs "cvs/nxhtml/"))
(add-to-list 'load-path (concat d-dir-emacs "cvs/doxymacs/lisp"))
(add-to-list 'load-path (concat d-dir-emacs "cvs/csharpmode/"))
;; This will conflict with csharp-mode
;;(add-to-list 'load-path (concat d-dir-emacs "cvs/cc-mode/"))


;(when (d-windowp)
(add-to-list 'load-path (concat d-dir-emacs "cvs/muse/lisp/")) ;installed
(add-to-list 'load-path (concat d-dir-emacs "cvs/planner/")) ;installed
(add-to-list 'load-path (concat d-dir-emacs "cvs/emacs-w3m/")) ;installed
(add-to-list 'load-path (concat d-dir-emacs "cvs/remember/")) ;installed
(add-to-list 'load-path (concat d-dir-emacs "cvs/auctex/"))
(add-to-list 'load-path (concat d-dir-emacs "cvs/auctex/preview/"))
;(add-to-list 'load-path (concat d-dir-emacs "cvs/auctex/style/"))
;  )

;(add-to-list 'load-path (concat d-dir-emacs "cvs/emacs-w3m/shimbun"))
;(add-to-list 'load-path (concat d-dir-emacs "cvs/emacs-w3m/attic"))


(add-to-list 'load-path (concat d-dir-emacs "etc/rfcview"))
(add-to-list 'load-path (concat d-dir-emacs "etc/pymacs"))
(add-to-list 'load-path (concat d-dir-emacs "etc/python-mode"))
;; (add-to-list 'load-path (concat d-dir-emacs "cvs/python-mode"))
;; (add-to-list 'load-path (concat d-dir-emacs "cvs/python-mode/completion"))
; ;(add-to-list 'load-path (concat d-dir-emacs "etc/delicious-el"))

(byte-recompile-directory (concat d-dir-emacs "config/"))
(byte-recompile-directory (concat d-dir-emacs "myel/"))
(byte-recompile-directory (concat d-dir-emacs "etc/"))
(byte-recompile-directory (concat d-dir-emacs "url/"))
;(byte-recompile-directory "~/")
;above check all subdirectry of /
;so long boot time

;(message d-dir-emacs)

;; Load packages
(mapc
 'load
 (list
  ;;; etc folder.
  ;; which contains external packages which is not part of GNU emacs.
  ;; external.el contains the configuration of external packages which
  ;; requres simple configuration. If I need more configuration, I will use
  ;; xxx-config.el file like muse-config.

  "cedet-config" ; cedet have to load before other. See worknote2#1109230830
  "chronometer"
  "connection"
  "link"
  "dictionary"
  "dictionary-init"
  "ell"

  "extview"
  "highlight-current-line"
  "highline"
  "iimage"
  "php-mode"
  "tetris"
  ;"delicious-config.el"
  "shell-command"
  "boxquote"
  "external" ; This is configuration file.
  "htmlize" ; for source highlighting
  ;"anything"
  ;"anything-ipython"
  "d-alarm"
  "ange-ftp"
  "cygwin-config"
  "flymake-cursor"

  ;;; config folder
  ;; which contains my own modification or addition for each mode.
  "d-library" ; individual library
  ;"jdee-config"
  "erefactor-config"			;refactoring elisp
  "muse-config"
  "planner-config"
  "muse-publish-config"
  "remember-config"
  "auth"				;It contains private stuffs
  "emacs-w3m-config"
  "mldonkey-config"
  "bbdb-config"
  "find-config"
  "erc-config"
  "auctex-config"
  "calendar-config"
  "color-theme-config"
  "appt-config"
  "python-config" ; contains python-mode, ipython, pymacs
  "outline-config"
  "dired-config.el"
  "kor.el" ; for korean env and font
  "moz-config" ; for firefox mozrepl module
  "js2-config"
  "lua-config"
  "gcal-config"
  "buff-menu-config"
  "logview-config"
  ;"android-config"
  "vc-config"
  "elk-test-config"
  "yasnippet-config"
  "autoinsert-config"
  "autocomplete-config"
  "cc-config" 				;c, c++, c#, qt
  ;"cclookup-config" ; for c++ doc
  "abbrev-config"
  "shell-config.el"

  ;;; myel folder
  ;; I written tools for me.
  "myel" ; for convenient use
  "d-citation"
  "d-note"
  "d-search"
  "d-worknote2"
  "dal-worknote" ; It is first elisp for worknote. I lose el file. There is only elc file.
  "d-planning"
  "d-exercise"
  ;"d-w3m-ytn"
  "d-mom"
  "d-temp"
  ;"d-last"
  "d-sikuli"
 ))

(unless (d-windowp)
  (mapc
   'load
   (list
    "ropemacs-config"
    ;"nxhtml-config"
    "d-latex"
    "gtags-config"
    )))


;; This was installed by package-install.el.
;; This provides support for the package system and
;; interfacing with ELPA, the package archive.
;; Move this code earlier if you want to reference
;; packages in your .emacs.
;; Fixme: Support Windows.
(unless (d-windowp)
  (when
      (load
       (expand-file-name "~/.emacs.d/elpa/package.el"))
    (package-initialize))
  )


;; Load custom-set-variables and variables
(setq custom-file (concat d-dir-emacs "config/config-custom.el"))
(load custom-file t)

;; Load keybinding
(load (concat d-dir-emacs "config/keybinding")) 

; for w3m-search

;------------------------------------------------------------
;; load w3m-session : to save emacs-w3m session
;------------------------------------------------------------
;(require 'w3m-session)
; 이건 url-util이 없다는 error가 발생하였다. w3m-session을 사용하지 않고 다른 방법을
; 사용할수 있을 것 같다. emacswiki의 emacs-w3m 참고.


;;; === Saving Buffers with Desktop
;;; --------------------------------------------------------------
;; (desktop-load-default) 
;; (defun desktop-buffer-w3m-misc-data ()
;;   "Save data necessary to restore a `w3m' buffer."
;;   (when (eq major-mode 'w3m-mode)
;;     w3m-current-url))

;; (defun desktop-buffer-w3m ()
;;   "Restore a `w3m' buffer on `desktop' load."
;;   (when (eq 'w3m-mode desktop-buffer-major-mode)
;;     (let ((url desktop-buffer-misc))
;;       (when url
;;         (require 'w3m)
;;         (if (string-match "^file" url)
;;             (w3m-find-file (substring url 7))
;;           (w3m-goto-url url))
;;         (current-buffer)))))

;; (add-to-list 'desktop-buffer-handlers 'desktop-buffer-w3m)
;; (add-to-list 'desktop-buffer-misc-functions 'desktop-buffer-w3m-misc-data)
;; (add-to-list 'desktop-buffer-modes-to-save 'w3m-mode)

;; (desktop-load-default) ; 위에 써두었다.
;;    (setq history-length 250)
;;    (add-to-list 'desktop-globals-to-save 'file-name-history)
;;    (desktop-read)
;;    (setq desktop-enable t)


;;; === Face
;;; --------------------------------------------------------------
;; more see myel.el
;; (require 'w32-symlinks)
;; (require 'cygwin32-symlink)


;;; === ddns
;;; --------------------------------------------------------------
;; no need anymore
;;(d-ddns-update)

(iswitchb-mode) ; for C-x C-b(switch-to-buffer)

(unless (d-windowp)
  (server-start))
;(color-theme-jsc-light)
(d-color-theme-hober)
;(d-color-theme-standard)
;(d-last-work)
(d-face)

;(set-fontset-font "fontset-default" '(#x1100 . #xffdc) '("UnDotum" . "unicode-bmp"))
;(set-fontset-font "fontset-default" '(#xe0bc . #xf66e) '("UnDotum" . "unicode-bmp"))

;; (d-frame-set-phw "100x100+300")
(switch-to-buffer "*Messages*")

(d-worknote-openWorknote)

(require 'projectb)

(put 'upcase-region 'disabled nil)


(defun d-test ()
  ""
  (interactive)
  (require 'csharp-mode)
  (find-file "~/tmp/csharp/test.cs")
  )
