
(setq auto-mode-alist (cons '("\\.lua$" . lua-mode) auto-mode-alist))
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)

;; If you want colorization, turn on global-font-lock or add this
(add-hook 'lua-mode-hook 'turn-on-font-lock)

;; If you want to use hideshow, turn on hs-minor-mode or add this
(add-hook 'lua-mode-hook 'hs-minor-mode)
