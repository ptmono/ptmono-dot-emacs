;; TODO: Clear


;;; === For planner
;;; --------------------------------------------------------------
(require 'planner)
(require 'planner-publish)
(require 'planner-id)
(require 'planner-tasks-overview)
;; (require 'planner-deadline)
; (require 'planner-rank) ;for task rank [[pos:///home/ptmono/notes/0605212259.muse#12060][/home/ptmono/notes/0605212259.muse]]
;; (require 'planner-multi) ; for multi tasks
(require 'planner-trunk)
;; (require 'planner-bbdb)
(require 'planner-diary)
(require 'planner-gnus)
(require 'planner-notes-index) ; create a note index
;; (require 'planner-rss) ; publish your notes as an RSS feed
;; (require 'planner-schedule)
;(require 'planner-timeclock)

;; (unless (d-windowp)
;;   (require 'planner-w3m) ; make tasks based on W3M buffers
;;   )
(require 'planner-calendar)
(require 'planner-cyclic)
(require 'planner-erc)
(require 'planner-appt)

(require 'planner-lisp)
(require 'planner-zoom)
(require 'planner-registry)
(require 'planner-report)
(require 'planner-authz)


;;; === For planner-browser
;;; --------------------------------------------------------------
;; http://www003.upp.so-net.ne.jp/quasi/red/planner-browser/planner-browser-en.html

;(load "planner-browser")
;;; planner-browser needs emacs-wiki. But muse is used.


;;; === Variables
;;; --------------------------------------------------------------
(setq planner-use-day-pages nil) ; t is use day page, default t
(setq planner-use-plan-pages t) ; default t


;;; === Planner id
;;; --------------------------------------------------------------
(setq planner-id-add-task-id-flag nil) ; I don't like to automatically add the task id.


;;; === planner with diary
;;; --------------------------------------------------------------
;; planner에서 .diary file을 이용하기 위한 설정
;; 내용은 planner manual의 7.2.1 diary를 참조하기 바란다.

;(require 'planner-diary)
(add-hook 'diary-display-hook 'fancy-diary-display)

(setq planner-diary-use-diary t)
(planner-diary-insinuate)


(planner-calendar-insinuate)
(setq planner-calendar-show-planner-files nil)
;calendar에서 커서를 움직이면 day page를 자동으로 보여준다. calendar-move-hook에 추가하느 것이다.
;planner-calendar-show-planner-files 을 nil로 한다면 자동으로 보여주지 않는다.
;함수는 n(planner-calendar-goto), N(planner-calendar-show)을 정의 하고 있다. show는 day
;page가 없다면 보여주지 않는다.




;(load-library "planner-cyclic")

;for gnus
(planner-gnus-insinuate) ;hook planner-into gnus






;;;appointments
(planner-appt-use-tasks) ;for task based
;(planner-appt-use-schedule) ;for schedule based

;(planner-appt-use-tasks-and-schedule) ; to use both task-based appointments and schedule-based appointments

;for an overview of your appointments. choose section with 'M-x customize-variable' then set 'planner-appt-task-appointments-section'
;default is 'schedule'
;(setq planner-appt-task-use-appointments-section-flag t)

;(planner-appt-insinuate) ;automatically update 
(setq planner-appt-update-appts-on-save-flag t) ;page가 save될 때 자동 update


;(setq planner-appt-sort-schedule-on-update-flag t)
;(planner-appt-schedule-cyclic-insinuate)


;(setq planner-use-task-numbers t) ;for task numbering [[pos:///home/ptmono/notes/0605212259.muse#8269][/home/ptmono/notes/0605212259.muse]]

(setq planner-use-other-window nil) ; planner를 다른 윈도우에 띠우는 것이다. default t, i don't want to this

;(defcustom planner-day-page-template
;  "* Tasks\n\n\n* Schedule\n\n\n* Notes\n\n\n"
;  "Template to be inserted into blank daily pages.
;If this is a string, it will be inserted into the blank page.  If
;this is a function, it will be called with no arguments from a
;blank planner page and should insert the template.
;
;If you want to change the name of special sections like Tasks and Notes,
;update the `planner-sections' option as well."

(setq planner-day-page-template 
      " **Todays note list**\n<contens>\n\n\n\n* Diary\n\n\n\n* Tasks\n\n\n\n* Notes\n\n\n\n")
;      "* Tasks\n\n\n* Diary\n\n\<lisp\>(planner-diary-entries-here)\</lisp\>\n* Schedule\n\n<notes>\n* Notes\n\n\n")
;(setq planner-day-page-template "* Tasks\n\n\n* Schedule\n\n\n* Notes\n\n\n* Diary\n\n\n")

;(defcustom planner-plan-page-template "* Tasks\n\n\n* Notes\n\n\n"
;  "Template to be inserted into blank plan pages.
;If this is a string, it will be inserted into the blank page.  If
;this is a function, it will be called with no arguments from a
;blank planner page and should insert the template.
;
;If you want to change the name of special sections like Tasks and Notes,
;update the `planner-sections' option as well."

(setq planner-plan-page-template "* Introduction\n")
;(setq planner-plan-page-template " **list of note**\n<contents>\n\n\n\n* Tasks\n\n\n\n* Notes\n\n\n\n")
;(setq planner-plan-page-template "* Related Links\n\n**resources**\n\n**interlinks**\n\n\n* Tasks\n\n\n* Notes\n\n\n")

;(planner-appt-use-tasks) ; to use the task-based appointments


;;; === For add-hook
;;; --------------------------------------------------------------
(add-hook 'planner-mode-hook 'planner-trunk-tasks)



;(plan) ;
;(planner-update-wiki-project) : this will be removed


(defadvice planner-create-note-from-task (after d-planner-create-note-from-task)
  ""
  (insert "\n\n")
  (forward-line -2))
(ad-activate 'planner-create-note-from-task)


;to make overview page
(defun d-planner-make-task-note-list-page ()
  "make task and note page.The function make fillowing
files into plans directory

 - list_of_unfinished_tasks_on_allpages.muse
 - list_of_unfinished_tasks_on_daypage.muse
 - list_of_finished_tasks_on_daypage.muse
 - list_of_delegate_tasks_on_daypage.muse

The files contains the list of tasks"
  (interactive)
  (d-planner-make-list-task-pages)
  (d-planner-make-list-note-page))

(defun d-planner-make-list-task-pages ()
  "planner-list-tasks-with-status function provides the list of tasks with
status. This function use \"*Planner Tasks*\" buffer"
					;call planner-list-tasks-with-status delegate tasks on day
					;(planner-list-tasks-with-status "D" nil)
  (d-planner-make-list-task-page "D" nil "list_of_delegate_tasks_on_daypage.muse")

					;call planner-list-tasks-with-status finished tasks on day
					;(planner-list-tasks-with-status "X" nil)
  (d-planner-make-list-task-page "X" nil "list_of_finished_tasks_on_daypage.muse")

					;call planner-list-tasks-with-status unfinished tasks on day
					;(planner-list-tasks-with-status "[^XC]" nil)
  (d-planner-make-list-task-page "[^XC]" nil "list_of_unfinished_tasks_on_daypage.muse")

					;call planner-list-tasks-with-status unfinished tasks on all page
					;(planner-list-tasks-with-status "[^XC]" t)
  (d-planner-make-list-task-page "[^XC]" t "list_of_unfinished_tasks_on_allpages.muse")
  (progn
    (planner-tasks-overview-show-summary)
    (switch-to-buffer "*planner tasks overview*")
    (write-file "/home/ptmono/plans/tasks_overview.muse" nil)
    (kill-buffer "tasks_overview.muse")))

(defun d-planner-make-list-task-page (status page filename)
  "save task list to filename. STATUS is task status such as \"X\" for finished tasks,
\"[^XC]\" for unfinished tasks. about PAGE see planner-list-tasks-with-status"
  (planner-list-tasks-with-status status page)
  (switch-to-buffer "*Planner Tasks*")
  (goto-char (point-min))
  (while (not (eq (point) (point-max)))
    (insert " - ")    
    (end-of-line)
    (newline)
    (forward-line 1))
  (write-file (concat "/home/ptmono/plans/" filename) nil)
  (kill-buffer filename))

(defun d-planner-make-list-note-page ()
  "planner provides the function 'planner-notes-index to create
the index of notes. This function use \"*Notes Index*\" buffer"
  (planner-notes-index)
  (switch-to-buffer "*Notes Index*")
  (write-file "/home/ptmono/plans/listofnotes.muse" nil)
  (kill-buffer "listofnotes.muse"))



;------------------------------------------------------------
;; planner-create-note, planner-replan-note
;
; planner-create-note는 note number를 페이지에 note 가 몇개 있는지를 확인해서 그
; 갯수에 1을 더하는 방식이다. 이 방식은 문제가 있다. 만약 note 중 하나를 삭제했을
; 경우 가장 상위의 번호는 중복이 될 것이다. 2개의 노트를 삭제하면 2개의 note
; number가 중복이 된다.
; 
; 이를 해결하기 위해 이 번호에 '0704110126'(d-insert-time)을 부여하기로 한다.
;
; planner에서 다른 함수에서도 planner-create-note를 쓰므로 직접
; planner-create-note를 고쳐서 사용하도록 하자. 
;
;
; 0704110132 modified
;
; 0704171630 planner-replan-note was modified.
;
; 0705040204 planner-replan-note시에 '0705040205'과 같은 anchor가 아닌 '8'과 같은
; anchor를 day page에 내어 놓았다. 이를 day page, plan page 모두에
; '#0705040205'와 같은 anchor를 사용하도록 하였다.


(defvar d-planner-note-header-regexp "^\\.#[0-9]+\\s-+")

(defun planner-create-note (&optional page)
  "Create a note to be remembered in PAGE (today if PAGE is nil).
If `planner-reverse-chronological-notes' is non-nil, create the
note at the beginning of the notes section; otherwise, add it to
the end.  Position point after the anchor."
  (interactive (list (and (planner-derived-mode-p 'planner-mode)
                          (planner-page-name))))
  (planner-goto (or page
                    (and (planner-derived-mode-p 'planner-mode)
                         (planner-page-name))
                    (planner-today)))
  (planner-seek-to-first 'notes)
  (save-restriction
    (when (planner-narrow-to-section 'notes)
      (let ((total 0)
	    (num (d-current-time)))
        (goto-char (point-min))
        (while (re-search-forward d-planner-note-header-regexp nil t)
          (setq total (1+ total)))
        (if planner-reverse-chronological-notes
            (progn (goto-char (point-min))
                   (forward-line 1)
                   (skip-chars-forward "\n"))
          (goto-char (point-max))
          (skip-chars-backward "\n")
          (when (= (forward-line 1) 1) (insert "\n"))
          (when (= (forward-line 1) 1) (insert "\n")))
; here is modified
;        (insert ".#" (number-to-string (1+ total)) " ")
	(insert ".#" num " ")
;
	(unless (eobp) (save-excursion (insert "\n\n")))
;        (1+ total)))))
	num))))


;(defun d-planner-worknote-p ()
;  "If current buffer name is d-worknote-name-with-extension, then t"
;  (equal (buffer-name) d-worknote-name-with-extension))


(defun planner-replan-note (page)
  "Change or assign the plan page for the current note.
PAGE-NAME is the new plan page for the note."
  (interactive
   (list (planner-read-non-date-page
          (planner-file-alist) nil
          (planner-note-link-text (planner-current-note-info)))))
  (let ((info (planner-current-note-info t)))
    (when (and page
               (or (string= page (planner-note-plan info))
                   (string= page (planner-note-date info))))
      (error "Same plan page"))
    (when (null (or page (planner-note-date info)))
      (error "Cannot unplan note without day page"))
    (save-window-excursion
      ;; Delete the old plan note
      (when (planner-note-plan info)
        (when (string-match planner-date-regexp (planner-note-page info))
          (planner-jump-to-linked-note info))
        (save-restriction
          (planner-narrow-to-note)
          (delete-region (point-min) (point-max))))
      (let (new)
        (when page
          ;; Create note on plan page
          (setq new (planner-create-note page))
          (insert (planner-format-note
                   info "" nil nil
                   (if (planner-note-date info)
                         (planner-make-link
                          (concat (planner-note-date info)
                                  "#"
                                  (planner-note-anchor info)))
                     ""))))
        ;; Update note on date page, if any
        (forward-line -1)
        (when (planner-note-date info)
            (if (string-match planner-date-regexp (planner-note-page info))
                (progn
                  (planner-find-file (planner-note-date info))
                  (goto-char (point-min))
                  (re-search-forward (concat "^\\.#" (planner-note-anchor info)
                                             "\\s-")
                                     nil t))
              (planner-jump-to-linked-note info))
            (save-restriction
              (planner-narrow-to-note)
              (delete-region (point-min) (point-max))
              (insert (planner-format-note
                       info nil nil nil
                       (if new
                           (planner-make-link
                            (concat (planner-link-base page) "#"
;                                    (number-to-string new)))
				    new))
                         "")))))))))

  




; planner-replan-note 는 다시 planner-multi 에서 re define 되었다.



(defadvice planner-replan-note (around planner-multi activate)
  "Allow multiple pages."
  (if (string-match (regexp-quote planner-multi-separator) page)
      (save-window-excursion
        (save-restriction
          (let* ((info (planner-current-note-info))
                 (links (planner-multi-note-link-as-list info))
                 (new-links (planner-multi-split page))
		 (old-anchor (planner-make-link
			      (concat (planner-note-page info) "#"
				      (planner-note-anchor info))))
		 cursor
                 current-page
                 (old-pages (mapcar 'planner-link-base links)))
	    (when (and (not old-pages)
		       (string-match planner-date-regexp (planner-note-page info)))
	      (setq old-pages (list (planner-note-page info)))
              (add-to-list 'new-links old-anchor))
            ;; Add to new pages
	    (setq cursor new-links)
            (while cursor
              (setq current-page (planner-link-base (car cursor)))
              (when (not (member current-page old-pages))
                (setcar cursor
                        (planner-make-link
; dal here is modified
			 (format "%s#%s"
;                         (format "%s#%d"
                                 (planner-link-base (car cursor))
; added this line
				 (progn
				   (planner-create-note current-page)
				   (planner-note-anchor info))))))
	      (setq cursor (cdr cursor)))
            ;; Delete from pages removed from list
            (setq cursor links)
            (while cursor
              (unless (member (planner-link-base (car cursor)) old-pages)
                (planner-visit-link (planner-link-target (car links)))
                (save-restriction
                  (when (planner-narrow-to-note)
                    (delete-region (point-min) (point-max)))))
              (setq cursor (cdr cursor)))
            ;; Update the current note
            (planner-visit-link (concat (planner-note-page info)
                                        "#" (planner-note-anchor info)))
            (delete-region (1+ (point)) (planner-line-end-position))
            (insert " " (planner-format-note info "" nil nil (planner-make-link
                                                              new-links)))
            (planner-update-note))))
    ad-do-it))



(defun planner-create-note-from-task (&optional plan-page-p)
  "Create a note based on the current task.
Argument PLAN-PAGE-P is used to determine whether we put the new
note on the task's plan page or on the current page."
  (interactive "P")
  (let ((task-info (planner-current-task-info))
         note-num)
    (when task-info
      ;; If PLAN-PAGE-P and the task has a plan page, create a note on
      ;; the plan page. If not, create it on the current page.
      (when (and plan-page-p
                 (string= (planner-task-date task-info)
                          (planner-task-page task-info)))
        (planner-jump-to-linked-task task-info))
      (setq note-num (planner-create-note (planner-page-name)))
      (save-excursion
        (save-window-excursion
          (when (planner-find-task task-info)
            (planner-edit-task-description
             (concat (planner-task-description task-info) " "
                     (planner-make-link
                      (concat (planner-page-name) "#"
;; '0705060033'를 넣는 도중 error가 발생되었다. 원은 string에 number-to-string function 이 적용되어서 였다.
;                              (number-to-string note-num))
			      note-num)
;                      (format "(%d)" note-num)))))))
		      note-num))))))
      (insert " " (planner-task-description task-info) "\n\n"))))



(defun d-planner-worknote-name-p (info)
  "planner-note-plan returns plan name of
  planner-current-note-info. The function compares plan page name
  and d-worknote-name"
  (string-match (concat "\\[\\[" d-worknote-name "#") (planner-note-link info)))



(defun d-planner-create-tag (page)
  "The function tags between plan page"
  (interactive
   (list (planner-read-non-date-page
          (planner-file-alist) nil
          (planner-note-link-text (planner-current-note-info)))))
  (let ((info (planner-current-note-info))
	date)
    (save-window-excursion
      (planner-create-note page)
      (insert "to update")
      (setq date (planner-note-anchor (planner-current-note-info))))
    (save-excursion
      (save-restriction
	(planner-narrow-to-note)
	(goto-char (point-min))
	(end-of-line)
	(insert (concat " \([[" page "#" date "]]\)")))))
  (planner-update-note)
  (save-window-excursion
    (planner-goto-plan-page page)
    (planner-save-buffers)))


(defun d-planner-replan-note-done (page)
  "The function tags between plan page, and done the title."
  (interactive
   (list (planner-read-non-date-page
          (planner-file-alist) nil
          (planner-note-link-text (planner-current-note-info)))))
  (d-worknote-note-done)
  (d-planner-create-tag page))

(provide 'planner-config)

