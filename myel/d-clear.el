;; TODO: What is the purpose of this ?

(defvar d-date-previous nil)
(defvar d-time-tag-count 10)

(defun d-clear-getAnchorFromNote ()
  (interactive)
  (let* ((pinfo (planner-current-note-info))
	 (anchor (concat "#" (planner-note-anchor pinfo)))
	 (anchorp (d-worknote-get-anchor-from-string anchor)))

    (unless anchorp
      (setq anchor (d-clear-getAnchorFromPlannerNoteTimeInfo)))
    (kill-new anchor)
    (message anchor)))

(defun d-clear-getAnchorFromPlannerNoteTimeInfo ()
  ""
  (let* ((pinfo (planner-current-note-info))
	 (date-info (planner-note-date pinfo))
	 (time-info (planner-note-timestamp pinfo))
	 result)

    (unless (string= d-date-previous date-info)
      (setq d-date-previous date-info)
      (setq d-time-tag-count 10))

    (if time-info
	(setq result
	      (concat
	       ;; date
	       (substring date-info 2 4)
	       (substring date-info 5 7)
	       (substring date-info 8 10)
	       ;; time
	       (substring time-info 0 2)
	       (substring time-info 3 5)))
      (setq result
	    ;; date
	    (concat
	     (substring date-info 2 4)
	     (substring date-info 5 7)
	     (substring date-info 8 10)
	     ;; time
	     "12"
	     (number-to-string d-time-tag-count)))
      (setq d-time-tag-count (+ d-time-tag-count 1)))
    
    (setq result (concat "#" result))
    result))


(defun d-p-open-link ()
  ""
  (interactive)
  (let* ((pinfo (planner-current-note-info))
	 (title-info (planner-note-title pinfo))
	 (link-info (planner-note-link pinfo)))
    (muse-visit-link link-info t)))

(defun d-p-check-title ()
  ""
  (interactive)
  (let* ((pinfo (planner-current-note-info))
	 (title-info (planner-note-title pinfo))
	 (link-info (planner-note-link pinfo))
	 (result nil)
	 link-title-info)

    
    (if link-info
	(save-window-excursion
	  (muse-visit-link link-info nil)
	  (setq link-title-info (planner-note-title (planner-current-note-info))))
      (setq link-title-info nil))

    (if (string= title-info link-title-info)
	(setq result t)
      (setq result nil))
    (if result
	(message "Good")
      (message "Bad"))
    result))

(defun d-clear-replace-tocc ()
  (replace-string " **Todays note list**\n<notes>" "* Table Of Contents\n\n<contents>\n\n"))

(defun d-clear-replace-notec ()
  (replace-string "* Schedule\n\n<notes>" ""))

(defun d-clear-next-note ()
  (interactive)
  (re-search-forward d-planner-note-header-regexp nil t))

(defun d-clear-goto-title ()
  (interactive)
  (re-search-backward d-planner-note-header-regexp nil t))


(defun d-clear-do-check ()
  (interactive)
  (let* ((filename (dired-get-filename))
	 (problemp nil)
	 (while-condition t))
    (other-window 1)
    (find-file filename)
    
    (goto-char (point-min))
    (d-clear-replace-tocc)
    (goto-char (point-min))
    (d-clear-replace-notec)

    (while while-condition
      (setq while-condition (d-clear-next-note))

      (unless (d-p-check-title)
	(progn
	  (setq problemp t)
	  (setq while-condition nil))))
    (if problemp
	(message "We got problem here")
      (save-buffer)
      (kill-buffer)
      (other-window 1)
      (message "No problem"))))


(defun d-citation-interr ()
  (interactive)
  (let* ((note-info (planner-current-note-info)) ;If not note, note-info is nil
	 (anchor-info (planner-note-anchor note-info))
	 (title-info (planner-note-title note-info)))

    
    (other-window 1)
    (insert "[[#" anchor-info "][" title-info " #" anchor-info "]]")))

  

(defun d-clear-renew-note ()
  ""
  (interactive)
  (let* ((cite-num (d-time-tag))
	 (start-point-of-cite 3)
	 end-point-of-cite
	 contents
	 result)
    (save-excursion
      (save-restriction
	(when (planner-narrow-to-note)
	  (setq contents (buffer-substring (point-min) (point-max))))))

    (with-temp-buffer
      (insert contents)
      (goto-char (point-min))
      (setq end-point-of-cite (d-clear-next-note))
      (delete-region start-point-of-cite (- end-point-of-cite 1))
      (goto-char 3)
      (insert cite-num)
      (setq result (buffer-substring (point-min) (point-max))))

    (kill-new result)))
      

(defun d-clear-copy-note ()
  ""
  (interactive)
  (let* (contents)
    (save-excursion
      (save-restriction
	(when (planner-narrow-to-note)
	  (setq contents (buffer-substring (point-min) (point-max))))))
    (kill-new contents)
    (message "Done")))



(global-set-key [?\C-c ?n ?n] 'd-clear-getAnchorFromNote)
(global-set-key [?\C-c ?n ?c] 'd-p-check-title)
(global-set-key [?\C-c ?n ?o] 'd-p-open-link)
(global-set-key [?\C-c ?n ?e] 'd-clear-do-check)
(global-set-key [?\C-c ?n ?m] 'd-clear-renew-note)
(global-set-key [?\C-c ?n ?l] 'd-clear-copy-note)
(global-set-key [?\C-c ?n ?i] 'd-citation-interr)
(global-set-key [?\C-c ?n ?d] 'planner-delete-note)


(global-set-key [?\C-c ?d ?n] 'd-clear-next-note)
(global-set-key [?\C-c ?d ?p] 'd-clear-goto-title)

(defvar d-citation-inter-register ?Y)


(defun d-test ()
  ""
  (interactive)
  (let* (rbuffer
	 lbuffer)
    (setq rbuffer (buffer-name))
    (other-window 1)
    (setq lbuffer (buffer-name))
    (other-window 1)
    (if (eq rbuffer lbuffer)
	(point-to-register d-citation-inter-register)
      (jump-to-register d-citation-inter-register)))
  (message "Done"))



(defun d-test ()
  ""
  (interactive)
  (let* ((links-string (nth 6 (planner-current-task-info)))
	 (title (nth 4 (planner-current-task-info)))
	 (links (d-clear/linksToList links-string))
	 (result "")
	 str-line-point
	 title-filtered)

    
    (while links
      (setq link (car links))
      (setq links (cdr links))

      (find-file (d-clear/linkFileName link))
      (goto-char (point-min))

      (setq title-filtered (d-clear/clearTitle title))
      (setq str-line-point (re-search-forward title-filtered nil t))
      (if str-line-point
	  (progn
	    (goto-char str-line-point)
	    (if (y-or-n-p "Y or N: ")
		(progn
		  (d-clear/deleteCureentLine)
		  (setq result (concat result " " link))))
	    (basic-save-buffer)
	    (kill-buffer)
	    )))))


(defun d-clear/linksToList (str)
  (let* (result)
    (with-temp-buffer
      (insert str)
      (goto-char (point-min))
      (while (re-search-forward "\\[\\[\\([0-9.A-z]*\\)\\]\\]" nil t)
	(setq result (cons (match-string 1) result))))
    result))

(defun d-clear/linkFileName (str)
  (concat "~/plans/" str ".muse"))


(defun d-clear/deleteCureentLine ()
  (beginning-of-line 1)
  (kill-line)
  (kill-line))
  

(defun d-clear/muse-search ()
  ""
  (interactive)
  (let* ((str (nth 4 (planner-current-task-info)))
	 end)
    (setq str (d-clear/clearTitle str))
    (muse-grep str)))

(defun d-clear/clearTitle (str)
  (with-temp-buffer
    (insert str)
    (goto-char (point-min))
    (setq end (re-search-forward " : " nil t))
    
    (unless end
      (setq end (re-search-forward " {{" nil t)))
    
    (if end
	(setq str (buffer-substring (point-min) (match-beginning 0)))))
  str)
    
  


(global-set-key [?\C-c ?d ?m] 'd-clear/muse-search)
