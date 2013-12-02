(autoload 'epresent-run "epresent")

(add-hook 'org-mode-hook
        (function
         (lambda ()
           (setq truncate-lines nil)
           (setq word-wrap t)
           (define-key org-mode-map [f3]
             'epresent-run)
           )))

Sans-bold-normal-normal-*-82-*-*-*-*-0-iso10646-1
xft:-unknown-WenQuanYi Zen Hei-normal-normal-normal-*-47-*-*-*-*-0-iso10646-1
xft:-unknown-DejaVu Sans-bold-normal-normal-*-82-*-*-*-*-0-iso10646-1 (#x33)

(defface epresent-content-face
  '((t :weight bold :height 1.8 :underline t :inherit variable-pitch))
  "")


(defface epresent-fixed-face
  '((t :weight bold :height 1.8 :underline t :inherit variable-pitch))
  "")


(defun epresent-fontify ()
  "Overlay additional presentation faces to Org-mode."
  (save-excursion
    ;; hide all comments
    (goto-char (point-min))
    ;; xxx could we just temporarily modify the Org-mode face for comments
    (while (re-search-forward
            "^\\(#\\|[ \t]*#\\+\\).*\n"
            nil t)
      (let ((comment (match-string 0))
	    (cb (match-beginning 0))
	    (ce (match-end 0)))
	(unless (save-match-data 
		  ;; (regexp-opt '("title" "author" "date"))
		  (string-match 
		   "^#\\+\\(author\\|title\\|date\\):"
		   comment))
	  (epresent-push-new-overlay cb ce 'invisible 'epresent-hide))))

    ;; page title faces
    (goto-char (point-min))
    (while (re-search-forward "^.*$" nil t)
      (push (make-overlay (match-beginning 0) (match-end 0)) epresent-overlays)
      (overlay-put (car epresent-overlays) 'face 'epresent-heading-face))
    (goto-char (point-min))

    ;; page title faces
    (goto-char (point-min))
    (while (re-search-forward "^\\(*+\\)[ \t]*\\(.*\\)$" nil t)
      (push (make-overlay (match-beginning 1) (match-end 1)) epresent-overlays)
      (overlay-put (car epresent-overlays) 'invisible 'epresent-hide)
      (push (make-overlay (match-beginning 2) (match-end 2)) epresent-overlays)
      (if (> (length (match-string 1)) 1)
          (overlay-put (car epresent-overlays) 'face 'epresent-subheading-face)
        (overlay-put (car epresent-overlays) 'face 'epresent-heading-face)))
    (goto-char (point-min))
    ;; fancy bullet points
    (while (re-search-forward "^[ \t]*\\(-\\) " nil t)
      (push (make-overlay (match-beginning 1) (match-end 1)) epresent-overlays)
      (overlay-put (car epresent-overlays) 'invisible 'epresent-hide)
      (overlay-put (car epresent-overlays)
                   'before-string (propertize "•" 'face 'epresent-bullet-face)))
    ;; hide todos
    (when epresent-hide-todos
      (goto-char (point-min))
      (while (re-search-forward org-todo-regexp nil t) 
        (push (make-overlay (match-beginning 1) (1+ (match-end 1)))
              epresent-overlays)
        (overlay-put (car epresent-overlays) 'invisible 'epresent-hide)))
    ;; hide tags
    (when epresent-hide-tags
      (goto-char (point-min))
      (while (re-search-forward 
              (org-re "^\\*+.*?\\([ \t]+:[[:alnum:]_@#%:]+:\\)[ \r\n]") 
              nil t)
        (push (make-overlay (match-beginning 1) (match-end 1)) epresent-overlays)
        (overlay-put (car epresent-overlays) 'invisible 'epresent-hide)))
    ;; hide properties
    (when epresent-hide-properties
      (goto-char (point-min))
      (while (re-search-forward org-drawer-regexp nil t)
        (let ((beg (match-beginning 0))
              (end (re-search-forward
                    "^[ \t]*:END:[ \r\n]*"
                    (save-excursion (outline-next-heading) (point)) t)))
          (push (make-overlay beg end) epresent-overlays)
          (overlay-put (car epresent-overlays) 'invisible 'epresent-hide))))
    (dolist (el '("title" "author" "date"))
      (goto-char (point-min))
      (when (re-search-forward (format "^\\(#\\+%s:\\)[ \t]*\\(.*\\)$" el) nil t)
        (push (make-overlay (match-beginning 1) (match-end 1)) epresent-overlays)
        (overlay-put (car epresent-overlays) 'invisible 'epresent-hide)
        (push (make-overlay (match-beginning 2) (match-end 2)) epresent-overlays)
        (overlay-put
         (car epresent-overlays) 'face (intern (format "epresent-%s-face" el)))))
    ;; inline images
    (unless org-inline-image-overlays
      (org-display-inline-images))))
