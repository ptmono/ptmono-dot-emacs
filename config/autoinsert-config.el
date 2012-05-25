;;; autoinsert-config.el --- Use autoinsert

;; Copyright (C) 2012  ptmono

;; Author: ptmono <ptmono@naver.com>
;; Keywords: tools

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:
;;  from http://www.emacswiki.org/emacs/AutoInsertMode

(require 'autoinsert)
(auto-insert-mode)  ;;; Adds hook to find-files-hook
;; (setq auto-insert-directory "~/.mytemplates/") ;;; Or use custom, *NOTE* Trailing slash important
;; (setq auto-insert-query nil) ;;; If you don't want to be prompted before insertion
;; (define-auto-insert "\.py" "my-python-template.py")
;; (define-auto-insert "\.php" "my-php-template.php")


;;; === C/C++
;;; -----------------------------------------------------------
;;  from http://www.emacswiki.org/emacs/AutoInsertHeaderGuards

;; ;; autoinsert C/C++ header
;; (define-auto-insert
;;   (cons "\\.\\([Hh]\\|hh\\|hpp\\)\\'" "My C / C++ header")
;;   '(nil
;;     "// " (file-name-nondirectory buffer-file-name) "\n"
;;     "//\n"
;;     "// last-edit-by: <> \n"
;;     "//\n"
;;     "// Description:\n"
;;     "//\n"
;;     (make-string 70 ?/) "\n\n"
;;     (let* ((noext (substring buffer-file-name 0 (match-beginning 0)))
;; 	   (nopath (file-name-nondirectory noext))
;; 	   (ident (concat (upcase nopath) "_H")))
;;       (concat "#ifndef " ident "\n"
;; 	      "#define " ident  " 1\n\n\n"
;; 	      "\n\n#endif // " ident "\n"))
;;     (make-string 70 ?/) "\n"
;;     "// $Log:$\n"
;;     "//\n"
;;     ))

;; ;; auto insert C/C++
;; (define-auto-insert
;;   (cons "\\.\\([Cc]\\|cc\\|cpp\\)\\'" "My C++ implementation")
;;   '(nil
;;     "// " (file-name-nondirectory buffer-file-name) "\n"
;;     "//\n"
;;     "// last-edit-by: <> \n"
;;     "// \n"
;;     "// Description:\n"
;;     "//\n"
;;     (make-string 70 ?/) "\n\n"
;;     (let* ((noext (substring buffer-file-name 0 (match-beginning 0)))
;; 	   (nopath (file-name-nondirectory noext))
;; 	   (ident (concat nopath ".h")))
;;       (if (file-exists-p ident)
;; 	  (concat "#include \"" ident "\"\n")))
;;     (make-string 70 ?/) "\n"
;;     "// $Log:$\n"
;;     "//\n"
;;     ))



(provide 'autoinsert-config)
;;; autoinsert-config.el ends here
