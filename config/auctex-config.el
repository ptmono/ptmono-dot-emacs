
;; Use package.el
;; (add-to-list 'load-path (concat d-dir-emacs "cvs/auctex/"))
;; (add-to-list 'load-path (concat d-dir-emacs "cvs/auctex/preview/"))

(require 'auctex-autoloads)
;; (load "auctex.el" nil t t)
;; (load "preview-latex.el" nil t t)


(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

;; To compile with pdflatex.
;; Or use M-x TeX-PDF-mode. Then C-c C-v.
(setq TeX-PDF-mode t)

(setq TeX-output-view-style
      (quote
       (("^pdf$" "." "evince -f %o")
        ("^html?$" "." "iceweasel %o"))))

;; To compile documents to PDF by default
(setq TeX-PDF-mode t)


