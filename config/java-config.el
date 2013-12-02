
;; http://ivvprivate.blog.com/emacs/emacs-java/ : some tips for all

(require 'javadoc-lookup)
(javadoc-add-roots "/usr/share/javadoc/java-1.6.0-openjdk/api")

;; Fetch and index documentation from Maven
;; (javadoc-add-artifacts [org.lwjgl.lwjg lwjgl "2.8.2"]
;;                        [com.nullprogram native-guide "0.2"]
;;                        [org.apache.commons commons-math3 "3.0"])

;; defidned in keybinding.el
;; (global-set-key (kbd "C-h j") 'javadoc-lookup)


(add-to-list 'ac-modes 'jde-mode)
(add-to-list 'ac-modes 'java-mode)

(require 'ajc-java-complete-config)
(add-hook 'java-mode-hook 'ajc-java-complete-mode)
(add-hook 'find-file-hook 'ajc-4-jsp-find-file-hook)
;;       (add-to-list 'load-path "~/.emacs.d/ajc-java-complete/")
;;       (require 'ajc-java-complete-config)
;;       (add-hook 'java-mode-hook 'ajc-java-complete-mode)
;;       (add-hook 'find-file-hook 'ajc-4-jsp-find-file-hook)
;;       read ajc-java-complete-config.el  for more info .
