;; See worknote 0703301543


(appt-activate 1)

(defcustom d-appt-disp-window-p t
  "If non-'nil' d-appt-disp-window excutes
  d-appt-disp-window-program"
  :type 'boolean
  :group 'appt)


(defcustom d-appt-disp-window-program "/home/ptmono/myscript/hit_the"
  "d-appt-disp-window excutes this program or command as
  asynchronously when d-appt-disp-window-p is non-'nil"
  :type 'string
  :group 'appt)


(defun d-appt-disp-window (min-to-app new-time appt-msg)
  "Display appointment message APPT-MSG in a separate buffer.
The appointment is due in MIN-TO-APP (a string) minutes.
NEW-TIME is a string giving the date."
  (require 'electric)

  ;; Make sure we're not in the minibuffer
  ;; before splitting the window.

  (if (equal (selected-window) (minibuffer-window))
      (if (other-window 1)
	  (select-window (other-window 1))
	(if (display-multi-frame-p)
	    (select-frame (other-frame 1)))))

  (let ((this-window (selected-window))
        (appt-disp-buf (set-buffer (get-buffer-create appt-buffer-name))))

    (if (cdr (assq 'unsplittable (frame-parameters)))
	;; In an unsplittable frame, use something somewhere else.
	(display-buffer appt-disp-buf)
      (unless (or (special-display-p (buffer-name appt-disp-buf))
		  (same-window-p (buffer-name appt-disp-buf)))
	;; By default, split the bottom window and use the lower part.
	(appt-select-lowest-window)
        (select-window (split-window)))
      (switch-to-buffer appt-disp-buf))
    (calendar-set-mode-line
     (format " Appointment in %s minutes. %s " min-to-app new-time))
    (erase-buffer)
    (insert appt-msg)
    (shrink-window-if-larger-than-buffer (get-buffer-window appt-disp-buf t))
    (set-buffer-modified-p nil)
    (raise-frame (selected-frame))
    (select-window this-window))
  ;; Execute the program in last notification
  (if (< min-to-app appt-display-interval)
      (when d-appt-disp-window-p
	(start-process "appt-audiable" "*Asynchronous Process*" d-appt-disp-window-program))))
