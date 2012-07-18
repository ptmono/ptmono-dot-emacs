(require 'd-worknote2)


(defvar d-report/type-alist
  '(("" d-worknote-create-tag)
    ("todo" d-report-todo)
    ("report" d-report-report)
    )
  "")

(defun d-report()
  (interactive)
  (let* ((key (completing-read "Choose : " d-report/type-alist))
	 (value (car (cdr (assoc key d-report/type-alist)))))
    (if (stringp value)
	(insert value)
      (funcall value))))

(defun d-report-
