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

;;; Log

;; 1209051233
;;  - bundle is created. But not used.

;;; Code:

;;; === Resources
;;; --------------------------------------------------------------

;; To compile yasnippet-bundle we need following
;; See
;; - The official manual. http://capitaomorte.github.com/yasnippet/index.html
;; - http://capitaomorte.github.com/yasnippet/snippet-organization.html
;; - file format. http://capitaomorte.github.com/yasnippet/snippet-development.html


;; - http://stackoverflow.com/questions/2866759/gnu-emacs-skeleton-mode-is-it-still-used
;; - http://emacswiki.org/Yasnippet
;; - http://ergoemacs.org/emacs/yasnippet_templates_howto.html
;; - http://xahlee.blogspot.kr/2010/04/emacs-templates-with-yasnippet.html
;; - http://yasnippet.googlecode.com/svn-history/r339/trunk/doc/define_snippet.html

;; - some stuffs. http://emacswiki.org/emacs/yasnippet-config.el 
;; It contains
;; - yas/set-ac-modes
;; - yas/expand-sync
;; - yas/new-snippet-with-content

;;; == Other people's snippets
;; - http://cheeso.members.winisp.net/srcview.aspx?dir=emacs&file=snippets.zip
 

;;; === Using
;;; --------------------------------------------------------------

;;; == Interface
;; yas/expand will binded with C-i. Each snippet is stored in a file. "#
;; key" directive will specify the key. If the key meets yas/expand, then
;; the snippet will inserted into the position. See manual
;; http://capitaomorte.github.com/yasnippet/snippet-development.html


;;; == Configuration
;; "Default" section shows basic configuration. Load snippets directory
;; with the function yas/load-directory. Or use bundle for loading speed.
;; See "Using bundle".

;; We can reload with the function yas/reload-all.


;;; == Writing
;; See manual http://capitaomorte.github.com/yasnippet/snippet-development.html
;; It contains


;;; == To load multiple directories
;; ;; Develop in ~/emacs.d/mysnippets, but also
;; ;; try out snippets in ~/Downloads/interesting-snippets
;; (setq yas/root-directory '("~/emacs.d/mysnippets"
;;                            "~/Downloads/interesting-snippets"))

;; ;; Map `yas/load-directory' to every element
;; (mapc 'yas/load-directory yas/root-directory)



;;; === Default
;;; --------------------------------------------------------------

;; With package.el
;; (add-to-list 'load-path (concat d-dir-emacs "cvs/yasnippet"))
;; (load (concat d-dir-emacs "cvs/yasnippet/yasnippet.el"))

;; (add-to-list 'load-path
;; 	     "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet) ;; not yasnippet-bundle
(setq yas-snippet-dirs
      '("~/.emacs.d/snippets"))
(yas-global-mode 1)


;; (yas/initialize)

(defvar d-yasnippets/dir (concat d-dir-emacs "snippets"))
;; (yas/load-directory d-yasnippets/dir)

;;; hook for automatic reloading of changed snippets
(defun d-yasnippets/update-on-save ()
  (interactive)
  (when (string-match "emacs.d/snippets" buffer-file-name)
    (yas-load-directory d-yasnippets/dir)))
(add-hook 'after-save-hook 'd-yasnippets/update-on-save)


;;; To completion
;; from emacswiki
(defun yas-ido-expand ()
  "Lets you select (and expand) a yasnippet key"
  (interactive)
    (let ((original-point (point)))
      (while (and
              (not (= (point) (point-min) ))
              (not
               (string-match "[[:space:]\n]" (char-to-string (char-before)))))
        (backward-word 1))
    (let* ((init-word (point))
           (word (buffer-substring init-word original-point))
           (list (yas-active-keys)))
      (goto-char original-point)
      (let ((key (remove-if-not
                  (lambda (s) (string-match (concat "^" word) s)) list)))
        (if (= (length key) 1)
            (setq key (pop key))
          (setq key (ido-completing-read "key: " list nil nil word)))
        (delete-char (- init-word original-point))
        (insert key)
        (yas-expand)))))


;;; disable tab binding
;; See keybinding.el
;; (define-key yas/minor-mode-map [(tab)] nil)
;; (define-key yas/minor-mode-map(kbd "TAB") nil)


;;; === Using bundle
;;; --------------------------------------------------------------
;; See the manual
;; - http://capitaomorte.github.com/yasnippet/snippet-organization.html
;;
;; Why use bundle ? For speed. If you use just above "Default" -
;; (yas/load-directory d-yasnippets/dir - eats many startup time of emacs
;; to load yasnippets. Eash snippet of yasnippets is stored in a file.
;; Each file also contains directives. The yasnippets will open and read
;; all the files to gather the data of snippets. It spends some time. To
;; void this we can use "yasnippet-bundle.el". The function
;; yas/compile-bundle will create the file. The file contains the function
;; yas/initialize-bundle generated by yas/compile-bundle.
;; yas/initialize-bundle contains the data of snippets. We can just
;; execute yas/initialize-bundle instead of reading files.

;; How to create yasnippet-bundle.el ? Use yas/compile-bundle. C-h f
;; yas/compile-bundle will explain the function. Following is an example.
;; (yas/compile-bundle "~/.emacs.d/cvs/yasnippet/yasnippet.el"
;; 		    "~/.emacs.d/snippets/yasnippet-bundle.el"
;; 		    "~/.emacs.d/snippets"
;; 		    ""
;; 		    "~/.emacs.d/cvs/yasnippet/dropdown-list.el"
;; 		    )

;; Then load and just execute yas/initialize-bundle. Where we have no need
;; to load above "Default". "Default" is the code of "Default" section.

;; (load (concat d-yasnippets/dir "/yasnippet-bundle"))
;; ;;;### autoload
;; (require 'yasnippet-bundle)
;; (yas/initialize-bundle)


(provide 'yasnippet-config)
;;; yasnippet-config.el ends here


