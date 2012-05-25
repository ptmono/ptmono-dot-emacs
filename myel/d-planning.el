; note worknote#0705241901
; worknote elispWorknote#0705261411


(require 'muse)
(require 'planner)
(require 'calendar)
;(require 'w3m)

(defvar d-planning-configuration nil)


(defun d-planning (&optional day)
  "Shows daypage, task lists and calendar. task list is from today to future.
If prefix, you can determine a scope of days."
  (interactive)
  (setq d-planning-configuration (current-frame-configuration))
  (calendar)
  (let ((from (planner-today))
	(to (d-planning-task-list-end-day)))
;;; prefix
    (when current-prefix-arg
      (setq from (planner-read-date "nil by default. Start"))
      (setq to (planner-read-date "nil by default. End")))
          
;;; create calendar and unfinished list
    (planner-list-tasks-with-status "[^XC\n]" (planner-get-day-pages from to t))
  ;;; build windows
    (delete-other-windows)
    (split-window-horizontally)
    (other-window 1)
    (split-window-vertically)
    (let* ((windows (window-tree))
	   (windows-1 (nth 2 (nth 0 (window-tree))))
	   (windows-2 (nth 2 (nth 3 (nth 0 (window-tree)))))
	   (windows-3 (nth 3 (nth 3 (nth 0 (window-tree))))))
      (select-window windows-1)
      (planner-goto (planner-today))
      (select-window windows-2)
      (switch-to-buffer "*Planner Tasks*")
; problem
;      (local-set-key [?\C-m] (lambda () (interactive) (d-follow-name-at-point-to-window-1)))
; I cannot change local key. why?
      (select-window windows-3)
      (switch-to-buffer calendar-buffer)
      (fit-window-to-buffer)
      (select-window windows-1))))
      

(defun d-planning-back ()
  "Back to the previous frame"
  (interactive)
  (set-frame-configuration d-planning-configuration))



(defun d-planning-task-list-end-day (&optional day)
  "The function returns the date of the last day page as
  \"2006.05.26\". If day is non-nil, the function use the
  function planner-expand-name with day where DAY is a number and
  returns the date such as \"2006.06.04\" when the number is \"9\"."
  (if day
      (planner-expand-name day)
    (car (car (planner-list-daily-files t)))))




(defun d-planning-list-unfinished-tasks (&optional pages)
  (let ((planner-expand-name-default "nil"))
    (planner-get-day-pages
     (planner-read-date "nil by default. Start")
     (planner-read-date "nil by default. End")
     t)
    (planner-list-tasks-with-status "[^XC\n]" pages)))


(defun d-follow-name-at-point-to-window-1 (&optional other-window)
  "Modified muse-follow-name-at-point for muse-planning."
  (let ((link (muse-link-at-point)))
    (other-window -1)
    (if link
	(muse-visit-link link other-window)
      (error "There is no valid link at point"))))
