
;;; === font-lock
;;; --------------------------------------------------------------
(defun d-shell/add-font-lock()
  (font-lock-add-keywords
   nil					;For current buffer
   '(("^FAIL!  :.*" . font-lock-warning-face)
     ("^QDEBUG :.*" . font-lock-constant-face)
     ("^QFATAL :.*" . font-lock-constant-face)
     )))
   
(add-hook 'shell-mode-hook 'd-shell/add-font-lock t)
 
