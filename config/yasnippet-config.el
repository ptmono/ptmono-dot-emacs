;;; yasnippet-config.el --- 

;; Copyright (C) 2012  ptmono

;; Author: ptmono <ptmono@gmail.com>
;; Keywords: 

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

;(add-to-list 'load-path "~/.emacs.d/cvs/yasnippet")
(add-to-list 'load-path (concat d-dir-emacs "cvs/yasnippet"))
(load (concat d-dir-emacs "cvs/yasnippet/yasnippet.el"))

(require 'yasnippet) ;; not yasnippet-bundle
(yas/initialize)

(defvar d-yasnippets/dir "~/.emacs.d/snippets")
(yas/load-directory d-yasnippets/dir)

;; hook for automatic reloading of changed snippets
(defun d-yasnippets/update-on-save ()
  (when (string-match "emacs.d/snippets" buffer-file-name)
    (yas/load-directory d-yasnippets/dir)))
(add-hook 'after-save-hook 'd-yasnippets/update-on-save)

(provide 'yasnippet-config)
;;; yasnippet-config.el ends here
