
;; It's builtin
;; (add-to-list 'load-path (concat d-dir-emacs "etc/mldonkey-el-0.0.4b"))
(require 'mldonkey)

(setq mldonkey-host "localhost")
(setq mldonkey-port 4000) ; use the port of the telnet interface

;; use higline-local-mode
(require 'highline)
(add-hook 'mldonkey-mode-hook 'highline-local-mode)


;; don't show the age of a download
(setq mldonkey-show-days nil)

;; show the network of a download
(setq mldonkey-show-network t)

;; show the md4 of finished downloads
(setq mldonkey-show-finished-md4 t)

;;;filename Filter
(add-to-list 'mldonkey-vd-filename-filters 'mldonkey-vd-filename-remove-p20)


;;;Sorting
(setq mldonkey-vd-sort-functions
      '(mldonkey-vd-sort-number))
(setq mldonkey-vd-sort-fin-functions
      '(mldonkey-vd-sort-number))


;;;Hooks

;; automatically refresh the list of downloads
(add-hook 'mldonkey-pause-hook 'mldonkey-vd)
(add-hook 'mldonkey-resume-hook 'mldonkey-vd)
(add-hook 'mldonkey-commit-hook 'mldonkey-vd)
(add-hook 'mldonkey-recover-temp-hook 'mldonkey-vd)


;enable horizontal scrolling in the console buffer
(add-hook 'mldonkey-console-hook
          (lambda () (setq truncate-lines t)))



;for convenient search

(defun d-mldonkey-next ()
  "kp-insert key"
  (interactive)
;  (other-window 1)
  (forward-line 1)
;  (other-window 1)
  )

(defun d-mldonkey-previous ()
  "kp-next key"
  (interactive)
;  (other-window 1)
  (forward-line -1)
;  (other-window 1)
  )

(defun d-mldonkey-insert-link ()
  "kp-delete key"
  (interactive)
;  (other-window 1)
  (let* ((cline (thing-at-point 'line))
	 (match (string-match "\\[ +\\([0-9]+\\)\\] +[0-9]+ +[0-9]+ +\\(.+\\.[A-z]+\\)" cline)) 
	 (dnumber (match-string 1 cline))
	 (name (match-string 2 cline)))
    (other-window 1)
    (insert (concat dnumber " "))
    (other-window 1)
    (save-window-excursion
      (switch-to-buffer "* ebook list*")
      (insert (concat " - " name "\n")))))

(defadvice mldonkey-console (after d-mldonkey-console)
  " "
  (local-set-key [kp-next] 'd-mldonkey-previous)
  (local-set-key [kp-insert] 'd-mldonkey-next)
  (local-set-key [kp-delete] 'd-mldonkey-insert-link))

(ad-activate 'mldonkey-console)


