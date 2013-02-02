;;; d-alarm.el --- tools

;; Copyright (C) 2012  ptmono

;; Author: ptmono <ptmono@gmail.com>
;; Keywords: calendar, tools

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; from http://www.opensubscriber.com/message/help-gnu-emacs@gnu.org/4323621.html
;; or
;; simply use
;; M-x appt-activate
;; M-x appt-add
;; M-x appt-delete
;; or
;; use .diary file
;; or
;; use planner


;;; === Purpose
;;; --------------------------------------------------------------
;; - Add alarm
;; - record alarm with message
;; - alarm

;;; === How to save the alarm ?
;;; --------------------------------------------------------------
;; - We will use it for reporting on month or year.
;; 
;; - Let's use unix time format.
;; (format-time-string "%s" (current-time))
;; "1357692416"


;;; === Report
;;; --------------------------------------------------------------
;;; 1301091308
;; - Use d-alarm to alarm.


;;; === TODO
;;; --------------------------------------------------------------
;; - Report db


;;; Code:
;d-append-to-file, strip-text-properties
(require 'd-library)

(defvar d-alarm-clock-timer nil
  "Keep timer so that the user can cancel the d-alarm")

(defvar d-alarm/db-filename (concat d-home "/" "plans/alarmdb"))
(defvar d-alarm/music "/media/data/0-music/alarm.mp3")

(defun d-alarm-clock-message (title text)
  "The actual d-alarm action"
  (d-notify-desktop title text))

(defun d-alarm-clock ()
  "Set an d-alarm.
The time format is the same accepted by `run-at-time'.  For
example \"11:30am\"."
  (interactive)
  (let ((time (read-string "Time: "))
        (text (read-string "D-Alarm message: ")))
    (setq d-alarm-clock-timer (run-at-time time nil 'd-alarm-clock-message "Alarm" text))))

(defun d-alarm-clock-cancel ()
  "Cancel the d-alarm clock"
  (interactive)
  (cancel-timer d-alarm-clock-timer))


(defun d-alarm ()
  "TIME can be one of following form
 - 5 	: alarm after 5 hours
 - 5.5  : alarm after 5 hours 30 min
 - 120s : alarm after 120 seconds
 - 30m	: alarm after 30 min

TIME can be other formats. The function run-at-time support
 - diary-entry-time
 - timer-duration
 - encode-time
 - a number of second from now
To use the format run-at-time support, use prefix C-u.

music is non null string then start the music at the alarm time.
"
  (interactive)
  (let* ((time (read-string "Time: "))
	 (text (read-string "D-Alarm message: "))
	 (music (read-string "Musicp: ")))

    ;; TODO: merge prefix input
    (unless current-prefix-arg
      ;; time to second
      (setq time (d-alarm/input2time time t)))
    
    (setq d-alarm-clock-timer (run-at-time time nil 'd-alarm-clock-message "Alarm" text))
    (d-alarm/recordAlarm time text)
    (unless (equal music "")
      (d-alarm/atMusic time))
    ))


(defun d-alarm/atMusic (time)
  "Start music at TIME. TIME is the seconds from now"
  (let* ((time-miniute (round (/ time 60)))
	 (cmd (concat "echo 'cvlc " d-alarm/music "' | at now + " (number-to-string time-miniute) " minutes")))
    (start-process-shell-command "alarmAtMusic" nil cmd)))

(defun d-alarm/killMusic ()
  (interactive)
  (start-process-shell-command "alarmAtMusic" nil "pkill vlc"))


(defun d-alarm/recordAlarm (time text)
"Record the alarm. TIME is the seconds from now."
  (let* ((current-time (current-time))
	 (alarm-time (time-add current-time (seconds-to-time time)))
	 (current-time-unix (format-time-string "%s" current-time))
	 (alarm-time-unix (format-time-string "%s" alarm-time))
	 (output (concat current-time-unix "-" alarm-time-unix
			" " text "\n")))
    (d-append-to-file output d-alarm/db-filename)))
    

(defun d-alarm/visitDb ()
  (interactive)
  (find-file d-alarm/db-filename))


(defun d-alarm/input2time (time &optional second)
  "Return time. TIME will be
 - 5 	: alarm after 5 hours
 - 5.5  : alarm after 5 hours 30 min
 - 120s : alarm after 120 seconds
 - 30m	: alarm after 30 min
"
  (let* (rtime				;result time
	 rtimes				;("hours" "minite rate")
	 rtimes-hour
	 rtimes-min
	 rtimes-min-len
	 rtimes-min-rate-unit)

    (cond ((string-match "\\([0-9]+\\)s$" time)
	   ;; second
	   (setq rtime (string-to-number (match-string 1 time))))
	  ((string-match "\\([0-9]+\\)m$" time)
	   ;; minute
	   (setq rtime (string-to-number (match-string 1 time)))
	   (setq rtime (* rtime 60)))
	  (t
	   ;; hours
	   (setq rtimes (split-string time "\\."))
	   (setq rtimes-hour (string-to-number (car rtimes)))
	     
	   ;; Convert hour to second
	   (setq rtimes-hour (* rtimes-hour 60 60))
	   (if (car (cdr rtimes))
	       (progn
		 (setq rtimes-min (string-to-number (car (cdr rtimes))))
		 (setq rtimes-min-len (length (number-to-string rtimes-min)))
		 (setq rtimes-min-rate-unit (expt 0.1 rtimes-min-len)) ;0.1 0.01
		 (setq rtimes-min
		       (round (* 60 rtimes-min rtimes-min-rate-unit)))
		 ;; Convert min to second
		 (setq rtimes-min (* rtimes-min 60))
		 (setq rtime (+ rtimes-hour rtimes-min)))
	     (setq rtime rtimes-hour))))
    (if second
	rtime
      (seconds-to-time rtime))))
	   

(provide 'd-alarm)
;;; d-alarm.el ends here
