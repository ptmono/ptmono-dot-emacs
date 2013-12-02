;;; for w3m-search

;; load w3m-session : to save emacs-w3m session 
;; w3m-session requires url-util. We can use another method to save
;; emacs-w3m session. See emacswiki's emacs-w3m.
;; (require 'w3m-session) 


;;; === Saving Buffers with Desktop
;;; --------------------------------------------------------------
  ;; (desktop-load-default) 
  ;; (defun desktop-buffer-w3m-misc-data ()
  ;;   "Save data necessary to restore a `w3m' buffer."
  ;;   (when (eq major-mode 'w3m-mode)
  ;;     w3m-current-url))

  ;; (defun desktop-buffer-w3m ()
  ;;   "Restore a `w3m' buffer on `desktop' load."
  ;;   (when (eq 'w3m-mode desktop-buffer-major-mode)
  ;;     (let ((url desktop-buffer-misc))
  ;;       (when url
  ;;         (require 'w3m)
  ;;         (if (string-match "^file" url)
  ;;             (w3m-find-file (substring url 7))
  ;;           (w3m-goto-url url))
  ;;         (current-buffer)))))

  ;; (add-to-list 'desktop-buffer-handlers 'desktop-buffer-w3m)
  ;; (add-to-list 'desktop-buffer-misc-functions 'desktop-buffer-w3m-misc-data)
  ;; (add-to-list 'desktop-buffer-modes-to-save 'w3m-mode)

  ;; (desktop-load-default) ; 위에 써두었다.
  ;;    (setq history-length 250)
  ;;    (add-to-list 'desktop-globals-to-save 'file-name-history)
  ;;    (desktop-read)
  ;;    (setq desktop-enable t)


;;; === Face
;;; --------------------------------------------------------------
  ;; more see myel.el
  ;; (require 'w32-symlinks)
  ;; (require 'cygwin32-symlink)


;;; === ddns
;;; --------------------------------------------------------------
  ;; no need anymore
  ;;(d-ddns-update)


;;; === Basic actions
;;; --------------------------------------------------------------
(iswitchb-mode) ; for C-x C-b(switch-to-buffer)

;; If you meet an error "server is unsafe". Change the ownership for
;; ~/.emacs.d/server with the command "chown -R ptmono server". See more
;; http://stackoverflow.com/questions/885793/emacs-error-when-calling-server-start
(server-start)
;; (color-theme-jsc-light)
(d-color-theme-hober)
;; (d-color-theme-standard)
;; (d-last-work)
(d-face)

;; (set-fontset-font "fontset-default" '(#x1100 . #xffdc) '("UnDotum" . "unicode-bmp"))
;; (set-fontset-font "fontset-default" '(#xe0bc . #xf66e) '("UnDotum" . "unicode-bmp"))

;; (d-frame-set-phw "100x100+300")
(switch-to-buffer "*Messages*")

(d-worknote-openWorknote)

(require 'projectb)

(put 'upcase-region 'disabled nil)


(defun d-test ()
  ""
  (interactive)
  (require 'csharp-mode)
  (find-file "~/tmp/csharp/test.cs")
  )
(put 'scroll-left 'disabled nil)


