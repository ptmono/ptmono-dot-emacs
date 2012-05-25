
;; Default for js-mode
;(add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode))
;(autoload 'javascript-mode "javascript" nil t)


;; Use js2-mode
(add-to-list 'load-path (concat d-dir-emacs "cvs/js2/build/"))
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

(add-hook 'js2-mode-hook 'outline-minor-mode)
(add-hook 'js2-mode-hook 'moz-minor-mode)

;; flymake-jslint
