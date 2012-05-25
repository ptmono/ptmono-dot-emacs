;; 0710300110 modified d-w3m-close-window
;; for gnus

;;; === Load w3m
;;; --------------------------------------------------------------
(require 'w3m-load)
(setq w3m-use-cookies t) ; enabling cookies
(setq w3m-cookie-accept-bad-cookies t)
(setq w3m-cookie-accept-domains '(
				  "google.com" "google.co.kr"
				  "yahoo.com" ".yahoo.com" "groups.yahoo.com"
				  "kldp.org"
				  ))
(setq w3m-cookie-file "/home/ptmono/.w3m/.cookie")


(setq w3m-default-display-inline-images nil) ;do not display image

;; To open firefox in w3m with M key
(defun d-w3m-view-url-with-external-browser (&optional url)
"to open the url of w3m buffer just with firefox this is modified. w3m에서 M키를 이함수로
바꾸어 둘 것이다."
  (interactive)
  ;(require 'w3m-util)
  (unless url
    (setq url (or url
		  (w3m-anchor (point))
		  (unless w3m-display-inline-images
		    (w3m-image))
		  (when (y-or-n-p (format "Browse <%s> ? " w3m-current-url))
		    w3m-current-url))))
  (if (w3m-url-valid url)
      (progn
	(message "Browsing <%s>..." url)
	(browse-url-firefox url)) ;just modified
    (w3m-message "No URL at point")))

(defalias 'w3m-view-url-with-external-browser 'd-w3m-view-url-with-external-browser)

(defcustom d-gnus-nnrss-last-buffer nil "")



;0612051233 w3m q problem
(defun d-w3m-close-window ()
  ""
  (interactive)
  (if (= (length (window-list)) 2)
      ;; When both buffer is w3m-mode d-w3m-close-window-without-frame
      ;; kill current buffer so that following added. #0707230700
      (let ((mode1 major-mode)
	    (mode2 (d-w3m-other-window-mode)))
	(unless (equal mode1 mode2)
	  (d-w3m-close-window-without-frame)))
    ;; to here
    (w3m-close-window))
  (when d-gnus-nnrss-last-buffer
    (progn
      (set-window-configuration d-gnus-nnrss-last-buffer)
      (setq d-gnus-nnrss-last-buffer nil)))
  (when d-search-last-buffer
    (progn
      (set-window-configuration d-search-last-buffer)
      (setq d-search-last-buffer nil))))

(defun d-w3m-other-window-mode ()
  (save-excursion
    (other-window 1)
    major-mode))


(defun d-w3m-close-window-without-frame ()
  "modified by w3m-close-window only eject the funcion w3m-delete-frames-and-
windows"
  (interactive)
  ;; `w3m-list-buffers' won't return all the emacs-w3m buffers if
  ;; `w3m-fb-mode' is turned on.
  (let* ((buffers (w3m-list-buffers t))
	 (bufs buffers)
	 buf windows window)
    (w3m-delete-frames-and-windows)
    (while bufs
      (setq buf (pop bufs))
      (w3m-cancel-refresh-timer buf)
      (bury-buffer buf))
    (while buffers
      (setq buf (pop buffers)
	    windows (get-buffer-window-list buf 'no-minibuf t))
      (while windows
	(setq window (pop windows))
	(set-window-buffer
	 window
	 (w3m-static-if (featurep 'xemacs)
	     (other-buffer buf (window-frame window) nil)
	   (other-buffer buf nil (window-frame window)))))))
  (w3m-select-buffer-close-window)
  ;; The current-buffer and displayed buffer are not necessarily the
  ;; same at this point; if they aren't bury-buffer will be a nop, and
  ;; we will infloop.
  (set-buffer (window-buffer (selected-window)))
  (while (eq major-mode 'w3m-mode)
    (bury-buffer)))


;; hooks
(add-hook 'w3m-form-input-textarea-mode-hook 'auto-fill-mode)


(defun d-w3m-waiting ()
  "wait to the time that w3m-goto-url opens url completely"
  (while (not (equal w3m-current-process nil))
    (sit-for 0.1)))

