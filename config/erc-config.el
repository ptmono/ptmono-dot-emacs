
;;; auto join
;
;; See auth.el
;; - d-erc-freenode
;; - d-erc-hanirc
;; - d-erc-p2p
;; is defined.


(setq erc-autojoin-channels-alist
      '(
      ("freenode.net"
       "#emacs"
       ;; "#wiki"
       ;; "#nethack"
       "#python"
       ;; "#linux"
       "#maemo"
       ;; "#Netfilter"
       ;; "#networking"
       "#fedora"
       "#pypy"
       "#opencv"
       "#ptmono"
       "#math"
       )
      ("hanirc.org"
       "#kldp"
       "#emacs"
       ;; "#debian-devel"
       "#python"
       ;; "#ZeroIRC" ; It is client door.
       )
      ("p2p-network.net"
       ;; "#bittalk"
       "#demonoid"
       )
      ))



(set-face-attribute 'erc-nick-default-face nil
		    :foreground "LightGoldenrod"
		    :background "black"
		    :weight 'ultra-light)


;;; === Ignore track - disable new post notification
;;; --------------------------------------------------------------

;; To disable the notification on all mode-line when the irc buffer is
;; changed. The default value is
;; (setq erc-insert-post-hook '(erc-make-read-only erc-track-modified-channels))

;; It is easy just include the tracked buffers.
(custom-set-variables
 '(erc-track-exclude '("#python"
		       ;"#emacs"
		       "#fedora"
		       "#nethack" "#maemo" "#math" "#pypy" "#opencv"
		       "##math" "freenode"
		       ;"#ptmono"
		       )))



;;; === Bittalk
;;; --------------------------------------------------------------
(defun erc-cmd-JOINBIT ()
  "join to the channel of bittalk"
  (erc-cmd-MSG "^BitCaT^ !invite 26ca572a72353e38431950a9fe222e8e")
; It is a problem that emacs join before invitation.  
  (sleep-for 2)
  (erc-cmd-JOIN "-invite"))




;; for ignoring contents
; See
(defcustom erc-foolish-content '("^<.*?> User Online" 
				 "^<.*?> User Offline: " 
				 "^<.*?> User: " "^<.*?> !user"
				 "^<.*?> !bonus")
  "Regular expressions to identify foolish content.
    Usually what happens is that you add the bots to
    `erc-ignore-list' and the bot commands to this list."
  :group 'erc
  :type '(repeat regexp))

(defun erc-foolish-content (msg)
  "Check whether MSG is foolish."
  (erc-list-match erc-foolish-content msg))

(add-hook 'erc-insert-pre-hook
	  (lambda (s)
	    (when (erc-foolish-content s)
	      (setq erc-insert-this nil))))


; encoding
(setq erc-encoding-coding-alist '(("#bittalk" . euc-kr)))


; for no more chat on bittalk

(defcustom d-erc-foolish-content-bittalk '("^<.*?> .*")
  "Regular expressions to identify foolish content.
    Usually what happens is that you add the bots to
    `erc-ignore-list' and the bot commands to this list."
  :group 'erc
  :type '(repeat regexp))


; It was not implied in erc command line.
(defun erc-cmd-BITTALK-SILENT ()
  ""
  (switch-to-buffer "#bittalk")
  (make-local-variable 'erc-foolish-content)
  (setq erc-foolish-content d-erc-foolish-content-bittalk))



;; (eval-after-load 'erc-track
;;   '(progn
;;      (defun erc-bar-move-back (n)
;;        "Moves back n message lines. Ignores wrapping, and server messages."
;;        (interactive "nHow many lines ? ")
;;        (re-search-backward "^.*<.*>" nil t n))

;;      (defun erc-bar-update-overlay ()
;;        "Update the overlay for current buffer, based on the content of
;; erc-modified-channels-alist. Should be executed on window change."
;;        (interactive)
;;        (let* ((info (assq (current-buffer) erc-modified-channels-alist))
;; 	      (count (cadr info)))
;; 	 (if (and info (> count erc-bar-threshold))
;; 	     (save-excursion
;; 	       (end-of-buffer)
;; 	       (when (erc-bar-move-back count)
;; 		 (let ((inhibit-field-text-motion t))
;; 		   (move-overlay erc-bar-overlay
;; 				 (line-beginning-position)
;; 				 (line-end-position)
;; 				 (current-buffer)))))
;; 	   (delete-overlay erc-bar-overlay))))

;;      (defvar erc-bar-threshold 1
;;        "Display bar when there are more than erc-bar-threshold unread messages.")
;;      (defvar erc-bar-overlay nil
;;        "Overlay used to set bar")
;;      (setq erc-bar-overlay (make-overlay 0 0))
;;      (overlay-put erc-bar-overlay 'face '(:underline "black"))
;;      ;;put the hook before erc-modified-channels-update
;;      (defadvice erc-track-mode (after erc-bar-setup-hook
;; 				      (&rest args) activate)
;;        ;;remove and add, so we know it's in the first place
;;        (remove-hook 'window-configuration-change-hook 'erc-bar-update-overlay)
;;        (add-hook 'window-configuration-change-hook 'erc-bar-update-overlay))
;;      (add-hook 'erc-send-completed-hook (lambda (str)
;; 					  (erc-bar-update-overlay)))))
