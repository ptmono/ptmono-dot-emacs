;; Autoit
;; (autoload 'autoit-mode "autoit-mode" "Autoit editing mode." t)
;; (setq auto-mode-alist
;;       (cons '("\\.au3$" . autoit-mode) auto-mode-alist))
;; (setq interpreter-mode-alist
;;       (cons '("autoit" . autoit-mode) interpreter-mode-alist))

(add-to-list 'load-path (concat d-dir-emacs "etc/au3-mode.el"))

(autoload 'au3-mode "au3-mode" "Autoit editing mode." t)
(setq auto-mode-alist
      (cons '("\\.au3$" . au3-mode) auto-mode-alist))
(setq interpreter-mode-alist
      (cons '("autoit" . au3-mode) interpreter-mode-alist))


