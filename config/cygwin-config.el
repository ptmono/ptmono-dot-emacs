
;; Problem
;; dired couldn't act with cygwin symbolic link

;; 1104160249
;; It was not solved. See followings
;; - http://www.emacswiki.org/emacs/WThirtyTwoSymlinks
;;   - http://blog.zzamboni.org/making-cygwin-windows-and-emacs-understand-th
;;     w32-symlinks is a old solution. This doesn't work later 23.1.
;; - http://cygwin.com/ml/cygwin/2000-08/msg01039.html
;; - http://www.emacswiki.org/cgi-bin/wiki/setup-cygwin.el
;; - http://www.khngai.com/emacs/cygwin.php
;; - creating shortcuts with cygutils
;;   http://www.cygwin.com/cygwin-ug-net/using-effectively.html#using-shortcuts


(unless (d-windowp)
  (mapc
   'load
   (list
;  "w32-symlinks"
;  "cygwin-mount"
;  "cygwin32-mount"
;  "cygwin32-symlink"
;  "setup-cygwin"
    )))

