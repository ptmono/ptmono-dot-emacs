
; from http://wiki.github.com/bard/mozrepl/emacs-integration
;* C-c C-s: open a MozRepl interaction buffer and switch to it
;* C-c C-l: save the current buffer and load it in MozRepl
;* C-M-x: send the current function (as recognized by c-mark-function) to MozRepl
;* C-c C-c: send the current function to MozRepl and switch to the interaction buffer
;* C-c C-r: send the current region to MozRepl
;
;In the interaction buffer:
;
;* C-c c: insert the current name of the REPL plus the dot operator (usually repl.)

(require 'moz)

(autoload 'moz-minor-mode "moz" "Mozilla Minor and Inferior Mozilla Modes" t)


(defun javascript-custom-setup ()
  (moz-minor-mode 1))

(add-hook 'javascript-mode-hook 'javascript-custom-setup)

;; It has problem. I have no idea.
;; (add-to-list 'auto-mode-alist '("\\.js$" . moz-minor-mode))
;; (add-hook 'javascript-mode-hook 'moz-minor-mode)
;; It added js2-mode-hook. Se js2-config.el


; requires d-worknote2 and d-library
; cmd = 'emacsclient -c -e "(d-frame-set-phw \\"84x100+0\\")"'
(defun d-moz-open-worknote (geometry)
  "The function requires d-worknote2.el and d-library.el"
  (d-frame-set-phw geometry)
  (find-file (car d-worknote-list)))
