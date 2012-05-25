
; See http://bc.tech.coop/blog/070306.html

(require 'auth)

(add-to-list 'load-path (concat d-dir-emacs "etc/g-client"))
(load-library "g")
(setq g-user-email d-variable-email)
(setq g-html-handler 'w3m-buffer)


;;; === Show current events
;;; --------------------------------------------------------------
;; I want to see current schedules of google calendar in emacs.
;; gcal-show-calendar do that. It, however, does not show tasks. It shows
;; all events of calendar because the parameters start-min and start-max
;; has null value. I want to show next events.


(defvar d-gcal-day-interval 10 "")

(defun d-gcal-show ()
  "I want to see current schedules of google calendar in emacs.
gcal-show-calendar do that. It, however, does not show tasks. It
shows all events of calendar because the parameters start-min and
start-max has null value. I want to show next events.
"
  (interactive)
  ;Fixme: We require the execution of gcal-show-calendar. It seems the
  ;problem gcal-show-calendar.
  (gcal-show-calendar)
  (gcal-show-calendar (gcal-private-feed-url)
		      (format-time-string gcal-event-time-format (d-gcal-add-time-format -1))
		      (format-time-string gcal-event-time-format (d-gcal-add-time-format d-gcal-day-interval))))

(defun d-gcal-add-time-format (num)
  "Unix time has the form (19616 64191 294562). first plus second
is seconds from 1/1/1970. Third is microseconds. 1day is 86400
seconds.
NUM is added to first.
"
  (let* ((ctime (current-time))
	 (dctime (car ctime))
	 (mctime (car (cdr ctime)))
	 (sctime (car (cdr (cdr ctime)))))
    (setq dctime (+ dctime num))
    (list dctime mctime sctime)))
