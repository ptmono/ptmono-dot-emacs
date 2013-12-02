;; There is etc-config.el.


;;; === extview :which opens files using outside programs
;;; --------------------------------------------------------------
(require 'extview)
;(push '("\\.pdf$" . "xpdf %s") extview-application-associations)

(if (d-windowp)
    (progn
    (push '("\\.pdf$" . "C:/Users/ptmono/AppData/Local/Apps/Evince-2.32.0.14401/bin/evince.exe %s") extview-application-associations)
    (push '("\\.chm$" . "hh %s") extview-application-associations)
    )
  (push '("\\.ps$" . "evince %s") extview-application-associations)
  (push '("\\.pdf$" . "evince %s") extview-application-associations)
  ;; (push '("\\.ps$" . "okular %s") extview-application-associations)
  ;; (push '("\\.pdf$" . "okular %s") extview-application-associations)

  (push '("\\.djvu$" . "djview4 %s") extview-application-associations)
  (push '("\\.chm$" . "kchmviewer %s") extview-application-associations)
  (push '("\\.mp3$" . "xmms %s") extview-application-associations)
  (push '("\\.hwp$" . "hwp.sh %s") extview-application-associations)
  (push '("\\.zip$" . "file-roller %s") extview-application-associations)
  (push '("\\.rar$" . "file-roller %s") extview-application-associations)
  ;; (push '("\\.avi$" . "gmplayer %s") extview-application-associations)
  (push '("\\.avi$" . "smplayer %s -fs") extview-application-associations)
  (push '("\\.mkv$" . "smplayer %s -fs") extview-application-associations)
  (push '("\\.wmv$" . "smplayer %s") extview-application-associations)
  (push '("\\.mpg$" . "smplayer %s") extview-application-associations)
  (push '("\\.asf$" . "smplayer %s") extview-application-associations)
  (push '("\\.mpeg$" . "smplayer %s") extview-application-associations)
  (push '("\\.dvi$" . "xdvi %s") extview-application-associations)
  (push '("\\.xcf$" . "gimp %s") extview-application-associations)
  (push '("\\.odt$" . "oowriter %s") extview-application-associations)
  (push '("\\.doc$" . "oowriter %s") extview-application-associations)
  (push '("\\.ppt$" . "ooimpress %s") extview-application-associations)
  (push '("\\.xls$" . "oocalc %s") extview-application-associations)
  (push '("\\.swf$" . "/usr/bin/swiftfox %s") extview-application-associations)
  (push '("\\.cbr$" . "qcomicbook %s") extview-application-associations)

  ;; You can choose the external
  (push '("\\.html$" . ask) extview-application-associations)
  (push '("\\.php$" . ask) extview-application-associations)
  (push '("\\.jpg$" . "eog %s") extview-application-associations)
  (push '("\\.gif$" . "eog %s") extview-application-associations)
  (push '("\\.png$" . "eog %s") extview-application-associations)
  (push '("\\.torrent$" . ask) extview-application-associations)
  )


;; When I migrate to ubuntu find-file couldn't open *.py file. extview.el
;; is the cause. extview.el uses the program mailcap to find associated
;; program for mime. We can get all mime.type from /etc/mime.types. The
;; mime of python is "text/x-python". /etc/mailcap and ~/.mailcap contains
;; the associated program for the mime type. All text type uses less.
;; text/*; less '%s'; needsterminal
;; text/*; view '%s'; edit=vim '%s'; compose=vim '%s'; test=test -x /usr/bin/vim; needsterminal
;; text/*; more '%s'; needsterminal
;; text/*; view '%s'; edit=vi '%s'; compose=vi '%s'; needsterminal
;; So we have to manually skip for text type.
(defadvice find-file (around extview-find-file 
                             (filename &optional wildcards) activate)
  "Around advice for find-file which checks if the file should be
opened with an external viewer instead of Emacs."
  (interactive "FFind file: \np")
  ;; check `extview-application-associations' first, since it has
  ;; priority
  (let ((handler (some (lambda (descriptor)
                         (if (string-match (car descriptor) filename)
                             descriptor))
                       extview-application-associations)))
    (if (and handler
             (not (and (eq 'ask (cdr handler))
                       (y-or-n-p "Open with external viewer? "))))
        (if (eq (cdr handler) 'ask)     ; open with emacs
            (setq handler nil)
          (setq handler (cdr handler)))

      ;; check if there is an appropriate mailcap entry
      (let* ((ext (file-name-extension filename))
             (mime (if ext 
                       (mailcap-extension-to-mime ext))))
        (if mime
	    ;; Skip for text types
	    (unless (equal (string-match "^text" mime) 0)
	      (setq handler (mailcap-mime-info mime))))
	  

        ;; only string handlers are considered, since we're interested
        ;; in external viewers, not emacs functions
        (unless (stringp handler)
          (setq handler nil))))

    ;; call the handler if found
    (if handler
        (let* ((logbuffer "*extview log*")
               (components (split-string handler))
               ;; hopefully the first component is always the
               ;; application name
               (app (car components))
               ;; substitute file name for %s args
               (args (mapcar (lambda (arg)
                               (if (or (equal "%s" arg)
                                       (equal "'%s'" arg))
                                   (expand-file-name filename)
                                 arg))
                             (cdr components))))
          
          (get-buffer-create logbuffer)
          (with-current-buffer logbuffer
            (goto-char (point-max))
            (insert (format "Opening file %s with handler: %s"
                            filename handler)
                    "\n"))

          (apply 'start-process "extview-process" logbuffer app args)          

          (message (concat "File is opened with an external viewer. "
                           "See buffer %s for status messages.")
                   logbuffer))
                         
      ad-do-it)))



;;; === For bhl-mode
;;; --------------------------------------------------------------
;(autoload 'bhl-mode "bhl" "BHL Mode" t)
;(add-to-list 'auto-mode-alist '("\\.bhl$" . bhl-mode))


;;; === For dicmode : dictionary
;;; --------------------------------------------------------------
(autoload 'dictionary-search "dictionary" 
  "Ask for a word and search it in all dictionaries" t)
(autoload 'dictionary-match-words "dictionary"
  "Ask for a word and search all matching words in the dictionaries" t)
(autoload 'dictionary-lookup-definition "dictionary" 
  "Unconditionally lookup the word at point." t)
(autoload 'dictionary "dictionary"
  "Create a new dictionary buffer" t)
(autoload 'dictionary-mouse-popup-matching-words "dictionary"
  "Display entries matching the word at the cursor" t)
(autoload 'dictionary-popup-matching-words "dictionary"
  "Display entries matching the word at the point" t)
(autoload 'dictionary-tooltip-mode "dictionary"
  "Display tooltips for the current word" t)
(unless (boundp 'running-xemacs)
  (autoload 'global-dictionary-tooltip-mode "dictionary"
    "Enable/disable dictionary-tooltip-mode for all buffers" t))

;; These lines are also stored in a file dictionary-init.el which can be
;; included in your .emacs file by using the following command.
(load "dictionary-init")
;; key bindings
;(global-set-key "\C-cs" 'dictionary-search)
;(global-set-key "\C-cm" 'dictionary-match-words)



;;; === For choronometer mode
;;; --------------------------------------------------------------
;; This is an alarm tool.
;; * a - set alarm
;; * u - unset alarm
;; * p - toggle pause
;; * r - restart
;; * h - hide
;; * q - exit
;; * ? - help

;(require 'chronometer)


;;; === For ell.el
;;; --------------------------------------------------------------
;; all elisp list를 emacs 상에서 뽑을 수 있을까하여 사용해 보았지만 잘되지
;; 않았다. elib는 ell.el을 사용시 필요한 lib이다.
;(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/elib/")
;(require 'ell)


;;; === rfcview
;;; --------------------------------------------------------------
(add-to-list 'load-path (concat d-dir-emacs "etc/rfcview"))
(load "rfc")
(load "rfcview")
(require 'rfc)
(require 'rfcview)
(setq auto-mode-alist
      (cons '("/rfc[0-9]+\\.txt\\(\\.gz\\)?\\'" . rfcview-mode)
            auto-mode-alist))

(autoload 'rfcview-mode "rfcview" nil t)


;;; === sb-rfcview
;;; --------------------------------------------------------------
;; It has a problem with speedbar.

;; (eval-after-load "speedbar" '(load-library "sb-rfcview"))
;; (custom-set-variables
;;  '(speedbar-supported-extension-expressions
;;    (append
;;     speedbar-supported-extension-expressions
;;     '("rfc[0-9]+\\.txt"))))


;;; === rfc.el
;;; --------------------------------------------------------------
(require 'rfc)
(setq rfc-url-save-directory "~/rfc")
(setq rfc-index-url "http://www.ietf.org/iesg/1rfc_index.txt")
(setq rfc-archive-alist (list (concat rfc-url-save-directory "/rfc.zip")
                              rfc-url-save-directory
                              "http://www.ietf.org/rfc/"))
(setq rfc-insert-content-url-hook '(rfc-url-save))

(defadvice rfc-goto-number (after d-rfc-goto-number)
  "add rfcview-mode"
  (rfcview-mode))

(ad-activate 'rfc-goto-number)


;;; === shell-command.el
;;; --------------------------------------------------------------
;; for completions of shell-command, shell-command-on-region, grep,
;; grep-find, and compile See emacsPackages#0707191555
(require 'shell-command)
(shell-command-completion-mode)


;;; === visual basic
;;; --------------------------------------------------------------
;; visual-basic-mode is more line than vbnet-mode --,.--
(load "visual-basic-mode")

;; visual-basic-mode
(autoload 'visual-basic-mode "visual-basic-mode" "Visual Basic mode." t)
(setq auto-mode-alist (append '(("\\.\\(frm\\|bas\\|cls\\|vbs\\)$" .
				 visual-basic-mode)) auto-mode-alist))
;; vbnet-mode
;;(autoload 'vbnet-mode "vbnet-mode" "Visual Basic mode." t)
;;(setq auto-mode-alist (append '(("\\.\\(frm\\|bas\\|cls\\)$" .
;;				 vbnet-mode)) auto-mode-alist))


;;; === Tramp
;;; --------------------------------------------------------------
(require 'tramp)
;(setq tramp-default-method "scp")
(setq tramp-default-method "pscp")


;;; === cmake-mode
;;; --------------------------------------------------------------
(setq load-path (cons (expand-file-name "/dir/with/cmake-mode") load-path))
(require 'cmake-mode)
(setq auto-mode-alist
      (append '(("CMakeLists\\.txt\\'" . cmake-mode)
		("\\.cmake\\'" . cmake-mode))
	      auto-mode-alist))

;;; === Uniquify
;;; --------------------------------------------------------------
;; Makefile, Makefile<2> will be Makefile|samdol, Makefile|ppf
;; See emacsModes.muse#1212110326
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator "/")
(setq uniquify-after-kill-buffer-p t) ; rename after killing uniquified
(setq uniquify-ignore-buffers-re "^\\*") ; don't muck with special buffers


;;; === nsis-mode
;;; --------------------------------------------------------------
;; from http://nsis.sourceforge.net/Nsi-mode_for_emacs


(autoload 'nsis-mode "nsis-mode" "NSIS mode" t)
(setq auto-mode-alist (append '(("\\.\\([Nn][Ss][Ii]\\)$" .
                                 nsis-mode)) auto-mode-alist))
(setq auto-mode-alist (append '(("\\.\\([Nn][Ss][Hh]\\)$" .
                                 nsis-mode)) auto-mode-alist))

;;; === rpm-spec-mode
;;; --------------------------------------------------------------
(autoload 'rpm-spec-mode "rpm-spec-mode.el" "RPM spec mode." t)
(setq auto-mode-alist (append '(("\\.spec" . rpm-spec-mode))
                               auto-mode-alist))
(setq rpm-spec-user-mail-address "ptmono@gmail.com")

(defun d-spec-changelog-increment-version ()
  (interactive)
  (goto-char (point-min))
  (let* ((max (search-forward-regexp rpm-section-regexp))
       (version (rpm-spec-field-value "Version" max)))
   (rpm-add-change-log-entry (concat "Upgrade version to " version))
   )
  )

;;; === bash-completion
;;; --------------------------------------------------------------
;; In shell-mode, <Tab> doesn't complete alias. Emacs use
;; 'comint-dynamic-complete. You can use M-x term to complete alias. But
;; it not convenient. bash-completion.el helps this problem for
;; shell-mode.

(if (d-windowp)
    (autoload 'bash-completion-dynamic-complete 
      "bash-completion"
      "BASH completion hook")
  (add-hook 'shell-dynamic-complete-functions
	    'bash-completion-dynamic-complete)
  (add-hook 'shell-command-complete-functions
	    'bash-completion-dynamic-complete)

  (require 'bash-completion)
  (bash-completion-setup)
)

;;; === re-builder
;;; --------------------------------------------------------------

(defvar d-re-builder-regexp-grouping-face 'font-lock-regexp-grouping-backslash)
(defvar d-re-builder-regexp-separator-face 'font-lock-constant-face)
(defvar d-re-builder/font-lock-keywords
  '(("\\\\\\\\(\\|\\\\\\\\)" 0 d-re-builder-regexp-grouping-face t)
    ("\\\\\\\\|" 0 d-re-builder-regexp-separator-face t)
    ))

(defun d-re-builder/hook ()
  (font-lock-add-keywords nil d-re-builder/font-lock-keywords)
)

(add-hook 'reb-mode-hook 'd-re-builder/hook)


;;; === Autopair
;;; --------------------------------------------------------------
;(require 'autopair)
;(autopair-global-mode) ;; to enable in all buffers


