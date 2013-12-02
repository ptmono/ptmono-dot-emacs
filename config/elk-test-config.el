(add-to-list 'load-path (concat d-dir-emacs "etc2/elk-test-0.3.2"))
(require 'elk-test)
(autoload 'elk-test-mode "elk-test" nil t)
(add-to-list 'auto-mode-alist '("\\.elk\\'" . elk-test-mode))

;; See http://nschum.de/src/emacs/elk-test/
;; (add-hook 'elk-test-result-mode-hook 'elk-test-result-follow-mode)

;; (defmacro assert-eq (expected actual)
;;   "Assert that ACTUAL equals EXPECTED, or signal a warning."
;;   `(assert-that (lambda (actual) (eq ,expected ,actual))
;;                 actual
;;                 "assert-eq"
;;                 (lambda (actual)
;;                   (format "expected <%s>, was <%s>" ,expected ,actual))))
