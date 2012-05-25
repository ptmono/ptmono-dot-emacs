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

;;; Code:
(defvar d-alarm-clock-timer nil
  "Keep timer so that the user can cancel the d-alarm")

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

(provide 'd-alarm)
;;; d-alarm.el ends here
