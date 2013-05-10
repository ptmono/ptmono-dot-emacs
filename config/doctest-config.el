
(add-to-list 'load-path (concat d-dir-emacs "etc2/doctest-mode.el"))
(add-to-list 'load-path '("\\.doctest$" . doctest-mode))
(autoload 'doctest-mode "doctest-mode" "doctest mode" t)

(autoload 'doctest-register-mmm-classes "doctest-mode")
(doctest-register-mmm-classes t t)

(autoload 'doctest-register-mmm-classes "doctest-mode")
(doctest-register-mmm-classes t t)
