
;;; Logs
;; 1107260025 Fixed sorting problem.

;; 0810021617 two function was created. d-tag-region-point-list
;; d-tag-contents-lists The purpose is to parse some region. If you know
;; starting regexp and ending regexp, you can use d-tag-contents-lists.
;;
;; (d-tag-contents-lists start-regexp regexp) will returns the lists to be
;; parsed. See doc of d-tag-contents-lists
;;
;; d-worknote-create-tag is an example that use d-tag-contents-lists.

;;; ToDos
;; 1107161746 It seems more flexible to use alist.

;; See worknote2.muse#1107170054

;;; explanation
;; My note has many tags. TODO, REF, MEMO etc. The function helps to deal
;; tags.


(defvar d-tag-buffer "*Worknote-Tag*")

;;; d-tag-get-sort-lists-with-date
(defun d-tag-get-sorted-lists-with-anchor (lists)
  "Sort the result of d-tag-get-lists by date."
  ;; ((ANCHOR1 (START1 END1) CONTENTS1) ...)
  (let* ((lists-to-be-modified lists)	;will be a list of nil key
	 lists-to-be-sorted		;sorted list without nil key lists
	 string-anchor-list		;key list as string
	 number-anchor-list		;key list as number
	 string-anchor			;key as string
	 number-anchor			;key as number
	 list-matched
	 lists-matched
	 result)
    
    ;; Get the list of number of anchor
    (setq string-anchor-list (d-tag-sort-lists-with-date-getAnchorList lists-to-be-modified))
    (setq number-anchor-list (d-tag-convert-string-anchor-list-to-number-list string-anchor-list))
    ;; Sort the list of number of anchor and reverse
    (setq number-anchor-list 
	  (reverse (sort number-anchor-list '<)))	; (1107130313 1107130315 1107130318) order

    ;;number-anchor-list
    ;; Sort the input lists
    (while number-anchor-list
      (setq number-anchor (car number-anchor-list))

      ;; We find matched list
      (setq list-matched (d-tag-get-list-from-lists lists-to-be-modified number-anchor))
      ;; Move the matched list to the sorted lists
      (setq lists-to-be-modified (remove list-matched lists-to-be-modified))
      (push list-matched lists-to-be-sorted)

      (setq number-anchor-list (cdr number-anchor-list)))

    ;; Let's create result
    (dolist (list lists-to-be-modified)
      (push list result))
    (dolist (list lists-to-be-sorted)
      (push list result))
    result))



(defun d-tag-get-list-from-lists (lists key)
  "LISTS is a lists that forms (STRING1 LIST STRING2). STRING1
can be converted to the KEY by d-tag-convert-number-to-anchor.
The function returns the list that matches the key."
  (let* ((lists-local lists)
	 result)
    (while lists-local
      (if (eq key (d-tag-get-key-as-number lists-local))
	  (progn
	    (setq result (car lists-local))
	    (setq lists-local nil))
	(setq lists-local (cdr lists-local))))
    result))


(defun d-tag-get-key-as-string(lists)
  (car (car lists)))

(defun d-tag-get-key-as-number(lists)
  (let* ((anchor (d-tag-get-key-as-string lists)))
    (if anchor
	(d-tag-convert-anchor-to-number anchor)
      nil)))
      

(defun d-tag-sort-lists-from-number-anchor (lists number-anchor-list)
  "d-tag-get-lists creates the unsored lists that contains the
informations of the tags. LISTS is the result of d-tag-get-lists.
NUMBER-ANCHOR-LIST is a list which is the list of anchor number
sorted by date The function returns the sorted LISTS."
  (let* (string-anchor-list
	 string-anchor
	 number-anchor
	 element-lists			;An element of lists is a list
	 memberp
	 result)

    ;; Get the string anchor
    (while number-anchor-list
      (setq number-anchor (car number-anchor-list))
      (setq string-anchor
	    (if number-anchor
		(d-tag-convert-number-to-anchor number-anchor)
	      nil))

      ;; Get the list which contains the anchor
      (when string-anchor
	(while lists
	  (setq element-lists (car lists))
	  (setq memberp (member string-anchor element-lists))
	  (if memberp
	      (progn
		;; We got an element of result
		(push element-lists result)
		;; Terminate loop
		(setq lists nil))
	    ;; Continue loop
	    (setq lists (cdr lists))))))
    result))

(defun d-tag-sort-lists-with-date-getAnchorList (lists)
  "Get anchor list from the result of d-tag-get-lists. LISTS is
the result of d-tag-get-lists."
  (let* ((local-lists lists)
	 result
	 anchor)
    (while local-lists
      (setq anchor (car (car local-lists)))
      (unless (eq anchor nil)
	(push anchor result))
      (setq local-lists (cdr local-lists)))
    result))
      

;; TODO: Create a common function (d-libs-do-function-in-car (list func))
;; d-tag-sort-lists-with-date-getAnchorList also uses that.
(defun d-tag-convert-string-anchor-list-to-number-list (string-anchor-list)
  "d-tag-sort-lists-with-date-getAnchorList will returns the
list of anchor. Where the anchor is the string type. Let's
convert the list of the string type to the list of number type."
  (let* (result
	 anchor-string
	 anchor-number
	 )
    (while string-anchor-list
      (setq anchor-string (car string-anchor-list))
      (unless (eq anchor-string nil)
	;; convert string anchor to number anchor
	(setq anchor-number (d-tag-convert-anchor-to-number anchor-string))
	(push anchor-number result))
      (setq string-anchor-list (cdr string-anchor-list)))
    result))
	
	
(defun d-tag-convert-anchor-to-number (anchor)
  (string-to-number (substring anchor 1)))
  

(defun d-tag-convert-number-to-anchor (number)
  (concat "#" (number-to-string number)))


;;; d-tag-get-lists
(defun d-tag-get-lists (start-regexp end-regexp)
  "The function returns a lists. (TAG1 TAG2 TAG3 ... TAGN). TAG1
is previous tag than TAG2. TAGN is a list. (POINT CONTENT). POINT
is the starting point and ending point of tag. CONTENT is the
contents of tag.

 ((ANCHOR1 (START1 END1) CONTENTS1) (ANCHOR2 (START2 END2)
 CONTENTS2) ... (ANCHORN (STARTN ENDN) CONTENTSN))

START-REGEXP is the starting regexp of tag.

END-REGEXP is the ending regexp of tag.

The function uses d-tag-region-point-list mainly."
  (save-excursion
    (goto-char (point-min))
    (let* ((point t)
	   (for-case nil)
	   result)
      (if default-case-fold-search
	  (progn
	    (setq default-case-fold-search nil)
	    (setq for-case t)))

      (setq result 
	    (d-tag-get-lists-while-action start-regexp end-regexp))
      
      (if for-case
	  (setq default-case-fold-search t))
      result)))


(defun d-tag-get-lists-while-action (start-regexp end-regexp)
  (let* ((point t)
	 (result (list ()))
	 start-point
	 anchor)
    (while point
      (setq point (d-tag-region-point-list start-regexp end-regexp))
      (if point
	  (progn
	    (setq start-point (car point))
	    ;; If there is no anchor, anchor is nil
	    (setq anchor (d-tag-get-anchor start-point))
	    ;; (ANCHOR1 (START1 END1) CONTENTS1)
	    (setq result (cons
			  (list anchor
				point
				;; contents
				(buffer-substring (car point)
						  (car (cdr point))))
			  result)))))
    result))


(defun d-tag-get-anchor (start-point)
  (save-excursion
    (goto-char start-point)
    (forward-line -1)
    (beginning-of-line)
    (d-tag-get-current-line-anchor)))


(defun d-tag-get-current-line-anchor()
  "The function returns the anchor of current line. If there is
no anchor, the function returns nil."
  (let* ((anchor (replace-regexp-in-string "\n" "" (thing-at-point 'line))))
    (if (d-tag-check-anchor-format anchor)
	anchor
      nil)))

(defun d-tag-check-anchor-format(anchor)
  (let* ((start-string "#")
	 (length-of-anchor 11)
	 lenp
	 startp)
    (when (eq length-of-anchor (length anchor))
      (setq lenp t)
      ;; substring function will be error, if anchor is ""
      (when (equal start-string (substring anchor 0 1))
	(setq startp t)))
    
    (if (and startp lenp)
	t
      nil)))

(defun d-tag-region-point-list (start-regexp end-regexp)
  "The function returns a list. (START END). START is the start
point of tag. END is the end point of tag.
START-REGEXP is the starting regexp of tag.
END-REGEXP is the ending regexp of tag.

This will returns case ignore result. Because I was set (setq
case-fold-search t).
"
  (let* (poi)
    (if (re-search-forward start-regexp nil t)
	(progn 
	  (setq poi (- (point) (length (match-string 0))))
	  (if (re-search-forward end-regexp nil t)
	      (progn
		(backward-char 1)
		(cons poi (list (- (point) (length (match-string 0))))))
	    (goto-char (point-max))
	    (cons poi (list (point)))))
      nil)))

(provide 'd-tag)
