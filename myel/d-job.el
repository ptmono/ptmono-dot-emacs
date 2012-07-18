;;; === Job present
;;; --------------------------------------------------------------

;;; Get hash table
(defvar d-job/info-regexp "^==> ")

(defvar d-job/muse-file "~/plans/jobInfo.muse")

(defun d-job-show ()
  (interactive)
  ;; Set hash table
  (with-temp-buffer
    (insert-file-contents d-job/muse-file)
    (d-job/setHashTable))

  (d-job-deadline/setHashTable)
  (if current-prefix-arg
      (d-job/createBuffer nil)
    (d-job/createBuffer t)))



(defun d-job/createBuffer (&optional all)
  "If all it reports all passed works."
  (d-window-separate)
  (other-window 1)
  (switch-to-buffer "*job-list*")
  (erase-buffer)
  (let* ((sortedDeadlines (if all
			      (d-job-deadline/sortedDeadlines)
			    (d-job-deadline/sortedDeadlinesWithoutExpired)))
	 anchors
	 title
	 priority
	 content)

    ;; Do for deadlines
    (dolist (deadline sortedDeadlines)
      (d-job/insertSectionTitle deadline)
      (setq anchors (gethash deadline d-job-deadline/hashTable))

      ;; Do for anchors of deadlines
      (dolist (anchor anchors)
	(setq title (d-job-hash/getTitle anchor))
	(setq priority (d-job-hash/getPriority anchor))
	(setq content (d-job-hash/getContent anchor))
	(insert
	 (concat " - [[" d-job/muse-file anchor "][" title "]]" " "
		 priority " " content "\n")))
      (insert "\n\n")))
  (muse-mode))


(defun d-job/insertSectionTitle (deadline)
  (let* ((week))
    (setq week
	  (if (equal deadline "0")
	      nil
	    (d-worknote-tag-get-dayname (d-job-libs/deadline2Date deadline))))

    (if week
	(progn
	  (setq remain (d-job-libs/remainDays (d-job-libs/deadline2Date deadline)))
	  (insert (concat "* " deadline "(" week ") -- " 
			  (number-to-string remain) "days\n\n")))
      (insert (concat "* " deadline "\n\n")))
    ))

(defun d-job-libs/deadline2Date (deadline)
  (let* (year
	 month
	 day)
    (setq year (string-to-number (substring deadline 0 2)))
    (setq month (string-to-number (substring deadline 2 4)))
    (setq day (string-to-number (substring deadline 4 6)))

    (list month day year)))

(defun d-job-libs/remainDays (date)
  "How many remains the days from today."
  (let* ((today (calendar-current-date)))
    (- (calendar-day-number date)
       (calendar-day-number today))))


(defun d-job/parse (input)
  (let* (result)
    ;; (deadline priority conent)
    (if (string-match "\\([0-9]+\\), \\([0-9]\\), \\(.*\\)" input)
	(setq result (list (match-string 1 input) ;deadline
			   (match-string 2 input) ;priority
			   (match-string 3 input) ;content
			   )))
    (if (string-match "\\([0-9]\\)$" input)
	(setq result (list "0" "0" "")))
    result))




;;; === Overview of Sorting
;;; --------------------------------------------------------------
;; Our informain is
;; - anchor         e.g) 1206121556
;; - deadline       e.g) 120612

;; Our purpose is to sort anchors by deadline where the anchor is unique
;; number and deadline is not.

;; Each job info is stored into d-job/hashTable. It has the form
;; ((anchor1 (anchor1 title1 deadline1 priority1 content1)) ...)

;; To sort it for deadline we use d-job-deadline/hashTable. It has the
;; form
;; ((deadline (anchor1 anchor2 ...)) (deadline2 (anchor5 anchor5 ...)) ...)
;; The function d-job-deadline/setHashTable will create the table. It
;; requires d-job/hashTable.

;; We will sort the deadlines and get the anchors to be sorted.


;; ((anchor1 (anchor1 title1 deadline1 priority1 content1)) ...)
(defvar d-job/hashTable (make-hash-table :test 'equal))

(defun d-job/setHashTable ()
  (clrhash d-job/hashTable)
  (save-excursion
    (let* (input
	   anchor
	   title
	   value)
      (goto-char (point-min))
      (while (re-search-forward d-job/info-regexp nil t)
	(setq input (thing-at-point 'line))
	(setq anchor (d-worknote-section/getAnchor))
	(setq title (d-worknote-section/getTitle))
	(setq value (cons title (d-job/parse input)))
	(setq value (cons anchor value))
	;; (anchor (anchor title deadline priority content ))
	(puthash anchor value d-job/hashTable)
	))))

(defun d-job-hash/getCommon (anchor n)
  (let* ((values (gethash anchor d-job/hashTable)))
    (nth n values)))

(defun d-job-hash/getAnchor (anchor)
  (d-job-hash/getCommon anchor 0)
)

(defun d-job-hash/getTitle (anchor)
  (d-job-hash/getCommon anchor 1)
)

(defun d-job-hash/getDeadline (anchor)
  (d-job-hash/getCommon anchor 2)
)

(defun d-job-hash/getPriority (anchor)
  (d-job-hash/getCommon anchor 3)
)

(defun d-job-hash/getContent (anchor)
  (d-job-hash/getCommon anchor 4)
)

;; ((deadline deadline-hash-value) (deadline2 deadline-hash-value2) ...)
;; ((deadline (anchor1 anchor2 ...)) (deadline2 (anchor5 anchor5 ...)) ...)
;; To sort anchors for deadline we use d-job-deadline/hashTable
(defvar d-job-deadline/hashTable (make-hash-table :test 'equal))

(defun d-job-deadline/setHashTable ()
  (clrhash d-job-deadline/hashTable)
  (let* (deadline
	 deadline-hash-value)
    (maphash (lambda (anchor value)
	       (setq deadline (d-job-hash/getDeadline anchor))
	       ;; Get deadline-hash-value
	       (setq deadline-hash-value (gethash deadline d-job-deadline/hashTable))
	       (if deadline-hash-value
		   (progn
		     (setq deadline-hash-value (cons anchor deadline-hash-value))
		     (remhash deadline d-job-deadline/hashTable)
		     (puthash deadline deadline-hash-value d-job-deadline/hashTable))
		 ;; There is no deadline in hash table
		 (setq deadline-hash-value (cons anchor nil))
		 (puthash deadline deadline-hash-value d-job-deadline/hashTable)))
	     d-job/hashTable)))


(defun d-job-deadline/sortedDeadlines ()
  (let* (result
	 result-pre)
    (maphash (lambda (deadline calue)
	       (setq result (cons (string-to-number deadline) result)))
	     d-job-deadline/hashTable)
    (setq result-pre (sort result '<))
    (mapcar (lambda (el)
	      (number-to-string el))
	    result-pre)))
  
(defun d-job-deadline/sortedDeadlinesWithoutExpired ()
  (let* (result
	 result-pre)
    (maphash (lambda (deadline calue)
	       ;; We only need next days
	       (if (or
		    (<= (string-to-number (substring (d-current-time) 0 6))
			(string-to-number deadline))
		    (equal deadline "0"))
		   (setq result (cons (string-to-number deadline) result))))
	     d-job-deadline/hashTable)
    (setq result-pre (sort result '<))
    (mapcar (lambda (el)
	      (number-to-string el))
	    result-pre)))
  
