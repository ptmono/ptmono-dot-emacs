;; require the variable
;; TODO: clean the problem of TeX-add-style-hook
(unless TeX-add-style-hook
  (setq Tex-add-style-hook nil))

(load "~/.emacs.d/cvs/nxhtml/autostart.el")
(add-to-list 'auto-mode-alist '("\\.html$" . django-html-mumamo-mode))
