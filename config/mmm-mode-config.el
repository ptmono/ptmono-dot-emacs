;; (add-to-list 'load-path (concat d-dir-emacs "cvs/mmm-mode/"))
(require 'mmm-mode)

(setq mmm-global-mode 'maybe)

(mmm-add-mode-ext-class nil "\\.php3?\\'" 'html-php)
;(mmm-add-mode-ext-class 'html-mode "\\.php\\'" 'html-php)
(mmm-add-classes
 '((html-php
    :submode php-mode
    :front "<\\?\\(php\\)?"
    :back "\\?>")))
(autoload 'php-mode "php-mode" "PHP editing mode" t)
(add-to-list 'auto-mode-alist '("\\.php3?\\'" . sgml-html-mode))

;;; doctest
;; See doctest-config.el
