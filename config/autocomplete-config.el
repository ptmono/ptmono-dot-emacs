
(add-to-list 'load-path (concat d-dir-emacs "cvs/auto-complete"))
(add-to-list 'load-path (concat d-dir-emacs "cvs/auto-complete-clang"))

;;; === auto-complete
;;; --------------------------------------------------------------
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories (concat d-dir-emacs "cvs/auto-complete/dict"))
(setq ac-ignore-case nil)
(setq ac-auto-start nil)
(setq ac-quick-help-delay 0.2)


;;; === auto-complete-clang
;;; --------------------------------------------------------------
;; worknote2#1202170336
(require 'auto-complete-clang)
;; For auto-complete-clang See worknote2#1202170336
(setq ac-clang-auto-save t)


;;; === yasnippet
;;; -------------------------------------------------------------
(require 'yasnippet)

;; auto-complete-config.el contains this content
;; - /media/cvs/Documents/works/0cvs/trunk/dotemacs.d/cvs/auto-complete/auto-complete-config.el#3561

;; (defun ac-yasnippet-table-hash (table)
;;   (cond
;;    ((fboundp 'yas/snippet-table-parent)
;;     (yas/snippet-table-parent table))
;;    ((fboundp 'yas/table-parent)
;;     (yas/table-parent table))))


;; (defun ac-yasnippet-candidate ()
;;   (let ((table (yas--get-snippet-tables major-mode)))
;;     (if table
;;       (let (candidates (list))
;;             (mapcar (lambda (mode)          
;;               (maphash (lambda (key value)    
;;                 (push key candidates))          
;;               (yas/snippet-table-hash mode))) 
;;             table)
;;         (all-completions ac-prefix candidates)))))

;; (defface ac-yasnippet-candidate-face
;;   '((t (:background "sandybrown" :foreground "black")))
;;   "Face for yasnippet candidate.")

;; (defface ac-yasnippet-selection-face
;;   '((t (:background "coral3" :foreground "white"))) 
;;   "Face for the yasnippet selected candidate.")

;; (defvar ac-source-yasnippet
;;   '((candidates . ac-yasnippet-candidates)
;;     (action . yas/expand)
;;     (limit . 3)
;;     (candidate-face . ac-yasnippet-candidate-face)
;;     (selection-face . ac-yasnippet-selection-face)) 
;;   "Source for Yasnippet.")


;;; === etags
;;; --------------------------------------------------------------
(eval-when-compile
  (require 'cl))

(defface ac-etags-candidate-face
  '((t (:background "gainsboro" :foreground "deep sky blue")))
  "Face for etags candidate")

(defface ac-etags-selection-face
  '((t (:background "deep sky blue" :foreground "white")))
  "Face for the etags selected candidate.")

(defvar ac-source-etags
  '((candidates . (lambda () 
         (all-completions ac-target (tags-completion-table))))
    (candidate-face . ac-etags-candidate-face)
    (selection-face . ac-etags-selection-face)
    (requires . 3))
  "Source for etags.")

(defvar d-ac-clang-flags/qt-brief-p t)
(defvar d-ac-clang-flags/qt-brief (split-string "
-I/usr/include/Qt
-I/usr/include/QtCore
-I/usr/include/QtGui
-I/usr/include/QtTest
"))

(defvar d-ac-clang-flags/qt-all (split-string "
-I/usr/include/Qt
-I/usr/include/QtCore
-I/usr/include/QtGui
-I/usr/include/QtTest
-I/usr/include/QtDBus
-I/usr/include/QtDeclarative
-I/usr/include/QtDesigner
-I/usr/include/QtHelp
-I/usr/include/QtMultimedia
-I/usr/include/QtNetwork
-I/usr/include/QtOpenGL
-I/usr/include/QtScript
-I/usr/include/QtScriptTools
-I/usr/include/QtSql
-I/usr/include/QtSvg
-I/usr/include/QtUiTools
-I/usr/include/QtWebKit
-I/usr/include/QtXml
-I/usr/include/QtXmlPatterns
"))

(defvar d-ac-clang-flags/stdc++-p t)
(defvar d-ac-clang-flags/stdc++ (split-string "
-I/usr/include/c++/4.6.1
-I/usr/include/c++/4.6.1/x86_64-redhat-linux/.
-I/usr/include/c++/4.6.1/backward
-I/usr/lib/gcc/x86_64-redhat-linux/4.6.1/include
-I/usr/lib/gcc/x86_64-redhat-linux/4.6.1
"))

(defvar d-ac-clang-flags/default (split-string "
-I/usr/local/include
-I/usr/include
"))

(defun d-ac-clang-flags/create ()
  (let* ((flags d-ac-clang-flags/default))
    (when d-ac-clang-flags/stdc++-p
      (setq flags (append flags d-ac-clang-flags/stdc++))
    (if d-ac-clang-flags/qt-brief-p
	(setq flags (append flags d-ac-clang-flags/qt-brief))
      (setq flags (append flags d-ac-clang-flags/qt-all)))
    flags)))

(defvar d-ac-clang-flags (d-ac-clang-flags/create)
  "It used in ac-clang-flags and d-cc-codechecker/clang-flymake-init.")

;; It's from ac-config-default
(defun d-ac-config-default ()
  ;; clang requires header files
  (setq ac-clang-flags d-ac-clang-flags)
  (setq-default ac-sources '(ac-source-abbrev ac-source-dictionary ac-source-words-in-same-mode-buffers))
  (add-hook 'emacs-lisp-mode-hook 'ac-emacs-lisp-mode-setup)
  (add-hook 'c-mode-common-hook 'd-ac-cc-mode-setup)
  (add-hook 'ruby-mode-hook 'ac-ruby-mode-setup)
  (add-hook 'css-mode-hook 'ac-css-mode-setup)
  (add-hook 'auto-complete-mode-hook 'ac-common-setup)
  (global-auto-complete-mode t))

(defun d-ac-cc-mode-setup ()
  (setq ac-sources (append '(ac-source-clang ac-source-yasnippet) ac-sources)))
(d-ac-config-default)


;; How to use with . > :.
;; (defun ac-complete-semantic-self-insert (arg) (interactive "p") (self-insert-command arg) (ac-complete-semantic))
;; (defun my-c-mode-ac-complete-hook () 
;; 	(local-set-key "." 'ac-complete-semantic-self-insert) 
;; 	(local-set-key ">" 'ac-complete-semantic-self-insert)
;; 	(local-set-key ":" 'ac-complete-semantic-self-insert))
;; (add-hook 'c-mode-common-hook 'my-c-mode-ac-complete-hook)

(provide 'autocomplete-config)
