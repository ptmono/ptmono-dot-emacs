;;; Add paths
;; (setq load-path (cons (expand-file-name (concat d-dir-emacs "")) load-path))
(add-to-list 'load-path d-dir-emacs)
(add-to-list 'load-path (concat d-dir-emacs "etc"))
(add-to-list 'load-path (concat d-dir-emacs "etc2"))
(add-to-list 'load-path (concat d-dir-emacs "config"))
(add-to-list 'load-path (concat d-dir-emacs "myel"))

(add-to-list 'load-path (concat d-dir-emacs "cvs/jd-el/"))
(add-to-list 'load-path (concat d-dir-emacs "cvs/planner/"))
(add-to-list 'load-path (concat d-dir-emacs "cvs/muse/lisp/"))
(add-to-list 'load-path (concat d-dir-emacs "cvs/remember/"))

;;; package.el
(require 'd-library)
;; We will load packages manually with package-initialize. It will avoid
;; loading the packages again after processing the init file.
(setq package-enable-at-startup nil)

(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
	("marmalade" . "http://marmalade-repo.org/packages/")
	("melpa" . "http://melpa.milkbox.net/packages/")))

(setq package-load-list
      '((fringe-helper	 	t)	; Required by elk-test
	(elk-test		t)
	(color-theme		t)
	(mldonkey		t)
	(mmm-mode		t)
	(bbdb			t)
	(csharp-mode		t)
	(muse			nil)
	(w3m			t)
	(auctex			t)
	(remember		nil)	; Cvs
	(pymacs			t)
	(ipython		nil)
	(highline		t)
	(php-mode		t)
	(shell-command		t)
	(boxquote		t)
	(htmlize		t)
	(js2-mode		nil)	; Cause error
	
	(flymake-cursor	t)
	(anything		nil)
	(anything-ipython	nil)

	;; builtins
	(iimage			nil)
	(tetris			nil)
	(ange-ftp		nil)
	))

;;; Init package values
;;  - package--builtins		: packages that part of emacs
;;  - package-alist		: packages that installed
;;  - package-archive-contents	: packages that available

;; It seems inits all values, but I have no guarantee the work.

;(package-initialize t)

(require 'package)
(package-load-all-descriptors)		; package-alist
(package-read-all-archive-contents)	; package-archive-contents
(require 'finder-inf nil t)		; package--builtins


(defvar d-init-package/3rd-pkg-list
  ;;; etc folder.
  ;; which contains external packages which is not part of GNU emacs.
  ;; external.el contains the configuration of external packages which
  ;; requres simple configuration. If I need more configuration, I will use
  ;; xxx-config.el file like muse-config.
  '(("chronometer"		t)
    ("connection"		t)
    ("link"			t)
    ("dictionary"		t)
    ("dictionary-init"		t)
    ("ell"			nil)
    ("extview"			t)

    ("jd-el"			nil)
    ("planner"			nil)	; See planner-config.el
    
    )
  "Will loaded with load function")

(defvar d-init-package/my-pkg-list
  '(("myel"			t) ; for convenient use
    ("d-citation"		t)
    ("d-note"			t)
    ("d-search"			t)
    ("d-worknote2"		t)
    ("dal-worknote"		t) ; It is first elisp for worknote. I
				   ; lose el file. There is only elc file.
    ("d-planning"		t)
    ("d-exercise"		t)
    ("d-w3m-ytn"		nil)
    ("d-mom"			t)
    ("d-temp"			t)
    ("d-last"			nil)
    ("d-sikuli"			t)
    ("d-job"			t)
    )
  "Written by my one. worknote, citation depends other packages
complexitly.")

(defvar d-init-package/tested-pkg-list
  '(("python-config"		t)
    ("ropemacs-config"		t)
    ("color-theme"		t)
    ("color-theme-config"	t)
    ))

(defvar d-init-package/config-list
  '(;; cedet have to load before others. See worknote2#1109230830
    ("cedet-config"		nil)
    ("delicious-config"		nil)
    ("external"			t)
    ("d-alarm"			t)

    ;;; config folder
    ("cygwin-config"		t)
    ("d-library"		t)	; individual library
    ("jdee-config"		nil)
    ("erefactor-config"		t)	;refactoring elisp
    ("muse-config"		t)
    ("planner-config"		t)
    ("muse-publish-config"	t)
    ("remember-config"		t)
    ("auth"			t)
    ("emacs-w3m-config"		t)
    ("mldonkey-config"		t)
    ("bbdb-config"		t)
    ("find-config"		t)
    ("erc-config"		t)
    ("auctex-config"		t)
    ("calendar-config"		t)
    ("color-theme-config"	t)
    ("appt-config"		t)
    ("python-config"		t)	; contains python-mode, ipython, pymacs
    ("ropemacs-config"		t)
    ("outline-config"		t)
    ("dired-config.el"		t)
    ("kor.el"			t)	; for korean env and font
    ("moz-config"		t)	; for firefox mozrepl module
    ("javascript-config.el"	t)
    ("lua-config"		t)
    ("gcal-config"		t)
    ("buff-menu-config"		t)
    ("logview-config"		t)
    ("android-config"		nil)
    ("vc-config"		t)
    ("elk-test-config"		t)
    ("yasnippet-config"		t)
    ("autoinsert-config"	t)
    ("autocomplete-config"	t)
    ("cc-config"		t)	; c, c++, c#, qt
    ("cclookup-config"		nil)	; for c++ doc
    ("abbrev-config"		t)
    ("shell-config.el"		t)
    ("autoit-config.el"		t)
    ("ppf-config.el"		t)
    ("elisp-config.el"		t)
    ("package-config"		nil)	; Here contains
    ("kite-config.el"		t)	; Require package. Test env for chromium extension
    ("mmm-mode-config"		t)
    ("doctest-config.el"	t)
    )
  "")

(defvar d-init-package/linux-only-pkg-list    
  '(("nxhtml-config"		nil)
    ("d-latex"			t)
    ("gtags-config"		t)
    )
  "This will conflict on Windows environment.")

;;; functions
;; package.el provide basic functions
;;  - package-installed-p
;;  - package-built-in-p
;;  - package-load-all-descriptors		; Set package-alist
;;  - package-read-all-archive-contents 	; Set package-archive-contents
;;  - (require 'finder-inf nil t)		; Set package--builtins


;; Consider to use 'package-installed-p
(defun d-init-package/canInstall (package)
  "Returns t/nil."
  (let* ((package (d-libs/symbol package)))
    (if (assq package package-archive-contents)
	t
      nil)))

;; Consider to use package-built-in-p
(defun d-init-package/isBuiltin (package)
  "Returns t/nil."
  (let* ((package (d-libs/symbol package)))
    (if (assq package package--builtins)
	t
      nil)))

(defun d-init-package/load (pkgs)
  "Load package. It requires that the directory is in load-path.
PKGS can be string and list. The list has the form like
d-init-package/3rd-pkg-list."
  (let* (loadp
	 pkg)
    (cond ((listp pkgs)
	   (dolist (pkg pkgs)
	     (setq loadp (nth 1 pkg))
	     (setq pkg (nth 0 pkg))
	     (when loadp (load pkg))))
	  ((stringp pkgs)
	   (load pkgs)))))

(defun d-init-package/load-all ()
  (cond (d-TEST
	 (d-init-package/load d-init-package/tested-pkg-list))

	((d-windowp)
	 (d-init-package/load d-init-package/3rd-pkg-list)
	 (d-init-package/load d-init-package/config-list)
	 (d-init-package/load d-init-package/my-pkg-list))

	(t
	 (d-init-package/load d-init-package/3rd-pkg-list)
	 (d-init-package/load d-init-package/linux-only-pkg-list)
	 (d-init-package/load d-init-package/config-list)
	 (d-init-package/load d-init-package/my-pkg-list))))

(defun d-init-package/pkgs-will-be-installed ()
  "Return a list of package to be installed."
  (let* (pkg-dsc pkg-name pkg-reqs pkg-ver result)
    (dolist (p package-load-list)
      (setq pkg (nth 0 p))
      (setq pkg-ver (nth 1 p))

      (if pkg-ver
	  (unless (package-installed-p pkg)
	    (push pkg result))))
    ;; Add the required packages
    (d-init-package/pkg-transactions result)))


;;;###autoload
(defun d-init-package/install-all ()
  (interactive)
  (let* ((packages (d-init-package/pkgs-will-be-installed)))
    (dolist (pkg packages)
      (package-install pkg))))


(defun d-init-package/pkg-reqs (pkg-list)
  "Returns the list of the requred packages for the PKG-LIST. But
it is not contains all. Use d-init-package/pkg-transactions
instead of. package-compute-transaction helps that. But it has a
problem."
  (let* (reqs-lists reqs-list reqs desc result)
    (dolist (pkg pkg-list)
      (setq desc (assq pkg package-archive-contents))
      (setq reqs (package-desc-reqs (cdr desc)))
      (if reqs
	  (push reqs reqs-list)))
    (car reqs-list)))


;;TODO It has an error
;; (setq packages '(ac-js2 melpa))
;; (d-init-package/pkg-transactions packages)
;; It will not work. Because js2-mode requires emacs. There is no emacs package.

;; (package-desc-reqs (cdr (assq 'js2-mode package-archive-contents)))
;; ((emacs (24 1)))
;; package-compute-transaction will error with emacs package.
(defun d-init-package/pkg-transactions (pkg-list)
  "Returns pkg-list which include the required packages. PKG-LIST
is the list of package."
  (let* (reqs-lists reqs-list reqs desc result)
    (dolist (pkg pkg-list)
      (setq desc (assq pkg package-archive-contents))
      (setq reqs (package-desc-reqs (cdr desc)))
      (if reqs
	  (push reqs reqs-list)))
    ;; package-compute-transaction will add the required packages into the
    ;; list. It do recursively.
    (setq result (package-compute-transaction pkg-list (car reqs-list)))))


(defun d-init-package/load-custom-and-keybinding ()
  "We will load custom variables and keybinding at end."
  (unless d-TEST
    ;; Load custom-set-variables and variables
    (setq custom-file (concat d-dir-emacs "config/config-custom.el"))
    (load custom-file t)
    ;; Load keybinding
    (load (concat d-dir-emacs "config/keybinding"))))

;; From emacswiki 
;; package.el seems does not add the paths of packages into load-path. We
;; manually add installed path to configure the packages.
;;;###autoload
(defun package-update-load-path ()
  "Update the load path for newly installed packages."
  (interactive)
  (let ((package-dir (expand-file-name package-user-dir)))
    (mapc (lambda (pkg)
            (let ((stem (symbol-name (car pkg)))
		  (version "")
		  (first t)
		  path)
	      (mapc (lambda (num)
		      (if first
			  (setq first nil)
			  (setq version (format "%s." version)))
		      (setq version (format "%s%s" version num)))
		    (aref (cdr pkg) 0))
              (setq path (format "%s/%s-%s" package-dir stem version))
              (add-to-list 'load-path path)))
          package-alist)))

;;; Load packages
(d-init-package/install-all)
(package-update-load-path)		; add load-paths
(package-initialize t)
(package-refresh-contents)
(d-init-package/load-all)

(d-init-package/load-custom-and-keybinding)

;;; Compile new els
;; (byte-recompile-directory (concat d-dir-emacs "config/"))
;; (byte-recompile-directory (concat d-dir-emacs "myel/"))
;; (byte-recompile-directory (concat d-dir-emacs "etc/"))
;; (byte-recompile-directory (concat d-dir-emacs "etc2/"))
;; (byte-recompile-directory (concat d-dir-emacs "url/"))
;; (byte-recompile-directory (concat d-dir-emacs "elpa/"))
;; It will check all subdirectry of /. So it consumes many boot times.
;; (byte-recompile-directory "~/")
