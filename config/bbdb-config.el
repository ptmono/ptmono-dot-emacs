
;; Use package.el
;; (add-to-list 'load-path (concat d-dir-emacs "cvs/bbdb/lisp"))

(require 'bbdb)
(bbdb-initialize)

;; Not work current version 
;; (add-hook 'gnus-startup-hook 'bbdb-insinuate-gnus)

(add-to-list 'Info-default-directory-list "/usr/src/cvs/bbdb/texinfo/")
