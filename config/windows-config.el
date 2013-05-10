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
    (setenv "SVN_EDITOR" "C:/emacsd/emacs/bin/emacsclient.exe")
    (setenv "PATH" (concat cygwin-bin ";" (getenv "PATH")))
    ;; For csc.exe
    (setenv "PATH" (concat "C:\\Windows\\Microsoft.NET\\Framework\\v4.0.30319\\" ";" (getenv "PATH")))
    ;; For mingw32-g++.exe
    (setenv "PATH" (concat "C:\\MinGW\\bin\\" ";" (getenv "PATH")))
    ;; For cl.exe
    (setenv "MS_VC" "\"C:\\Program Files (x86)\\Microsoft Visual Studio 10.0\\VC\\bin\\\"")
    (setenv "PATH" (concat "C:\\Program Files (x86)\\Microsoft Visual Studio 10.0\\VC\\bin\\amd64\\" ";" (getenv "PATH")))
    ;; For ironpython. ipy and pyc
    (setenv "PATH" (concat "C:\\Program Files (x86)\\IronPython 2.7" ";"
			   ;; For pyc
			   "C:\\Program Files (x86)\\IronPython 2.7\\Tools\\Scripts" ";"
			   (getenv "PATH")))
    (setenv "pyc" "ipy \"C:\\Program Files (x86)\\IronPython 2.7\\Tools\\Scripts\\pyc.py\"")
    (setenv "PYC_CMD" "\"C:\\Program Files (x86)\\IronPython 2.7\\Tools\\Scripts\\pyc.py\"")
    ;; For python
    (setenv "PYTHONPATH" (concat cygwin-home "/lib/python2.6/site-packages"))
    (setenv "PYTHONPATH" (concat (getenv "PYTHONPATH") ";" (concat cygwin-home "/myscript/pystartup.py")))
    (setenv "PYTHONPATH" (concat (getenv "PYTHONPATH") ";" (concat cygwin-home "/.emacs.d/cvs/ropemacs")))
    (setenv "PYTHONPATH" (concat (getenv "PYTHONPATH") ";" (concat cygwin-home "/.emacs.d/cvs/ropemode")))
    (setenv "PYTHONPATH" (concat (getenv "PYTHONPATH") ";" (concat cygwin-home "/.emacs.d/cvs/python-mode/completion")))
    (setenv "PYTHONPATH" (concat (getenv "PYTHONPATH") ";" (concat cygwin-home "/.emacs.d/cvs/pymacs")))
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
  )
