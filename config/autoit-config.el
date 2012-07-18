;; Autoit
(autoload 'autoit-mode "autoit-mode" "Autoit editing mode." t)
(setq auto-mode-alist
(cons '("\\.au3$" . autoit-mode) auto-mode-alist))
(setq interpreter-mode-alist
(cons '("autoit" . autoit-mode) interpreter-mode-alist))
