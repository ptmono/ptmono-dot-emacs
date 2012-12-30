;;; === color-theme
;;; --------------------------------------------------------------
;; (defun select-random-color-theme ()
;;  "Select random color theme"
;;  (interactive)
;;  (random t)
;;  (let* ((index (+ (random (- (length color-themes) 2)) 2))
;;         (theme (nth index color-themes)))
;;    (save-font-excursion 'default
;;      (funcall (car theme)))
;;    (message "%s installed" (symbol-name (car theme)))))

;; (defun set-frame-color-theme (frame)
;;  (select-frame frame)
;;  (select-random-color-theme))

;; (when (and window-system
;;           (locate-library "color-theme"))
;;  (require 'color-theme)
;;  (and (locate-library "pink-bliss")
;;       (require 'pink-bliss))

;;  (and (locate-library "cinsk-wood")
;;       (require 'cinsk-wood))

;;  (global-set-key [(control f1)] 'select-random-color-theme)
;;  (add-hook 'after-make-frame-functions 'set-frame-color-theme)
;;  )

(defvar d-color-theme-p nil "To identify that emacs is using color-theme")

(require 'color-theme)
(color-theme-initialize)
;(color-theme-tty-dark)
;(color-theme-robin-hood)
;(color-theme-hober)

(defun d-color-theme-tty-dark ()
  "Color theme by Oivvio Polite, created 2002-02-01.  Good for tty display."
  (interactive)
  (color-theme-install
   '(color-theme-tty-dark
     ((background-color . "black")
      (background-mode . dark)
      (border-color . "blue")
      (cursor-color . "red")
      (foreground-color . "white")
      (mouse-color . "black"))
     ((ispell-highlight-face . highlight)
      (list-matching-lines-face . bold)
      (tinyreplace-:face . highlight)
      (view-highlight-face . highlight))
     (default ((t (nil))))
     (bold ((t (:underline t :background "black" :foreground "white"))))
     (bold-italic ((t (:underline t :foreground "white"))))
     (calendar-today-face ((t (:underline t))))
     (diary-face ((t (:foreground "red"))))
     (font-lock-builtin-face ((t (:foreground "blue"))))
     (font-lock-comment-face ((t (:foreground "cyan"))))
     (font-lock-constant-face ((t (:foreground "magenta"))))
     (font-lock-function-name-face ((t (:foreground "cyan"))))
     (font-lock-keyword-face ((t (:foreground "red"))))
     (font-lock-string-face ((t (:foreground "green"))))
     (font-lock-type-face ((t (:foreground "yellow"))))
     (font-lock-variable-name-face ((t (:foreground "blue"))))
     (font-lock-warning-face ((t (:bold t :foreground "magenta"))))
     (highlight ((t (:background "blue" :foreground "yellow"))))
     (holiday-face ((t (:background "cyan"))))
     (info-menu-5 ((t (:underline t))))
     (info-node ((t (:italic t :bold t))))
     (info-xref ((t (:bold t))))
     (italic ((t (:underline t :background "red"))))
     (message-cited-text-face ((t (:foreground "red"))))
     (message-header-cc-face ((t (:bold t :foreground "green"))))
     (message-header-name-face ((t (:foreground "green"))))
     (message-header-newsgroups-face ((t (:italic t :bold t :foreground "yellow"))))
     (message-header-other-face ((t (:foreground "#b00000"))))
     (message-header-subject-face ((t (:foreground "green"))))
     (message-header-to-face ((t (:bold t :foreground "green"))))
     (message-header-xheader-face ((t (:foreground "blue"))))
     (message-mml-face ((t (:foreground "green"))))
     (message-separator-face ((t (:foreground "blue"))))

     (modeline ((t (:background "white" :foreground "blue"))))
     (modeline-buffer-id ((t (:background "white" :foreground "red"))))
     (modeline-mousable ((t (:background "white" :foreground "magenta"))))
     (modeline-mousable-minor-mode ((t (:background "white" :foreground "yellow"))))
     (region ((t (:background "white" :foreground "black"))))
     (zmacs-region ((t (:background "cyan" :foreground "black"))))
     (secondary-selection ((t (:background "blue"))))
     (show-paren-match-face ((t (:background "red"))))
     (show-paren-mismatch-face ((t (:background "magenta" :foreground "white"))))
     (underline ((t (:underline t)))))))

(defun d-color-theme-hober (&optional preview)
  "Does all sorts of crazy stuff.
Originally based on color-theme-standard, so I probably still have some
setting that I haven't changed. I also liberally copied settings from
the other themes in this package. The end result isn't much like the
other ones; I hope you like it."
  (interactive)
  (setq d-color-theme-p t)
  (color-theme-install
   '(color-theme-hober
     ((foreground-color . "#c0c0c0")
      ;(background-color . "black")
      (background-color . "#000000")
      ;(background-color . "#1c1c1c") ; 2c2c2c, 3c3c3c. It's so light
      (mouse-color . "black")

      ;(cursor-color . "medium turquoise")
      (cursor-color . "#e5e5e5")
      (border-color . "black")
      (background-mode . dark))

     ;; individual

     ;; Muse has some problem. muse-header- faces has problem with in
     ;; color-theme. d-muse-set-header-faces has created to solve the
     ;; problem. See d-muse-set-header-faces.
     ;; (muse-link ((t (:underline "#ffffff")))); "0006ff")))) ;"#4d4d4d"))))
     (muse-link ((t (:underline  "#84aefd" :foreground "#6e92ff")))); "0006ff")))) ;"#4d4d4d"))))
     (muse-emphasis-1 ((t (:bold t :foreground "#6e92ff"))));"#4876ff"))))
     (muse-emphasis-2 ((t (:bold t :foreground "white"))))
     (muse-verbatim ((t	(:foreground "#7a7a7a")))); :background "#d0d0d0"))))
     (muse-reference-face ((t (:foreground "#00a71f"))))

     ;; planner
     (planner-cancelled-task-face ((t (:foreground "#6a6a6a" :strike-through "#464646"))))
     (planner-completed-task-face ((t (:foreground "#6a6a6a"))))
     (planner-note-headline-face ((t (:background "#3f542a"
     						  :foreground "#ffe4ad"
     						  :overline "#d2d0d0"
     						  :slant oblique
     						  :weight bold
     						  :height 1.2
     						  :width normal))))

     ;; Etc
     (mmm-default-submode-face ((t (:background "black"))))
     (d-calendar-today-color ((t (:foreground "sienna" :underline "red" :weight bold))))
     ;(highlight-current-line-face ((t (:inverse-video t))))
     (highlight-current-line-face ((t (:background "gray43"))))
     (widget-inactive ((t (:foreground "dim gray" :background "black"))))
     (dictionary-button-face ((t (:bold t :foreground "white"))))
     (mumamo-background-chunk-submode1 ((t (:background "#040910"))))
     (rst-level-1-face ((t (:background "white" :foreground "black"))))
     (rst-level-2-face ((t (:background "white" :foreground "black"))))
     (rst-level-3-face ((t (:background "white" :foreground "black"))))

     
     
     ;; xhtml
     (mumamo-background-chunk-major ((t (:background "black"))))
     (gnus-face-1 ((t (:background "gray" :underline t))) t)

     ;; erc
     (erc-nick-default-face ((t (:bold nil :foreground "LightGoldenrod"))))
     
     ;; log-view
     ;; See logview-config.el

     ;; gnus-level-default-subscribed is 3
     (gnus-group-news-1 ((t (:foreground "red" :bold t))))
     (gnus-group-news-1-empty ((t (:foreground "red"))))
     (gnus-group-news-4 ((t (:foreground "#936649" :bold t))))
     (gnus-group-news-4-empty ((t (:foreground "#936649"))))
     (gnus-group-news-5 ((t (:foreground "#939393" :bold t))))
     (gnus-group-news-5-empty ((t (:foreground "#939393"))))
     (gnus-group-news-6 ((t (:foreground "#565656")))) ;6a6a6a
     (gnus-group-news-6-empty ((t (:foreground "#565656"))))

     (gnus-group-news-low ((t (:foreground "#464646" :strike-through t)))) ; for level 7
     (gnus-group-news-low-empty ((t (:foreground "#6a6a6a" :strike-through t))))

     (gnus-group-mail-1 ((t (:foreground "red" :bold t))))
     (gnus-group-mail-1-empty ((t (:foreground "red"))))
     (gnus-group-mail-2 ((t (:foreground "#657bff" :bold t))))
     (gnus-group-mail-2-empty ((t (:foreground "#657bff"))))
     (gnus-group-mail-3 ((t (:foreground "#5da765" :bold t))))
     (gnus-group-mail-3-empty ((t (:foreground "#5da765"))))
     (gnus-group-mail-4 ((t (:foreground "#936649" :bold t))))
     (gnus-group-mail-4-empty ((t (:foreground "#936649"))))

     (gnus-group-mail-low ((t (:foreground "#6a6a6a")))) ;for level 7
     (gnus-group-mail-low-empty ((t (:foreground "#6a6a6a"))))
     (tooltip ((t (:foreground "black" :background "#c0c0c0"))))

     ;; ----------------------------------------------------------------------------------
     ;; ----------------------------------------------------------------------------------

     (default ((t (:foreground "#dbdbdb")))) ;"#d4d4d4"))))
     (modeline ((t (:foreground "white" :background "darkslateblue"))))
     (modeline-buffer-id ((t (:foreground "white" :background "darkslateblue"))))
     (modeline-mousable ((t (:foreground "white" :background "darkslateblue"))))
     (modeline-mousable-minor-mode ((t (:foreground "white" :background "darkslateblue"))))
     (highlight ((t (:foreground "black" :background "#c0c0c0"))))
     (bold ((t (:bold t :foreground "white"))))
     (italic ((t (:italic t))))
     (bold-italic ((t (:bold t :italic t))))
     (region ((t (:foreground "white" :background "darkslateblue"))))
     (zmacs-region ((t (:foreground "white" :background "darkslateblue"))))
     (secondary-selection ((t (:background "paleturquoise"))))
     (underline ((t (:underline t))))
     (diary-face ((t (:foreground "red"))))
     (calendar-today-face ((t (:underline t))))
     ;; modified
     (holiday-face ((t (:background "#5e5e3b"))))
     (widget-documentation-face ((t (:foreground "dark green" :background "white"))))
     (widget-button-face ((t (:bold t))))
     (widget-button-pressed-face ((t (:foreground "red" :background "black"))))
     (widget-field-face ((t (:background "gray85" :foreground "black"))))
     (widget-single-line-field-face ((t (:background "gray85" :foreground "black"))))
     (widget-inactive-face ((t (:foreground "dim gray" :background "red"))))
     (fixed ((t (:bold t))))
     (excerpt ((t (:italic t))))
     (term-default-fg ((t (nil))))
     (term-default-bg ((t (nil))))
     (term-default-fg-inv ((t (nil))))
     (term-default-bg-inv ((t (nil))))
     (term-bold ((t (:bold t))))
     (term-underline ((t (:underline t))))
     (term-invisible ((t (nil))))
     (term-invisible-inv ((t (nil))))
     (term-white ((t (:foreground "#c0c0c0"))))
     (term-whitebg ((t (:background "#c0c0c0"))))
     (term-black ((t (:foreground "black"))))
     (term-blackbg ((t (:background "black"))))
     (term-red ((t (:foreground "#ef8171"))))
     (term-redbg ((t (:background "#ef8171"))))
     (term-green ((t (:foreground "#e5f779"))))
     (term-greenbg ((t (:background "#e5f779"))))
     (term-yellow ((t (:foreground "#fff796"))))
     (term-yellowbg ((t (:background "#fff796"))))
     (term-blue ((t (:foreground "#4186be"))))
     (term-bluebg ((t (:background "#4186be"))))
     (term-magenta ((t (:foreground "#ef9ebe"))))
     (term-magentabg ((t (:background "#ef9ebe"))))
     (term-cyan ((t (:foreground "#71bebe"))))
     (term-cyanbg ((t (:background "#71bebe"))))
     (font-lock-keyword-face ((t (:foreground "#00ffff"))))

     ;; font-lock-doc-face 부분을 font-lock-function-name-face 가 override하여 이것을
     ;; 위로 올렸다. 올렸지만 여전히 같은 형태이다.
     (font-lock-function-name-face ((t (:foreground "#4186be"))))

     ;; font-lock-doc-face가 lisp의 doc 부분의 face인데 여기에서는
     ;; font-lock-string-face가 사용된 것 같다.
     (font-lock-comment-face ((t (:foreground "Red"))))
     (font-lock-string-face ((t (:foreground "#ffff00")))); "#7a7a7a")))); "#ffff00"))))
     (font-lock-doc-face ((t (:foreground "#7a7a7a")))) ; function의 doc
     (font-lock-constant-face ((t (:foreground "#00ff00"))))
     (font-lock-builtin-face ((t (:foreground "#ffaa00"))))
     (font-lock-type-face ((t (:foreground "Coral"))))
     (font-lock-warning-face ((t (:foreground "Red" :bold t))))

     (font-lock-variable-name-face ((t (:foreground "white" :bold t))))
     (message-header-to-face ((t (:foreground "#4186be" :bold t))))
     (message-header-cc-face ((t (:foreground "#4186be"))))
     (message-header-subject-face ((t (:foreground "#4186be" :bold t))))
     (message-header-newsgroups-face ((t (:foreground "Coral" :bold t))))
     (message-header-other-face ((t (:foreground "steel blue"))))
     (message-header-name-face ((t (:foreground "white"))))
     (message-header-xheader-face ((t (:foreground "blue"))))
     (message-separator-face ((t (:foreground "brown"))))
     (message-cited-text-face ((t (:foreground "white"))))
     (gnus-header-from-face ((t (:foreground "Coral"))))
     (gnus-header-subject-face ((t (:foreground "#4186be"))))
     (gnus-header-newsgroups-face ((t (:foreground "#4186be" :italic t))))
     (gnus-header-name-face ((t (:foreground "white"))))
     (gnus-header-content-face ((t (:foreground "#4186be" :italic t))))
     (gnus-cite-attribution-face ((t (:italic t))))
     (gnus-cite-face-list ((t (:bold nil :foreground "red"))))
     (gnus-group-news-1-face ((t (:foreground "ForestGreen" :bold t))))
     (gnus-group-news-1-empty-face ((t (:foreground "ForestGreen"))))
     (gnus-group-news-2-face ((t (:foreground "CadetBlue4" :bold t))))
     (gnus-group-news-2-empty-face ((t (:foreground "CadetBlue4"))))
     (gnus-group-news-3-face ((t (:bold t))))
     (gnus-group-news-3-empty-face ((t (nil))))
     (gnus-group-news-low-face ((t (:foreground "DarkGreen" :bold t))))
     (gnus-group-news-low-empty-face ((t (:foreground "DarkGreen"))))
     (gnus-group-mail-1-face ((t (:foreground "DeepPink3" :bold t))))
     (gnus-group-mail-1-empty-face ((t (:foreground "DeepPink3"))))
     (gnus-group-mail-2-face ((t (:foreground "HotPink3" :bold t))))
     (gnus-group-mail-2-empty-face ((t (:foreground "HotPink3"))))
     (gnus-group-mail-3-face ((t (:foreground "magenta4" :bold t))))
     (gnus-group-mail-3-empty-face ((t (:foreground "magenta4"))))
     (gnus-group-mail-low-face ((t (:foreground "DeepPink4" :bold t))))
     (gnus-group-mail-low-empty-face ((t (:foreground "DeepPink4"))))
     (gnus-summary-selected-face ((t (:underline t))))
     (gnus-summary-cancelled-face ((t (:foreground "yellow" :background "black"))))
     (gnus-summary-high-ticked-face ((t (:foreground "firebrick" :bold t))))
     (gnus-summary-low-ticked-face ((t (:foreground "firebrick" :italic t))))
     (gnus-summary-normal-ticked-face ((t (:foreground "firebrick"))))
     (gnus-summary-high-ancient-face ((t (:foreground "RoyalBlue" :bold t))))
     (gnus-summary-low-ancient-face ((t (:foreground "RoyalBlue" :italic t))))
     (gnus-summary-normal-ancient-face ((t (:foreground "RoyalBlue"))))
     (gnus-summary-high-unread-face ((t (:bold t))))
     (gnus-summary-low-unread-face ((t (:italic t))))
     (gnus-summary-normal-unread-face ((t (nil))))
     (gnus-summary-high-read-face ((t (:foreground "DarkGreen" :bold t))))
     (gnus-summary-low-read-face ((t (:foreground "DarkGreen" :italic t))))
     (gnus-summary-normal-read-face ((t (:foreground "DarkGreen"))))
     (gnus-splash-face ((t (:foreground "ForestGreen"))))
     (gnus-emphasis-bold ((t (:bold t))))
     (gnus-emphasis-italic ((t (:italic t))))
     (gnus-emphasis-underline ((t (:underline t))))
     (gnus-emphasis-underline-bold ((t (:bold t :underline t))))
     (gnus-emphasis-underline-italic ((t (:italic t :underline t))))
     (gnus-emphasis-bold-italic ((t (:bold t :italic t))))
     (gnus-emphasis-underline-bold-italic ((t (:bold t :italic t :underline t))))
     (gnus-signature-face ((t (:foreground "white"))))
     (gnus-cite-face-1 ((t (:foreground "Khaki"))))
     (gnus-cite-face-2 ((t (:foreground "Coral"))))
     (gnus-cite-face-3 ((t (:foreground "#4186be"))))
     (gnus-cite-face-4 ((t (:foreground "yellow green"))))
     (gnus-cite-face-5 ((t (:foreground "IndianRed"))))


     (highlight-changes-face ((t (:foreground "red"))))
     (highlight-changes-delete-face ((t (:foreground "red" :underline t))))
     (show-paren-match-face ((t (:foreground "white" :background "purple"))))
     (show-paren-mismatch-face ((t (:foreground "white" :background "red"))))
     (cperl-nonoverridable-face ((t (:foreground "chartreuse3"))))
     (cperl-array-face ((t (:foreground "Blue" :bold t :background "lightyellow2"))))
     (cperl-hash-face ((t (:foreground "Red" :bold t :italic t :background "lightyellow2"))))
     (makefile-space-face ((t (:background "hotpink"))))
     (sgml-start-tag-face ((t (:foreground "mediumspringgreen"))))
     (sgml-ignored-face ((t (:foreground "gray20" :background "gray60"))))
     (sgml-doctype-face ((t (:foreground "orange"))))
     (sgml-sgml-face ((t (:foreground "yellow"))))
     (sgml-end-tag-face ((t (:foreground "greenyellow"))))
     (sgml-entity-face ((t (:foreground "gold"))))
     (flyspell-incorrect-face ((t (:foreground "OrangeRed" :bold t :underline t))))
     (flyspell-duplicate-face ((t (:foreground "Gold3" :bold t :underline t)))))))

(defun d-color-theme-gtk-ide ()
  "Color theme by Gordon Messmer, created 2001-02-07.
Inspired by a GTK IDE whose name I've forgotten.

If you want to modify the font as well, you should customize variable
`color-theme-legal-frame-parameters' to \"\\(color\\|mode\\|font\\|height\\|width\\)$\".
The default setting will prevent color themes from installing specific
fonts."
  ;; The light editor style doesn't seem to look right with
  ;; the same font that works in the dark editor style.
  ;; Dark letters on light background just isn't as visible.
  (interactive)
  (color-theme-install
   '(color-theme-gtk-ide
     ((font . "-monotype-courier new-medium-r-normal-*-*-120-*-*-m-*-iso8859-15")
      (width  . 95)
      (height . 45)
      (background-color . "white")
      (foreground-color . "black")
      (background-mode . light)
      (mouse-color . "grey15")
      (cursor-color . "grey15"))
     (default ((t nil)))
;------------------------------------------------------------
;;; individual

     (completions-first-difference ((t (:foreground "black" :bold t))))
;     (muse-link ((t (:underline "#ffffff")))); "0006ff")))) ;"#4d4d4d"))))
     (muse-link ((t (:underline  "#84aefd" :foreground "#6e92ff")))); "0006ff")))) ;"#4d4d4d"))))
     (muse-emphasis-1 ((t (:bold t :foreground "#6e92ff"))));"#4876ff"))))
     (muse-emphasis-2 ((t (:bold t :foreground "black"))))
     (muse-header-1 ((t (:underline "yellow" :inherit variable-pitch :foreground "black" :weight bold :height 1.4))))
;     (muse-header-1 ((t (:inherit variable-pitch :foreground "#d7b54e" :weight bold))))
     (muse-header-2 ((t (:underline "#6a6a6a" :weight bold :height 1.3 :family "helv" :foreground "black"))))
;     (muse-header-2 ((t (:foreground "#968759" :weight bold :family "helv"))))
;     (muse-header-2 ((t (:weight bold :height 1.3 :family "helv" :foreground "white"))))
     (muse-header-3 ((t (:weight bold :family "helv" :foreground "black"))))
     (muse-verbatim ((t	(:foreground "#7a7a7a")))); :background "#d0d0d0"))))
     (highlight-current-line-face ((t (:inverse-video t))))
     (widget-inactive ((t (:foreground "dim gray" :background "white"))))
     (dictionary-button-face ((t (:bold t :foreground "black"))))

; gnus-level-default-subscribed is 3
     (gnus-group-news-1 ((t (:foreground "red" :bold t))))
     (gnus-group-news-1-empty ((t (:foreground "red"))))
     (gnus-group-news-4 ((t (:foreground "#936649" :bold t))))
     (gnus-group-news-4-empty ((t (:foreground "#936649"))))
     (gnus-group-news-5 ((t (:foreground "#939393" :bold t))))
     (gnus-group-news-5-empty ((t (:foreground "#939393"))))
     (gnus-group-news-6 ((t (:foreground "#565656")))) ;6a6a6a
     (gnus-group-news-6-empty ((t (:foreground "#565656"))))

     (gnus-group-news-low ((t (:foreground "#464646" :strike-through t)))) ; for level 7
     (gnus-group-news-low-empty ((t (:foreground "#6a6a6a" :strike-through t))))

     (gnus-group-mail-1 ((t (:foreground "red" :bold t))))
     (gnus-group-mail-1-empty ((t (:foreground "red"))))
     (gnus-group-mail-2 ((t (:foreground "#657bff" :bold t))))
     (gnus-group-mail-2-empty ((t (:foreground "#657bff"))))
     (gnus-group-mail-3 ((t (:foreground "#5da765" :bold t))))
     (gnus-group-mail-3-empty ((t (:foreground "#5da765"))))
     (gnus-group-mail-4 ((t (:foreground "#936649" :bold t))))
     (gnus-group-mail-4-empty ((t (:foreground "#936649"))))

     (gnus-group-mail-low ((t (:foreground "#6a6a6a")))) ;for level 7
     (gnus-group-mail-low-empty ((t (:foreground "#6a6a6a"))))
     (tooltip ((t (:foreground "black" :background "#c0c0c0"))))

     (planner-cancelled-task-face ((t (:foreground "#6a6a6a" :strike-through "#464646"))))
     (planner-completed-task-face ((t (:foreground "#6a6a6a"))))

     (mmm-default-submode-face ((t (:background "white"))))
;------------------------------------------------------------



;;     (font-lock-comment-face ((t (:italic t :foreground "grey55"))))
     (font-lock-comment-face ((t (:foreground "Red"))))
     (font-lock-string-face ((t (:foreground "DarkRed"))))
     (font-lock-keyword-face ((t (:foreground "DarkBlue"))))
     (font-lock-warning-face ((t (:bold t :foreground "VioletRed"))))
     (font-lock-constant-face ((t (:foreground "OliveDrab"))))
     (font-lock-type-face ((t (:foreground "SteelBlue4"))))
     (font-lock-variable-name-face ((t (:foreground "DarkGoldenrod"))))
     (font-lock-function-name-face ((t (:foreground "SlateBlue"))))
     (font-lock-builtin-face ((t (:foreground "ForestGreen"))))
     (highline-face ((t (:background "grey95"))))
     (show-paren-match-face ((t (:background "grey80"))))
     (region ((t (:background "grey80"))))
     (highlight ((t (:background "LightSkyBlue"))))
     (secondary-selection ((t (:background "grey55"))))
     (widget-field-face ((t (:background "navy"))))
     (widget-single-line-field-face ((t (:background "royalblue")))))) )


;;; === Color-theme-standard
;;; --------------------------------------------------------------
(defun d-color-theme-standard ()
  "Emacs default colors.
If you are missing standard faces in this theme, please notify the maintainer."
  (interactive)
  ;; Note that some of the things that make up a color theme are
  ;; actually variable settings!
  (color-theme-install
   '(color-theme-standard
     ((foreground-color . "black")
      (background-color . "white")
      (mouse-color . "black")
      (cursor-color . "black")
      (border-color . "black")
      (background-mode . light))
     ((Man-overstrike-face . bold)
      (Man-underline-face . underline)
      (apropos-keybinding-face . underline)
      (apropos-label-face . italic)
      (apropos-match-face . secondary-selection)
      (apropos-property-face . bold-italic)
      (apropos-symbol-face . bold)
      (goto-address-mail-face . italic)
      (goto-address-mail-mouse-face . secondary-selection)
      (goto-address-url-face . bold)
      (goto-address-url-mouse-face . highlight)
      (help-highlight-face . underline)
      (list-matching-lines-face . bold)
      (view-highlight-face . highlight))


;------------------------------------------------------------
;;; individual

     (completions-first-difference ((t (:foreground "black" :bold t))))
;     (muse-link ((t (:underline "#ffffff")))); "0006ff")))) ;"#4d4d4d"))))
     (muse-link ((t (:underline  "#84aefd" :foreground "#6e92ff")))); "0006ff")))) ;"#4d4d4d"))))
     (muse-emphasis-1 ((t (:bold t :foreground "#6e92ff"))));"#4876ff"))))
     (muse-emphasis-2 ((t (:bold t :foreground "black"))))
     (muse-header-1 ((t (:underline "yellow" :inherit variable-pitch :foreground "black" :weight bold :height 1.4))))
;     (muse-header-1 ((t (:inherit variable-pitch :foreground "#d7b54e" :weight bold))))
     (muse-header-2 ((t (:underline "#6a6a6a" :weight bold :height 1.3 :family "helv" :foreground "black"))))
;     (muse-header-2 ((t (:foreground "#968759" :weight bold :family "helv"))))
;     (muse-header-2 ((t (:weight bold :height 1.3 :family "helv" :foreground "white"))))
     (muse-header-3 ((t (:weight bold :family "helv" :foreground "black"))))
     (muse-verbatim ((t	(:foreground "#7a7a7a")))); :background "#d0d0d0"))))
     (highlight-current-line-face ((t (:inverse-video t))))
     (widget-inactive ((t (:foreground "dim gray" :background "white"))))
     (dictionary-button-face ((t (:bold t :foreground "black"))))

; gnus-level-default-subscribed is 3
     (gnus-group-news-1 ((t (:foreground "red" :bold t))))
     (gnus-group-news-1-empty ((t (:foreground "red"))))
     (gnus-group-news-4 ((t (:foreground "#936649" :bold t))))
     (gnus-group-news-4-empty ((t (:foreground "#936649"))))
     (gnus-group-news-5 ((t (:foreground "#939393" :bold t))))
     (gnus-group-news-5-empty ((t (:foreground "#939393"))))
     (gnus-group-news-6 ((t (:foreground "#565656")))) ;6a6a6a
     (gnus-group-news-6-empty ((t (:foreground "#565656"))))

     (gnus-group-news-low ((t (:foreground "#464646" :strike-through t)))) ; for level 7
     (gnus-group-news-low-empty ((t (:foreground "#6a6a6a" :strike-through t))))

     (gnus-group-mail-1 ((t (:foreground "red" :bold t))))
     (gnus-group-mail-1-empty ((t (:foreground "red"))))
     (gnus-group-mail-2 ((t (:foreground "#657bff" :bold t))))
     (gnus-group-mail-2-empty ((t (:foreground "#657bff"))))
     (gnus-group-mail-3 ((t (:foreground "#5da765" :bold t))))
     (gnus-group-mail-3-empty ((t (:foreground "#5da765"))))
     (gnus-group-mail-4 ((t (:foreground "#936649" :bold t))))
     (gnus-group-mail-4-empty ((t (:foreground "#936649"))))

     (gnus-group-mail-low ((t (:foreground "#6a6a6a")))) ;for level 7
     (gnus-group-mail-low-empty ((t (:foreground "#6a6a6a"))))
     (tooltip ((t (:foreground "black" :background "#c0c0c0"))))

     (planner-cancelled-task-face ((t (:foreground "#6a6a6a" :strike-through "#464646"))))
     (planner-completed-task-face ((t (:foreground "#6a6a6a"))))

     (mmm-default-submode-face ((t (:background "white"))))
;------------------------------------------------------------



     (default ((t (nil))))
     (bold ((t (:bold t))))
     (bold-italic ((t (:bold t :italic t))))
     (calendar-today-face ((t (:underline t))))
     (cperl-array-face ((t (:foreground "Blue" :background "lightyellow2" :bold t))))
     (cperl-hash-face ((t (:foreground "Red" :background "lightyellow2" :bold t :italic t))))
     (cperl-nonoverridable-face ((t (:foreground "chartreuse3"))))
     (custom-button-face ((t (nil))))
     (custom-changed-face ((t (:foreground "white" :background "blue"))))
     (custom-documentation-face ((t (nil))))
     (custom-face-tag-face ((t (:underline t))))
     (custom-group-tag-face ((t (:foreground "blue" :underline t))))
     (custom-group-tag-face-1 ((t (:foreground "red" :underline t))))
     (custom-invalid-face ((t (:foreground "yellow" :background "red"))))
     (custom-modified-face ((t (:foreground "white" :background "blue"))))
     (custom-rogue-face ((t (:foreground "pink" :background "black"))))
     (custom-saved-face ((t (:underline t))))
     (custom-set-face ((t (:foreground "blue" :background "white"))))
     (custom-state-face ((t (:foreground "dark green"))))
     (custom-variable-button-face ((t (:bold t :underline t))))
     (custom-variable-tag-face ((t (:foreground "blue" :underline t))))
     (diary-face ((t (:foreground "red"))))
     (ediff-current-diff-face-A ((t (:foreground "firebrick" :background "pale green"))))
     (ediff-current-diff-face-Ancestor ((t (:foreground "Black" :background "VioletRed"))))
     (ediff-current-diff-face-B ((t (:foreground "DarkOrchid" :background "Yellow"))))
     (ediff-current-diff-face-C ((t (:foreground "Navy" :background "Pink"))))
     (ediff-even-diff-face-A ((t (:foreground "Black" :background "light grey"))))
     (ediff-even-diff-face-Ancestor ((t (:foreground "White" :background "Grey"))))
     (ediff-even-diff-face-B ((t (:foreground "White" :background "Grey"))))
     (ediff-even-diff-face-C ((t (:foreground "Black" :background "light grey"))))
     (ediff-fine-diff-face-A ((t (:foreground "Navy" :background "sky blue"))))
     (ediff-fine-diff-face-Ancestor ((t (:foreground "Black" :background "Green"))))
     (ediff-fine-diff-face-B ((t (:foreground "Black" :background "cyan"))))
     (ediff-fine-diff-face-C ((t (:foreground "Black" :background "Turquoise"))))
     (ediff-odd-diff-face-A ((t (:foreground "White" :background "Grey"))))
     (ediff-odd-diff-face-Ancestor ((t (:foreground "Black" :background "light grey"))))
     (ediff-odd-diff-face-B ((t (:foreground "Black" :background "light grey"))))
     (ediff-odd-diff-face-C ((t (:foreground "White" :background "Grey"))))
     (eshell-ls-archive-face ((t (:foreground "Orchid" :bold t))))
     (eshell-ls-backup-face ((t (:foreground "OrangeRed"))))
     (eshell-ls-clutter-face ((t (:foreground "OrangeRed" :bold t))))
     (eshell-ls-directory-face ((t (:foreground "Blue" :bold t))))
     (eshell-ls-executable-face ((t (:foreground "ForestGreen" :bold t))))
     (eshell-ls-missing-face ((t (:foreground "Red" :bold t))))
     (eshell-ls-product-face ((t (:foreground "OrangeRed"))))
     (eshell-ls-readonly-face ((t (:foreground "Brown"))))
     (eshell-ls-special-face ((t (:foreground "Magenta" :bold t))))
     (eshell-ls-symlink-face ((t (:foreground "DarkCyan" :bold t))))
     (eshell-ls-unreadable-face ((t (:foreground "Grey30"))))
     (eshell-prompt-face ((t (:foreground "Red" :bold t))))
     (eshell-test-failed-face ((t (:foreground "OrangeRed" :bold t))))
     (eshell-test-ok-face ((t (:foreground "Green" :bold t))))
     (excerpt ((t (:italic t))))
     (fixed ((t (:bold t))))
     (flyspell-duplicate-face ((t (:foreground "Gold3" :bold t :underline t))))
     (flyspell-incorrect-face ((t (:foreground "OrangeRed" :bold t :underline t))))
     (font-lock-builtin-face ((t (:foreground "Orchid"))))
     (font-lock-comment-face ((t (:foreground "Firebrick"))))
     (font-lock-constant-face ((t (:foreground "CadetBlue"))))
     (font-lock-function-name-face ((t (:foreground "Blue"))))
     (font-lock-keyword-face ((t (:foreground "Purple"))))
     (font-lock-string-face ((t (:foreground "RosyBrown"))))
     (font-lock-type-face ((t (:foreground "ForestGreen"))))
     (font-lock-variable-name-face ((t (:foreground "DarkGoldenrod"))))
     (font-lock-warning-face ((t (:foreground "Red" :bold t))))
     (fringe ((t (:background "grey95"))))
     (gnus-cite-attribution-face ((t (:italic t))))
     (gnus-cite-face-1 ((t (:foreground "MidnightBlue"))))
     (gnus-cite-face-10 ((t (:foreground "medium purple"))))
     (gnus-cite-face-11 ((t (:foreground "turquoise"))))
     (gnus-cite-face-2 ((t (:foreground "firebrick"))))
     (gnus-cite-face-3 ((t (:foreground "dark green"))))
     (gnus-cite-face-4 ((t (:foreground "OrangeRed"))))
     (gnus-cite-face-5 ((t (:foreground "dark khaki"))))
     (gnus-cite-face-6 ((t (:foreground "dark violet"))))
     (gnus-cite-face-7 ((t (:foreground "SteelBlue4"))))
     (gnus-cite-face-8 ((t (:foreground "magenta"))))
     (gnus-cite-face-9 ((t (:foreground "violet"))))
     (gnus-emphasis-bold ((t (:bold t))))
     (gnus-emphasis-bold-italic ((t (:bold t :italic t))))
     (gnus-emphasis-italic ((t (:italic t))))
     (gnus-emphasis-underline ((t (:underline t))))
     (gnus-emphasis-underline-bold ((t (:bold t :underline t))))
     (gnus-emphasis-underline-bold-italic ((t (:bold t :italic t :underline t))))
     (gnus-emphasis-underline-italic ((t (:italic t :underline t))))
     (gnus-group-mail-1-empty-face ((t (:foreground "DeepPink3"))))
     (gnus-group-mail-1-face ((t (:foreground "DeepPink3" :bold t))))
     (gnus-group-mail-2-empty-face ((t (:foreground "HotPink3"))))
     (gnus-group-mail-2-face ((t (:foreground "HotPink3" :bold t))))
     (gnus-group-mail-3-empty-face ((t (:foreground "magenta4"))))
     (gnus-group-mail-3-face ((t (:foreground "magenta4" :bold t))))
     (gnus-group-mail-low-empty-face ((t (:foreground "DeepPink4"))))
     (gnus-group-mail-low-face ((t (:foreground "DeepPink4" :bold t))))
     (gnus-group-news-1-empty-face ((t (:foreground "ForestGreen"))))
     (gnus-group-news-1-face ((t (:foreground "ForestGreen" :bold t))))
     (gnus-group-news-2-empty-face ((t (:foreground "CadetBlue4"))))
     (gnus-group-news-2-face ((t (:foreground "CadetBlue4" :bold t))))
     (gnus-group-news-3-empty-face ((t (nil))))
     (gnus-group-news-3-face ((t (:bold t))))
     (gnus-group-news-low-empty-face ((t (:foreground "DarkGreen"))))
     (gnus-group-news-low-face ((t (:foreground "DarkGreen" :bold t))))
     (gnus-header-content-face ((t (:foreground "indianred4" :italic t))))
     (gnus-header-from-face ((t (:foreground "red3"))))
     (gnus-header-name-face ((t (:foreground "maroon"))))
     (gnus-header-newsgroups-face ((t (:foreground "MidnightBlue" :italic t))))
     (gnus-header-subject-face ((t (:foreground "red4"))))
     (gnus-signature-face ((t (:italic t))))
     (gnus-splash-face ((t (:foreground "ForestGreen"))))
     (gnus-summary-cancelled-face ((t (:foreground "yellow" :background "black"))))
     (gnus-summary-high-ancient-face ((t (:foreground "RoyalBlue" :bold t))))
     (gnus-summary-high-read-face ((t (:foreground "DarkGreen" :bold t))))
     (gnus-summary-high-ticked-face ((t (:foreground "firebrick" :bold t))))
     (gnus-summary-high-unread-face ((t (:bold t))))
     (gnus-summary-low-ancient-face ((t (:foreground "RoyalBlue" :italic t))))
     (gnus-summary-low-read-face ((t (:foreground "DarkGreen" :italic t))))
     (gnus-summary-low-ticked-face ((t (:foreground "firebrick" :italic t))))
     (gnus-summary-low-unread-face ((t (:italic t))))
     (gnus-summary-normal-ancient-face ((t (:foreground "RoyalBlue"))))
     (gnus-summary-normal-read-face ((t (:foreground "DarkGreen"))))
     (gnus-summary-normal-ticked-face ((t (:foreground "firebrick"))))
     (gnus-summary-normal-unread-face ((t (nil))))
     (gnus-summary-selected-face ((t (:underline t))))
     (highlight ((t (:background "darkseagreen2"))))
     (highlight-changes-delete-face ((t (:foreground "red" :underline t))))
     (highlight-changes-face ((t (:foreground "red"))))
     (highline-face ((t (:background "paleturquoise"))))
     (holiday-face ((t (:background "pink"))))
     (info-menu-5 ((t (:underline t))))
     (info-node ((t (:bold t :italic t))))
     (info-xref ((t (:bold t))))
     (italic ((t (:italic t))))
     (makefile-space-face ((t (:background "hotpink"))))
     (message-cited-text-face ((t (:foreground "red"))))
     (message-header-cc-face ((t (:foreground "MidnightBlue"))))
     (message-header-name-face ((t (:foreground "cornflower blue"))))
     (message-header-newsgroups-face ((t (:foreground "blue4" :bold t :italic t))))
     (message-header-other-face ((t (:foreground "steel blue"))))
     (message-header-subject-face ((t (:foreground "navy blue" :bold t))))
     (message-header-to-face ((t (:foreground "MidnightBlue" :bold t))))
     (message-header-xheader-face ((t (:foreground "blue"))))
     (message-separator-face ((t (:foreground "brown"))))
     (modeline ((t (:foreground "white" :background "black"))))
     (modeline-buffer-id ((t (:foreground "white" :background "black"))))
     (modeline-mousable ((t (:foreground "white" :background "black"))))
     (modeline-mousable-minor-mode ((t (:foreground "white" :background "black"))))
     (region ((t (:background "gray"))))
     (secondary-selection ((t (:background "paleturquoise"))))
     (show-paren-match-face ((t (:background "turquoise"))))
     (show-paren-mismatch-face ((t (:foreground "white" :background "purple"))))
     (speedbar-button-face ((t (:foreground "green4"))))
     (speedbar-directory-face ((t (:foreground "blue4"))))
     (speedbar-file-face ((t (:foreground "cyan4"))))
     (speedbar-highlight-face ((t (:background "green"))))
     (speedbar-selected-face ((t (:foreground "red" :underline t))))
     (speedbar-tag-face ((t (:foreground "brown"))))
     (term-black ((t (:foreground "black"))))
     (term-blackbg ((t (:background "black"))))
     (term-blue ((t (:foreground "blue"))))
     (term-bluebg ((t (:background "blue"))))
     (term-bold ((t (:bold t))))
     (term-cyan ((t (:foreground "cyan"))))
     (term-cyanbg ((t (:background "cyan"))))
     (term-default-bg ((t (nil))))
     (term-default-bg-inv ((t (nil))))
     (term-default-fg ((t (nil))))
     (term-default-fg-inv ((t (nil))))
     (term-green ((t (:foreground "green"))))
     (term-greenbg ((t (:background "green"))))
     (term-invisible ((t (nil))))
     (term-invisible-inv ((t (nil))))
     (term-magenta ((t (:foreground "magenta"))))
     (term-magentabg ((t (:background "magenta"))))
     (term-red ((t (:foreground "red"))))
     (term-redbg ((t (:background "red"))))
     (term-underline ((t (:underline t))))
     (term-white ((t (:foreground "white"))))
     (term-whitebg ((t (:background "white"))))
     (term-yellow ((t (:foreground "yellow"))))
     (term-yellowbg ((t (:background "yellow"))))
     (underline ((t (:underline t))))
     (vcursor ((t (:foreground "blue" :background "cyan" :underline t))))
     (vhdl-font-lock-attribute-face ((t (:foreground "Orchid"))))
     (vhdl-font-lock-directive-face ((t (:foreground "CadetBlue"))))
     (vhdl-font-lock-enumvalue-face ((t (:foreground "Gold4"))))
     (vhdl-font-lock-function-face ((t (:foreground "Orchid4"))))
     (vhdl-font-lock-prompt-face ((t (:foreground "Red" :bold t))))
     (vhdl-font-lock-reserved-words-face ((t (:foreground "Orange" :bold t))))
     (vhdl-font-lock-translate-off-face ((t (:background "LightGray"))))
     (vhdl-speedbar-architecture-face ((t (:foreground "Blue"))))
     (vhdl-speedbar-architecture-selected-face ((t (:foreground "Blue" :underline t))))
     (vhdl-speedbar-configuration-face ((t (:foreground "DarkGoldenrod"))))
     (vhdl-speedbar-configuration-selected-face ((t (:foreground "DarkGoldenrod" :underline t))))
     (vhdl-speedbar-entity-face ((t (:foreground "ForestGreen"))))
     (vhdl-speedbar-entity-selected-face ((t (:foreground "ForestGreen" :underline t))))
     (vhdl-speedbar-instantiation-face ((t (:foreground "Brown"))))
     (vhdl-speedbar-instantiation-selected-face ((t (:foreground "Brown" :underline t))))
     (vhdl-speedbar-package-face ((t (:foreground "Grey50"))))
     (vhdl-speedbar-package-selected-face ((t (:foreground "Grey50" :underline t))))
     (viper-minibuffer-emacs-face ((t (:foreground "Black" :background "darkseagreen2"))))
     (viper-minibuffer-insert-face ((t (:foreground "Black" :background "pink"))))
     (viper-minibuffer-vi-face ((t (:foreground "DarkGreen" :background "grey"))))
     (viper-replace-overlay-face ((t (:foreground "Black" :background "darkseagreen2"))))
     (viper-search-face ((t (:foreground "Black" :background "khaki"))))
     (widget-button-face ((t (:bold t))))
     (widget-button-pressed-face ((t (:foreground "red"))))
     (widget-documentation-face ((t (:foreground "dark green"))))
     (widget-field-face ((t (:background "gray85"))))
     (widget-inactive-face ((t (:foreground "dim gray"))))
     (widget-single-line-field-face ((t (:background "gray85"))))))
  )

(defun d-color-theme-std ()
  "d-color-theme-standard has a problem with d-color-theme-hober.
To fix that I applied d-color-theme-standard-fix in
d-color-theme-standard and in defadvice. It didn't applied. This
function is a stuff to solve this problem"
  (interactive)
  (d-color-theme-standard)
  (d-color-theme-standard-fix)
  )

(defun d-color-theme-standard-fix ()
  ""
  (interactive)
  ;; It has a problem with headers. So manually configure.
  (set-face-attribute (intern "muse-header-1") nil
		      :underline "blue"
		      :inherit 'variable-pictch
		      :foreground "black"
		      :weight 'bold
		      :height 1.4
		      )

  (set-face-attribute (intern "muse-header-2") nil
		      :underline "6a6a6a"
		      :foreground "black"
		      :family "helv"
		      :height 1.3
		      )

  (set-face-attribute (intern "muse-header-3") nil
		      :foreground "black"
		      :family "helv"
		      )

  (set-face-attribute (intern "muse-emphasis-2") nil
		      :foreground "black"
		      :family "helv"
		      )
  )

;(d-color-theme-hober)
