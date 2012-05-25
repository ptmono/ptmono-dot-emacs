(add-to-list 'load-path "/usr/local/src/cvs/global/")
(autoload 'gtags-mode "gtags" "" t)

(add-hook 'c-mode-common-hook
	  '(lambda () (gtags-mode 1)))

;; Cycling
(require 'gtags)

(defun d-gtags/next-gtag ()
  "Find next matching tag, for GTAGS."
  (interactive)
  (let ((latest-gtags-buffer
         (car (delq nil  (mapcar (lambda (x) (and (string-match "GTAGS SELECT" (buffer-name x)) (buffer-name x)) )
                                 (buffer-list)) ))))
    (cond (latest-gtags-buffer
           (switch-to-buffer latest-gtags-buffer)
           (forward-line)
           (gtags-select-it nil))
          ) ))
