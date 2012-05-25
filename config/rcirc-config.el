;; 1101062134 Currently It is not used. Instead use erc.
;; rcirc
(require 'rcirc)

;; Tracker
(rcirc-track-minor-mode 1)
(setq global-mode-string '("" rcirc-activity-string))

;; Join these channels on startup.
 (setq rcirc-startup-channels-alist
       '(("freenode" "#emacs" "#math" "#lisp" "#scheme" "#erlang"
 	  "##c++" "#python")
 	("choopa" "#math" "#c++" "#Python" "#compsci")))

(setq rcirc-default-nick "Cowmoo")
(setq rcirc-default-user-name "Cowmoo")
(setq rcirc-default-user-full-name "Cowmoo")
(setq rcirc-default-server "kornbluth.freenode.net")

;; authentication info on freenode
(setq rcirc-authinfo `(("freenode" nickserv ,rcirc-default-nick *CENSORED-PASSWORD*)))

;; Connect to these servers and channels on startup

(setq rcirc-server-alist '(("kornbluth.freenode.net"
			    :channels ("#emacs" "#math" "#lisp"
			     "#scheme" "#erlang" "#algos" "##c++" "#python"))
			   ("irc.choopa.net"
			    :channels ("#math" "#c++" "#Python"
				       "#compsci"))))

;; Truncate channel buffer after it reaches this number of lines
(setq rcirc-buffer-maximum-lines 15000)

(setq rcirc-log-directory "~/MyEmacs/Configure-File/Rcirc/logs")
(setq rcirc-notify-open t)
(setq rcirc-notify-timeout 1)
(setq rcirc-omit-responses

      (quote ("JOIN" "PART" "QUIT" "NICK" "AWAY" "MODE")))
(setq rcirc-prompt "> ")
(setq rcirc-time-format "[%H:%M] ")
(setq rcirc-track-minor-mode nil)
(add-hook 'rcirc-mode-hook '(lambda () (rcirc-omit-mode)))
(add-hook 'rcirc-print-hooks 'rcirc-write-log)


; Tracker
(rcirc-track-minor-mode 1)

; Default settings
(setq rcirc-default-nick "gnuvince"
      rcirc-time-format "%R "
      rcirc-buffer-maximum-lines 1000
      rcirc-authinfo '(("oftc" nickserv "gnuvince" "SUPERSECRET")
                       ("freenode" nickserv "gnuvince" "SUPERSECRET"))
      rcirc-startup-channels-alist '(("oftc" "#grasshoppers")
                                     ("freenode" "#chezta_mere")))

; Make my own nickname red
(set-face-foreground 'rcirc-my-nick "red" nil)

; Always keep the prompt at the bottom of the buffer
(add-hook 'rcirc-mode-hook
          '(lambda ()
             (set (make-local-variable 'scroll-conservatively) 8192)))

; Wrap long lines according to the width of the window
(add-hook 'window-configuration-change-hook
          '(lambda ()
             (setq rcirc-fill-column (- (window-width) 2))))

;; (defun rcirc-kill-all-buffers ()
;;   (interactive)
;;   (kill-all-mode-buffers 'rcirc-mode))

;; (defun irc ()
;;   (interactive)
;;   (rcirc-connect "irc.oftc.net" 6667 rcirc-default-nick rcirc-default-nick rcirc-default-nick (assoc "oftc" rcirc-startup-channels-alist))
;;   (rcirc-connect "irc.freenode.net" 6667 rcirc-default-nick rcirc-default-nick rcirc-default-nick (assoc "freenode" rcirc-startup-channels-alist)))




;======================================================================
;;; Language                                                        ;;;
;======================================================================

;; ;you can call this function after loading erc (if manual change is needed...)
;; ;; (setq erc-default-coding-system 'iso-2022-jp)
 
;; (add-hook 'erc-mode-hook
;; 	  '(lambda()
;;              ;;this is what's called automatically
;;              (setq erc-default-coding-system '(iso-2022-jp . iso-2022-jp))))
;; (setq rcirc-default-nick "my-cool-nickname") ;;of course, whatever you like
;; (setq rcirc-startup-channels-alist
;;       '(("\.2ch\.net$" "#japanese")))
;;       ;;e.g. to get you automatically into the #japanese channel
;;       ;; if entered without specifying any channel 
;; ;; '(("\.freenode\.net$" "#emacs" "#rcirc")))
 
;;       ;;this are rcirc\'s settings (another irc client...)
;; (add-hook 'rcirc-mode-hook ;irc settings
;; 	  '(lambda () 
;; 	     (set-rcirc-decode-coding-system 'iso-2022-jp)
;; 	     (set-rcirc-encode-coding-system 'iso-2022-jp)))
; Use latin-1, because the french people I chat with haven't made the switch to UTF-8

;; (set-rcirc-decode-coding-system 'latin-1)
;; (set-rcirc-encode-coding-system 'latin-1)

