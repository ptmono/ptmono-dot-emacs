
;현재의 worknote를 보고 싶다면 d-worknote-current를 이용하고 list를 보고 싶다면
;d-worknote-lst를 이용.
;d-worknote-worknote를 이용하여 메모용(?)의 worknote.muse로 이동하자.


;;; log
;
; 0705291858
;
;	planner note 에서 header title 을 다른 버퍼에 list 해주는
;	'd-worknote-create-note-header 작성
;

; 0810021640
;
;       To parse tag we add a function d-worknote-create-tag and two variable
;       d-worknote-tag-regexp-end and d-worknote-tag-lists. The function
;       requires d-tag-contents-lists.


;;; todo
;
; 0904300349 d-worknote-worknote는 shift+F11을 동작한다. worknote.muse로 이동하고
; 있다.

;; 1003260903 boxing of source code in show


;;; (defvar d-note-section-regexp "^\\.#+[A-z]?[0-9]+\\|^[*\f]+ \\|^[A-Z]+: \\|^[@\f]+ " "for planner's note section")
;outline-mode for muse-mode


(require 'd-tag)

(defcustom d-worknote-tag-regexp-end "^\n\n" "The regexp to be end of tag."
  :type 'string
  :group 'd-worknote)

(defcustom d-worknote-tag-report-regexp-end "^\n\n" "The regexp to be end of report tag."
  :type 'string
  :group 'd-worknote)

(defcustom d-worknote-tag-lists
  '(("all" d-muse-tag-1 d-worknote-tag-regexp-end)
    ("memo" "\\(^MEMO\\): " d-worknote-tag-regexp-end)
    ("ref" "\\(^REF\\): " d-worknote-tag-regexp-end)
    ("todo" "\\(^TODO\\): " d-worknote-tag-regexp-end)
    ("read" "\\(^READ\\): " d-worknote-tag-regexp-end)
    ("report" "\\(^REPORT\\): " d-worknote-tag-report-regexp-end))
"The lists is used for d-worknote-create-tag."
:group 'd-worknote
)


(defvar d-worknote-current-register ?R)
(defvar d-worknote-name (if (d-windowp) "worknote_xp" "worknote3"))
(defvar d-worknote-name-with-extension (concat d-worknote-name ".muse"))
(defvar d-worknote-name-full 
  (if (d-windowp)
      (concat "c:/emacsd/cygwin/home/ptmono/plans/" d-worknote-name-with-extension)
    (concat d-home "/plans/" d-worknote-name-with-extension)))

(defvar d-worknote-list (list d-worknote-name-full))
(defvar d-worknote-mode nil)


(defun d-worknote-current ()
  "open to other window current worknote. set current worknote with prefix"
  (interactive)
  (if current-prefix-arg
      (push (or (buffer-file-name) (buffer-name)) d-worknote-list)
    (if (equal (or (buffer-file-name) (buffer-name)) (car d-worknote-list))
	(progn
	  (bury-buffer)
	  (jump-to-register d-worknote-current-register))
      (window-configuration-to-register d-worknote-current-register)
      (when (one-window-p)
	(if (equal major-mode 'w3m-mode)
	    (split-window) 
	  ;; for 1208x1024
	  (split-window nil nil t)))
          ;; (split-window)))
      (other-window 1)
      ;; Is file buffer-file-name or buffer-name?
      (if (file-name-absolute-p (car d-worknote-list))
	  (if (eq (length d-worknote-list) 1)
	      ;; Main worknote is current worknote
	      (d-worknote-openWorknote)
	    ;; There is specified worknote
	    (find-file (car d-worknote-list)))
	(switch-to-buffer (car d-worknote-list))))))

(defun d-worknote-openWorknote ()
  "After to open worknote we have to move the cursor to end.
Because the end is the last note. To avoid that, this function
will move the cursor to the end of buffer when the worknote
buffer is not exist."
  (if (d-worknote-current-worknotep)
      ;; There is exist worknote
      (find-file d-worknote-name-full)
    ;; There is no worknote buffer
    (find-file d-worknote-name-full)
    (goto-char (point-max))))

    

(defun d-worknote-current-worknotep ()
  ""
  (let* ((buffer-list (mapcar (function buffer-name) (buffer-list))))
    (if (member d-worknote-name-with-extension buffer-list)
	t
      nil)))
    


(defun d-worknote-list (bbb)
  "create *worknote-list* that contains the list of worknotes setted"
  (interactive
   (list d-worknote-list))
  (when (one-window-p)
    (split-window nil nil t))
  (switch-to-buffer-other-window (generate-new-buffer "*worknote-list*"))
  (dolist (list bbb)
    (insert (concat "[[" list "][" (or (file-name-nondirectory list) list) "]]\n\n")))
  (muse-mode)
  (goto-char (point-min)))


(defvar d-worknote-worknote-register ?R)

(defun d-worknote-worknote ()
  "open to other window ~/plans/worknote.muse"
  (interactive)
  (if (equal (buffer-file-name) d-worknote-name-full)
      (jump-to-register d-worknote-worknote-register)
    (window-configuration-to-register d-worknote-worknote-register)
    (when (one-window-p)
      (split-window nil nil t))
    (other-window 1)
    (d-worknote-openWorknote)))



(defun d-worknote-create-note-header ()
  "Create the list of note headr of current plan page. The function cretes
the lists of note header to other window.

worknote : 0705291510
elispworknote : 0705291100

todo:
 1. planner-note-headline-face를 적용시키고 싶은데 쉽게 되지 않고 있다.
 2. 다른 heading ; * or # 에 대해서도 적용시키고 싶다.


1.
 muse-config.el 에 적용된 add-text-properties, set-text-properties 를 이용하여
 face를 적용해 보았지만 적용되지 않았다. muse-face에 대해서 근본적인 이해가 필요할
 것 같다.
"
  (interactive)
  (let ((list))
    (save-excursion
      (goto-char (point-max))
      (while (re-search-backward "^\\.#[0-9]+" nil t)
	(add-to-list 'list (planner-current-note-info))))
    ;; 지금 원하는 것은 heading 만을 보여주는 것이다.
    ;; 차후 heading 과 내용 2줄 정도를 보게끔 하는 함수를 만드는 것도 좋겠다.
    (d-window-separate)
    (other-window 1)
    (find-file "~/plans/worknoteHeaderList.muse")
    (if view-mode
	(view-mode))
    (erase-buffer)
    (unless (eq major-mode 'muse-mode)
      (muse-mode))
    (dolist (i list)
      (let ((page (nth 0 i))
	    (anchor (nth 1 i))
	    (title (nth 2 i))
	    (tags (nth 4 i)))
	(insert (concat "[[" page "#" anchor "][" anchor "]]: " title
			(when tags
			  (if (listp tags)
			      (concat  "("
			      (let ((b))
				(dolist (a tags b)
				  (setq b (concat b " " a)))) ")")
			    (concat " (" tags ")")))
			"\n"))))
    (goto-char (point-min))))
;  (while (re-search-forward "^#.*" nil t)
;    (set-text-properties (match-beginning 0)
;			 (match-end 0)
;			 '(face planner-note-headline-face))))


(defun d-worknote/note ()
  "Open worknote for web browsers. I think it also in contains
oswk."
  (interactive)
  ;; Hide all exist frame for alt-tab
  (dolist (aa (frame-list))
    (iconify-frame aa))
  (let* ((frame (make-frame-command)))
    (select-frame-set-input-focus frame)
    (modify-frame-parameters frame (x-parse-geometry "80x100-20+0"))
    (find-file d-worknote-name-full)))


;;; === Tag handling
;;; --------------------------------------------------------------
;; This section requires d-tag.el

(defun d-worknote-create-tag (start-regexp end-regexp)
  "The function will create a page to be parsed by regexps. The
function use d-tag-contents-lists.

START-REGEXP is the starting regexp. END-REGEXP is the ending
regexp.

Notice if case-fold-search is non-nil, the results will ignore
the case.
"
  (interactive 
   (if current-prefix-arg
       (let* ((tag (completing-read "Choose: " d-worknote-tag-lists))
	      (tag-list (assoc tag d-worknote-tag-lists))
	      (cdr (car (cdr tag-list)))
	      (cddr (car (cddr tag-list))))
	 
	 ;; where I simplely cannot use cdr and cddr. I must use the
	 ;; function symbol-value. WHY? 단순히 cdr 과 cddr 을 사용할 때에
	 ;; re-search-forward 에 d-muse-tag-1 이 변수가 아닌 심볼(?)로
	 ;; 전달되는 듯 하다. 이것은 list의 값이다.
	 
	 ;; symbol-value를 사용해야 하는 이유는 d-worknote-tag-lists가 '를
	 ;; 이용하여 만들어 졌기 때문이다. list의 내용은 symbol 의 print
	 ;; name 구성의 내용이다. [[elisp#0810020437]] 을 보기 바란다.
	 (list
	  (if (stringp cdr)
	      cdr
	    (symbol-value cdr))
	  (if (stringp cddr)
	      cddr
	    (symbol-value cddr))))
     (let* ((tag-list (assoc "all" d-worknote-tag-lists))
	    (cdr (car (cdr tag-list)))
	    (cddr (car (cddr tag-list))))
       (list
	(if (stringp cdr)
	    cdr
	  (symbol-value cdr))
		    (if (stringp cddr)
			cddr
		      (symbol-value cddr))))))

  (d-worknote-create-tag-buffer start-regexp end-regexp)
  (goto-char (point-min))
  (muse-mode)
  (message "complete")
  )

(defun d-worknote-create-tag-buffer (start-regexp end-regexp)
  (let* ;;((content-lists (reverse (d-tag-get-sorted-lists-with-anchor
      ((content-lists (d-tag-get-sorted-lists-with-anchor
		       (d-tag-get-lists start-regexp end-regexp)))
       (buffer-filename (buffer-file-name))
       pre-date)
    (d-window-separate)
    (other-window 1)
    (switch-to-buffer d-tag-buffer)
    (erase-buffer)

    ;; lists contains nil list
    (setq content-lists (remove nil content-lists))
    (dolist (list content-lists)
      (let* ((anchor (nth 0 list))
	     (start-point (car (nth 1 list)))
	     (content (nth 2 list))
	     (date 
	      ;; Check the anchor is nil
	      (if anchor
		  (d-worknote-convert-anchor-to-date anchor)
		nil))
	     (diff-datep
	      ;; Check there is no section
	      (if (not pre-date)
		  (progn
		    (setq pre-date date)
		    (list t t t))
		;; There are previous sections.
		;; Check the anchor is nil
		(if date
		    (let* (result)
		      (setq result (d-worknote-check-two-dates-diff date pre-date))
		      (setq pre-date date)
		      result)
		  nil))))
      
	;; Insert sections
	(when date
	  (d-worknote-tag-insert-date date diff-datep)
	  ;; insert day and dayname
	  (d-worknote-tag-insert-day date))

	;; about replace-regexp-in-string
	;; notice optional argument (t nil) and \\&(original match). if (nil t) your
	;; REP(see manual) to be case and you cannot use \\&
	(insert (replace-regexp-in-string start-regexp 
					  (concat "[[pos://" buffer-filename
						  "#"
						  (number-to-string start-point)
						  "][\\&]]  ")
					  content t nil 1))
	(insert "\n\n\n")))))


(defun d-worknote-tag-insert-day (date)
  (let* ((day (nth 2 date))
	 (dayname (d-worknote-tag-get-dayname date))
	 (content (concat (number-to-string day) "(" dayname ")\n")))
    (insert content)))
    
    

(defun d-worknote-tag-get-dayname (date)
  (let* ((calendar-date (d-worknote-tag-convert-calendar-date date))
	 (dayname (calendar-day-name calendar-date)))
    dayname))

(defun d-worknote-tag-convert-calendar-date (date)
  (let* ((year (nth 0 date))
	 (month (nth 1 date))
	 (day (nth 2 date)))
    (list month day year)))

  
;; We can emerge the functions
(defun d-worknote-tag-insert-date (date diff-datep)
  (d-worknote-tag-insert-year date diff-datep)
  (d-worknote-tag-insert-month date diff-datep))

(defun d-worknote-tag-insert-year (date diff-datep)
  (let* ((year (nth 0 date))
	 (diff-yearp (nth 0 diff-datep))
	 (content (concat "* " "20" (number-to-string year) "\n\n")))
    (if diff-yearp
	(insert content))))

(defun d-worknote-tag-insert-month (date diff-datep)
  (let* ((month (nth 1 date))
	 (diff-monthp (nth 1 diff-datep))
	 (content (concat "** " (number-to-string month) " month\n\n")))
    (if diff-monthp
	(insert content))))

;; The anchor start #. e.g) #1206121731
(defun d-worknote-convert-anchor-to-date (anchor)
  (let* (year
	 month
	 day)
    (setq year (string-to-number (substring anchor 1 3)))
    (setq month (string-to-number (substring anchor 3 5)))
    (setq day (string-to-number (substring anchor 5 7)))

    (list year month day)))

(defun d-worknote-check-two-dates-diff (date pre-date)
  (let* ((year-pre (nth 0 pre-date))
	 (month-pre (nth 1 pre-date))
	 (day-pre (nth 2 pre-date))
	 (year (nth 0 date))
	 (month (nth 1 date))
	 (day (nth 2 date))
	 diff-yearp
	 diff-monthp
	 diff-dayp)

    (if (eq year-pre year)
	(setq diff-yearp nil)
      (setq diff-yearp t))

    (if (eq month-pre month)
	(setq diff-monthp nil)
      (setq diff-monthp t))

    (if (eq day-pre day)
	(setq diff-dayp nil)
      (setq diff-dayp t))

    (list diff-yearp diff-monthp diff-dayp)))


;;; === Section and anchor
;;; --------------------------------------------------------------
(defvar d-worknote-section-name-regexp "\\(^[*\f]+ \\|^[@\f]+ 
\\)\\(.*\\)")

(defvar d-worknote-section-regexp "^[*\f]+ ")
(defvar d-worknote-sections-regexp "^[*\f]+ \\|^[@\f]+ ")
(defvar d-worknote-anchor-regexp "\\(^#[0-9]\\{10\\}\\)")


(defun d-citation-change-anchor-which ()
  "I add the citation number to above of section. It has a
problem with outline-mode. In outline-mode the section kill-ring
without the citation number. So I need a tool to change the which
of citation number. The function will change the which to below
of the section."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward d-worknote-sections-regexp nil t)
      ;; Chane the which of anchor if there is
      (d-citation-change-anchor-which-in-section-line))))

(defun d-citation-change-anchor-which-in-section-line ()
  (let* ((magic-number-for-deletion 11)
	 anchor-list			;(pre-anchor, sub-anchor)
	 pre-anchor
	 sub-anchor
	 )
      (setq anchor-list (d-worknote-get-section-anchor-in-section-line))
      (setq pre-anchor (car anchor-list))
      (setq sub-anchor (car (cdr anchor-list)))

      (cond ((and pre-anchor (not sub-anchor))
	     (d-worknote-delete-pre-anchor-in-section-line)
	     (d-worknote-insert-anchor-in-section-line pre-anchor))
	    ((and pre-anchor sub-anchor)
	     (d-worknote-delete-pre-anchor-in-section-line)
	     (d-worknote-delete-sub-anchor-in-section-line)
	     (d-worknote-insert-anchor-in-section-line pre-anchor))
	    )))

(defun d-worknote-get-section-anchor-in-section-line ()
  "Get current line's anchors. Current line is the line of
section."
  (let* (pre-anchor
	 sub-anchor)
      (setq pre-anchor (d-worknote-get-pre-anchor-in-section-line))
      (setq sub-anchor (d-worknote-get-sub-anchor-in-section-line))
      (list
       pre-anchor
       sub-anchor)))


(defun d-worknote-delete-pre-anchor-in-section-line ()
  (let* ((begin-position (save-excursion
			     (beginning-of-line)
			     (point)))
	 (pre-anchorp (d-worknote-get-pre-anchor-in-section-line)))
    (if pre-anchorp
	(condition-case nil
	    (delete-region (- begin-position 12) (- begin-position 1))
	  (error nil))
      nil)))


(defun d-worknote-delete-sub-anchor-in-section-line ()
  (let* ((end-position (save-excursion
			     (end-of-line)
			     (point)))
	 (sub-anchorp (d-worknote-get-sub-anchor-in-section-line)))

    (if sub-anchorp
	(condition-case nil
	    (delete-region (+ end-position 1) (+ end-position 12))
	  (error nil))
      nil)))
    

(defun d-worknote-get-pre-anchor-in-section-line ()
  (let* ((begin-position (save-excursion
			   (beginning-of-line)
			   (point)))
	 result)
    (condition-case nil
	(setq result (buffer-substring (- begin-position 12) (- begin-position 1)))
      (error nil))
    (setq result (d-worknote-get-anchor-from-string result))
    result))


(defun d-worknote-get-sub-anchor-in-section-line ()
  (let* ((end-position (save-excursion
			   (end-of-line)
			   (point)))
	 result)
    (condition-case nil
	(setq result (buffer-substring (+ end-position 1) (+ end-position 12)))
      (error nil))
    (setq result (d-worknote-get-anchor-from-string result))
    result))

(defun d-worknote-insert-anchor-in-section-line (anchor)
  (save-excursion
    (end-of-line)
    (newline)
    (insert anchor)))


(defun d-worknote-get-anchor-from-string (anchor-str)
  (let* (result)
    (if (equal anchor-str nil)
	(setq anchor-str ""))
    (if (string-match d-worknote-anchor-regexp anchor-str)
	(setq result (match-string 1 anchor-str))
      (setq result ""))
    (if (equal result "")
	nil
      result)))


(defun d-worknote-get-section-name (&optional subsection)
  (save-excursion
    (let* ((current-line-section-name (d-worknote-get-section-name-in-line))
	   (section-regexp (if subsection
			       d-worknote-sections-regexp
			     d-worknote-section-regexp)))
      (if current-line-section-name
	  current-line-section-name
      (re-search-backward section-regexp nil t)
      (d-worknote-get-section-name-in-line)))))
  
  
(defun d-worknote-get-section-name-in-line ()
  (save-excursion
    (let* ((line-str (thing-at-point 'line))
	   result)
      (if (string-match d-worknote-section-name-regexp line-str)
	  (setq result (match-string 2 line-str))
	nil)
      result)))






;; TODO: We made section info functions. Refactoring related functions.

(defcustom d-worknote-section/info-alists
  '((title . d-worknote-section/getTitle)
    (anchor . d-worknote-section/getAnchor)
    (level . d-worknote-section/getLevel)
    ;; (type . d-worknote-section/getType)
    (start_pointer . d-worknote-section/getStart)
    (end_pointer . d-worknote-section/getEnd))
  "Specify the info for the section. The function
d-worknote-section-info returns the infomation of
d-worknote-section/info-alists value."
  :group 'd-worknote)

(defvar d-worknote-section/section-title-regexp
  "^\\([*\f]+\\) \\(.*\\)$")

(defvar d-worknote-section/sectionOrNote-regexp
  "^[*\f]+ \\|^\\.#[0-9]\\{10\\}")

(defvar d-worknote-section/anchorInsertedp nil)

(defun d-worknote-section/getTitle ()
  (save-excursion
    (re-search-backward d-worknote-section/section-title-regexp nil t)
    (substring-no-properties (match-string 2))))

(defun d-worknote-section/getAnchor ()
  (save-excursion
    (let* (anchor)
      (re-search-backward d-worknote-section/section-title-regexp nil t)
      (setq anchor (substring-no-properties (d-worknote-section/getAndChageAnchorWhichInLine)))
      (if (not anchor)
	  (setq anchor (concat "#" (d-create-citation))))
      anchor)))

(defun d-worknote-section/getLevel ()
  (save-excursion
    (re-search-backward d-worknote-section/section-title-regexp nil t)
    (length (match-string 1))))


(defun d-worknote-section/getStart ()
  (save-excursion
    (re-search-backward d-worknote-section/section-title-regexp nil t)
    (re-search-forward "\n\n" nil t)))

(defun d-worknote-section/getEnd ()
  (let* (section-point
	 result)

    (save-excursion
      (setq result (re-search-forward d-worknote-section/sectionOrNote-regexp nil t))
      (if result
	  (re-search-forward "\n")
	;; no more section
	(point-max)))))


(defun d-worknote-section-info ()
  "Use the result with assoc function. The key is defined in d-worknote-section/info-alists. For instance,
akak
 (end_pointer 2854 start_pointer 2765 level 1 anchor #(\"#1107181124\" 0 11 (fontified t)) title #(\"ccc\" 0 3 (fontified t face muse-header-3)))
 (cdr (assoc 'title akak))
 #(\"ccc\" 0 3 (fontified t face muse-header-3))
"
  (interactive)
  (let* ((info_elements d-worknote-section/info-alists)
	 (element '())
	 (result '())
	 func
	 name
	 value
	 )

    (while info_elements
      (setq name (car (car info_elements)))
      (setq func (cdr (car info_elements)))
      (setq value (funcall func))
      (setq element (cons name value))
      (setq result (cons element result))
      (setq info_elements (cdr info_elements)))
    result))


  
(defun d-worknote-section/getAndChageAnchorWhichInLine ()
  "Modify previous upper anchor and get the anchor. If there is
  anchor, the function returns the anchor. If there is no anchor,
  the function will create and insert anchor into the section."
  ;; TODO: rewrite the function

  (let* ((magic-number-for-deletion 11)
	 anchor-list	; (pre-anchor, sub-anchor)
	 pre-anchor
	 sub-anchor
	 result
	 )
      (setq anchor-list (d-worknote-get-section-anchor-in-section-line))
      (setq pre-anchor (car anchor-list))
      (setq sub-anchor (car (cdr anchor-list)))

      (cond ((and (not pre-anchor) (not sub-anchor))
	     (d-worknote-section/createSubAnchor))
	    ((and pre-anchor (not sub-anchor))
	     (d-worknote-delete-pre-anchor-in-section-line)
	     (d-worknote-insert-anchor-in-section-line pre-anchor)
	     pre-anchor)
	    ((and pre-anchor sub-anchor)
	     (d-worknote-delete-pre-anchor-in-section-line)
	     (d-worknote-delete-sub-anchor-in-section-line)
	     (d-worknote-insert-anchor-in-section-line pre-anchor)
	     sub-anchor)
	    (sub-anchor
	     sub-anchor)
	    (t
	     nil))))

;; Fixme: We couldn't save the buffer. basic-save-buffer-1 returns
;; variable type error.
(defun d-worknote-section/createSubAnchor ()
  (let* ((anchor (d-create-anchor)))
    (if (y-or-n-p "We don't have anchor. Save the buffer. ")
	(progn
	  (d-worknote-insert-anchor-in-section-line anchor)
	  ;; (save-buffer)
	  anchor)
      nil)))

;;; parag



(defvar d-worknote-parag-sec-info-lists
  '((1 . (4 2))
    (2 . (4 1))
    (3 . (3 1))
    (4 . (2 1)))
  "")

(defvar d-worknote-parag-sec-regexp
  "^\\(\\*+\\) "
  "")


;; Fixme: the function couldn't calculate previous spaces.
(defun d-worknote-parag-section ()
  ""
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward d-worknote-parag-sec-regexp  nil t)
      (let ((level (length (match-string 1))))
	(d-worknote-parag-one level)))))

;; todo 모든 section에 대한 paragrahp 
(defun d-worknote-parag-one (sec-lv)
  "함수는 레벨에 대하여 현재 d-worknote-parag-sec-info-lists에
따라 아래위로 추가하여 주어야 할 line의 수를 결정한다. line의 수가
음수이면 line을 삭제한다. 결정된 line의 수는
d-worknote-parag-section-one-side에 의해서 추가되거나 삭제된다."
  (let* ((para-list (cdr (assoc sec-lv d-worknote-parag-sec-info-lists)))
	 (above (car para-list))
	 (below (car (cdr para-list)))
	 (above-diff (- above (d-worknote-parag-get-sec-above-info)))
	 (below-diff (- below (d-worknote-parag-get-sec-below-info))))
    (beginning-of-line)
    (d-worknote-parag-one-side-with-anchor above-diff below-diff)
    (end-of-line)))

(defun d-worknote-parag-one-side-with-anchor (above below)
  "Same function of d-worknote-parag-one-side without that the
function consider the anchor."
  (let* ((anchor-list (d-worknote-get-section-anchor-in-section-line))
	 (pre-anchor (car anchor-list))
	 (sub-anchor (car (cdr anchor-list))))
    (if pre-anchor
	(progn
	  (forward-line -1)
	  (d-worknote-add-above-lines above)
	  (forward-line 1))
      (d-worknote-add-above-lines above))

    (if sub-anchor
	(progn
	  (forward-line 1)
	  (d-worknote-add-below-lines below)
	  (forward-line -1))
      (d-worknote-add-below-lines below))))
      


(defun d-worknote-add-above-lines (number)
    (if (> 0 number)
	(kill-line number)
      (newline number)))

(defun d-worknote-add-below-lines (number)
  (save-excursion
    (forward-line)
    (if (> 0 number)
	  (kill-line (abs number))
	(newline number))))
	

(defun d-worknote-parag-one-side (above below)
  "현재의 line에서 아래 위로 above below 만큼 추가해 준다. 만약
above or below가 음수이면 라인을 삭제한다."
  (if (> 0 above)
      (kill-line above)
    (newline above))
  (if (> 0 below)
      (progn
	(forward-line)
	(kill-line (abs above))
	(forward-line -1))
    (progn
      (forward-line)
      (newline below)
      (forward-line (- (1+ below))))))


(defun d-worknote-parag-one-side-underline (above below)
  "아래줄이 있는 section에 대하여 적용할 수 있는
d-worknote-parag-one-side 이다. 현재의 line에서 아래 위로 above
below 만큼 추가해 준다. 만약 above or below가 음수이면 라인을
삭제한다."
  (if (> 0 above)
      (kill-line above)
    (newline above))
  (if (> 0 below)
      (progn
	(forward-line 2)
	(kill-line (abs above))
	(forward-line -2))
    (progn
      (forward-line 2)
      (newline below)
      (forward-line (- (+ 2 below))))))


(defun d-worknote-parag-get-sec-above-info ()
  "The function returns above paragrahp line number"
  (save-excursion
    (let ((current-line (line-number-at-pos))
	  above-line)
      (beginning-of-line)
      (re-search-backward "^.+" nil t)
      (setq above-line (line-number-at-pos))
      (- (- current-line above-line) 1))))



(defun d-worknote-parag-get-sec-below-info ()
  "The function returns below paragrahp line number"
  (save-excursion
    (let ((current-line (line-number-at-pos))
	  below-line)
      (end-of-line)
      (re-search-forward "^.+" nil t)
      (setq below-line (line-number-at-pos))
      (- (- below-line current-line) 1))))



(defun d-worknote-note-done ()
  "change the status of note to DONE."
  (interactive)
  (save-excursion
    (save-restriction
      (planner-narrow-to-note)
      (goto-char (point-min))
      (if (looking-at ".#[0-9]+") (goto-char (match-end 0)))
      (if (or (looking-at " *"))
	  (replace-match " DONE " t t))))
  (message "note is DONE"))



(defvar d-worknote-newline-heading-symbol "@" "")


(defun d-worknote-newline-heading ()
  "This function provides heading underlinning
such as

@ test
======

TODO: apply mutiple mode and mutiple symbol
DONE: paragraphs. above 2line, below 1line
"
  (interactive)
  ;; if muse-mode or planner-mode
  (if (or (eq major-mode 'muse-mode) (eq major-mode 'planner-mode))
      (let ((p-column (current-column))
	    (p-cu (point))
	    (p-be (progn (beginning-of-line) (point)))
	    (p-en (progn (end-of-line) (point)))
	    (sec-level 0))
	(if (eq p-cu p-en)
	    ;; check d-newline-heading-symbol
	    (when (and (not (eq p-be p-en)) (string= d-worknote-newline-heading-symbol (char-to-string (char-after p-be))))
	      ;; var1={the point of beginning of line}
	      ;; var2={the point of end of line}
	      ;; var3={var2 - var1}
	      (save-excursion
		(goto-char p-be)
		(while (string= d-worknote-newline-heading-symbol (char-to-string (char-after (point))))
		  (forward-char)
		  (setq sec-level (+ sec-level 1))))

	      (newline)
	      (if (equal sec-level 1)
		  (progn
		    (dotimes (a (+ sec-level 1)) (insert " "))
		    (dotimes (a (- p-column (+ sec-level 1))) (insert "=")))
		(progn
		  (dotimes (a (+ sec-level 1)) (insert " "))
		  (dotimes (a (- p-column (+ sec-level 1))) (insert "-")))))
	  (goto-char p-cu))
	(newline))
    (newline)))




(defun d-worknote-newline-insert (symbol)
 "underlining with SYMBOL."
  (let ((p-cu (point))
	(p-be (progn (beginning-of-line) (point)))
	(p-en (progn (end-of-line) (point))))
    (newline)
    (dotimes (a (- p-en p-be)) (insert symbol)))
  (newline))
  


(defun d-worknote-window-selecter (num)
  "The purpose of this fuction is to select a separated window
  with any key binding. NUM is the number of window. The number
  start left-up to right-down.

     +--------+----------+
     |	 1    |	   3	 |
     | 	      |	    	 |
     +--------+----------+
     |	 2    |	   4 	 |
     |	      |		 |
     +--------+----------+
This function supports 2 vertically separated frame.

NOTE:

The core function is 'window-tree'. 'window-tree' returns a list
of (x x LEFT-SIDE-LIST RIGHT-SIDE-LIST). LEFT-SIDE-LIST and
RIGHT-SIDE-LIST is either a list for multi window or a element
for single window.

See elispWorknote 0801141256.

TODO:
 -3 support more vertically separated windows

"
  (interactive "N")
  (let* ((tree (window-tree))
	 (left-window-list-p (listp (nth 2 (nth 0 tree))))
	 (left-window-num (if left-window-list-p
			      ;; two component is not window
			      (- (length (nth 2 (nth 0 tree))) 2)
			    1))
	 (right-window-list-p (listp (nth 3 (nth 0 tree))))
	 (right-window-num (if right-window-list-p
			       (- (length (nth 3 (nth 0 tree))) 2)
			     1))
	 )
    ;; if left-window is not list
    ;; num >= left-window-num
    (condition-case nil
	(if (<= num left-window-num)
	    (if (= left-window-num 1)
		(select-window (nth 2 (nth 0 tree)))
	      (select-window (nth (+ num 1) (nth 2 (nth 0 tree)))))
	  (if (= right-window-num 1)
	      (select-window (nth 3 (nth 0 tree)))
	    (select-window (nth (+ (- num left-window-num) 1) (nth 3 (nth 0 tree))))))
      (error (message "This frame does not has %sth window." num)))))


(defun d-worknote-tag-ref-number (tag)
  "Insert the number of ref."
  (interactive)
  (if current-prefix-arg
      (setq tag (upcase (read-string "Tag: "))))
  (insert (concat tag ": "))
  (let* ((value 0)
	 word
	 (search-end (if current-prefix-arg
			 (point-max)
		       nil))
	 (search-start (if current-prefix-arg
			   (point-min)
			 nil))
	 )
    (save-excursion
      (when (and (eq major-mode 'planner-mode) (eq current-prefix-arg nil))
	(setq search-end (re-search-forward d-planner-note-header-regexp nil t))
	(forward-line -1)
	(setq search-start (re-search-backward d-planner-note-header-regexp nil t)))
      ;; note muse has search-start
      (if search-start
	  (goto-char search-start)
	(goto-char (point-min)))
      (while (re-search-forward (concat "^" tag ": ") search-end t)
	(setq word (thing-at-point 'word))
	(if word
	    (progn
	      (setq word (string-to-number word))
	      (if (> word value)
		  (setq value word))))))
    (insert (concat (number-to-string (+ value 1)) ", "))))


(defun d-worknote-firefox-get-url ()
  "Insert firefox url. With prefix you can obtains title."
  (interactive)
  (let* (url
	 title
	 (without-title (if current-prefix-arg
			    t
			  nil)))
    (comint-send-string (inferior-moz-process) "escape(content.location.href)")
    (sleep-for 0.1)
    (setq url (d-worknote-firefox-get-parse))
    (setq url (d-worknote-firefox-string-ucs-with-other url))
    (comint-send-string (inferior-moz-process) "escape(document.title)")
    (sleep-for 0.1)
    (if without-title
	(progn
	 (setq title (d-worknote-firefox-get-parse))
	 (setq title (d-worknote-firefox-string-ucs-with-other title))
	 (setq title (d-worknote-firefox-get-url-filterUnwantedTexts title)))
      (setq title url))
    ;; moz interest only selected window

    ;; Fixmed: the kill function requires y-or-n. disable that
    (delete-process "*Moz*")
    (kill-buffer "*Moz*")
    (insert (d-worknote-firefox-get-filter (concat "[[" url "][" title "]]")))))


(defun d-worknote-firefox-get-url-filterUnwantedTexts (text)
  (setq text (replace-regexp-in-string " \(Build [0-9]\\{14\\}\)" "" text))
  (setq text (replace-regexp-in-string ":" "" text))
  text)


(defun d-worknote-firefox-string-ucs-with-other (arg)
  " somethig has no table. %3 is :. %2 is space. The number is
the unicode number. So you can the number from
http://en.wikipedia.org/wiki/Basic_Latin_Unicode_block"
  (setq arg (replace-regexp-in-string "%u...." 'd-worknote-firefox-string-ucs arg))
  (setq arg (replace-regexp-in-string "%20" " " arg))
  (setq arg (replace-regexp-in-string "%7C" "-" arg)) ; originalry %7C is |

  (setq arg (replace-regexp-in-string " - Mozilla Firefox" "" arg))

  (setq arg (replace-regexp-in-string "%21" "!" arg))
  (setq arg (replace-regexp-in-string "%23" "#" arg))
  (setq arg (replace-regexp-in-string "%24" "$" arg))
  (setq arg (replace-regexp-in-string "%25" "%" arg))
  (setq arg (replace-regexp-in-string "%26" "&" arg))
  (setq arg (replace-regexp-in-string "%27" "'" arg))
  (setq arg (replace-regexp-in-string "%28" "\(" arg))
  (setq arg (replace-regexp-in-string "%29" "\)" arg))
  (setq arg (replace-regexp-in-string "%2A" "\*" arg))
  (setq arg (replace-regexp-in-string "%2C" "," arg))
  (setq arg (replace-regexp-in-string "%3A" ":" arg))
  (setq arg (replace-regexp-in-string "%3D" "=" arg))
  (setq arg (replace-regexp-in-string "%3F" "?" arg))
  (setq arg (replace-regexp-in-string "%5E" "^" arg))

  )

  

(defun d-worknote-firefox-string-ucs (arg)
  "return unicode character \\uxxxx from string \"%uxxxx\" or return \"\".
   probably fails badly if xxx is not a valid hex code from
   from gnus://nnml:emacs/<m2skce17y9.fsf@free.fr>"
    (or 
      (char-to-string
        (decode-char 'ucs
               (string-to-number
                   (substring arg 2) 16)))
      ""))

;; Fixme: this function duplicated with d-worknote-firefox-string-ucs-with-other
(defun d-worknote-firefox-get-parse ()
  "The return string for the command of moz"
  (save-window-excursion
    (switch-to-buffer "*Moz*")
    (goto-char (point-max))
    (re-search-backward "\"\\(.+\\)\"" nil t)
    (replace-regexp-in-string "|" "-" (match-string 1))
    ;(replace-regexp-in-string " - Swiftfox" "" (match-string 1))
    ;(replace-regexp-in-string " - Mozilla Firefox" "" (match-string 1))
    ))

(defun d-worknote-firefox-get-filter (string)
  "url need some filtering"
  (setq string (replace-regexp-in-string "|" "-" string))
  (replace-regexp-in-string " - Swiftfox" "" string))



(require 'd-citation)

(defun d-worknote-img-resize-percent ()
  "To resize lastest image with percent."
  (interactive)
  (let* ((resize (concat (read-string "percent: ") "%"))
	 (img-name (concat d-home "imgs/image" (number-to-string (d-citation-max-number)) ".jpg")))
    (shell-command-to-string (concat "convert " img-name " -resize " resize " " img-name))))


(defun d-worknote-img-delete ()
  "Delete latest img"
  (interactive)
  (let* ((img-name (concat d-home "imgs/image" (number-to-string (d-citation-max-number)) ".jpg")))
    (if (y-or-n-p "Really? ")
	(shell-command-to-string (concat "rm " img-name)))))



;;; === Dired
;;; --------------------------------------------------------------
(defvar d-worknote-file-info-file "w.muse")

(defvar d-worknote-file-info-tag "FILE")

(defun d-worknote-file-info ()
  "Go to the file note."
  (interactive)
  (let* ((filename-with-dir (dired-get-filename))
	 (filename-dir (file-name-directory filename-with-dir))
	 (filename (file-name-nondirectory filename-with-dir))
	 (filename-with-tag (concat d-worknote-file-info-tag ": " filename " "))
	 (filename-regexp (concat "^" filename-with-tag))
	 note-pointer
	 above-line-count
	 )
    ;(d-window-separate) ; d-library.el
    ;(other-window 1)

    ;; aleady w.muse exist, find-file will open w.muse<2> which is w.muse
    ;; of current directory.
    (find-file (concat filename-dir d-worknote-file-info-file))
    (goto-char 0)
    (setq note-pointer (re-search-forward filename-regexp nil t))
    (if note-pointer
	(goto-char note-pointer)

      ;; Let's create new tag
      (goto-char (point-max))
      ;; There is two case beginning-of-line or not.
      (unless (d-libs-check-beginning-of-line)
	(newline 1))
      (setq above-line-count (d-worknote-parag-get-sec-above-info))
      ;; We want 2 paragraph space.
      (when (< above-line-count 2)
	(newline (- 2 above-line-count)))
      (insert filename-with-tag))))


;;; === Show : Convert worknote to pdf
;;; --------------------------------------------------------------
;; Main purpose is that. To print my note we need a tool for formal
;; format. Basically it uses muse-publish. This will convert the note to
;; pdf using Latex. I create a style of muse-publish 'd-latex'.
;; muse-publish-config.el contains the source.
;;(require 'muse-publish-config)		;The name of muse-publish-config.el

(defvar d-w-show-tmp-directory "/tmp/")
(defvar d-w-show-tmp-filename "d-w-show-muse")

(defcustom d-w-show-info
  '(;("KEY_STRING"  . VALUE)
    ("section-type" . nil)
    ("beg"          . nil)
    ("end"          . nil)
    ("title"        . "")
    ("date"         . "")
    ("img-full-path" . "/home/ptmono/.emacs.d/imgs/")
    ("filtered-title" . "\\fancyhead[LO, RE]{\\bf\\large ")
    )
  ""
  :group 'd-worknote
  )

(defcustom d-w-show/replace-string-alist
  '(;("STRING"    . KEY_STRING)
    ("DDocNumber" . "date")
    ("DDocTitle"  . "title")
    ("~/.emacs.d/imgs/" . "img-full-path")
    ("\\fancyhead[LO, RE]{\\bf\\large mr, " . "filtered-title")
    )

  "You can add header or footer with this variable. The muse-mode
  translate only content to tex format. To insert the title and
  the id of document into herder or footer this variable is
  created. 

  Put 'DDocNumber' in the header of latex, d-muse-latex-header.
  The string is definded in d-w-show/replace-string-alist. And
  connect with d-w-show-info. The struct d-w-show-info is
  returned by the function d-w-show-info/get-all with the
  value."
  :group 'd-worknote)

(defun d-w-show-struc/get-value (str struc)
  "To deal d-w-show-info."
  (cdr (assoc str struc)))

(defun d-w-show-struc/set-value (str value struc)
  "To deal d-w-show-info."
  (setcdr (assoc str struc) value))

;; (deftest "test/d-w-show-struc/"
;;   (let* ((aa d-w-show/replace-string-alist)
;; 	 (str "DDocNumber")
;; 	 (value "vvv"))
;;     (d-w-show-struc/set-value str value aa)
;;     (assert-equal value
;; 		  (d-w-show-struc/get-value str aa))))

(defun d-w-show ()
  "Show pdf of current section."
  (interactive)
  (if current-prefix-arg
      (d-w-show/buffer)
    (d-w-show/subsections)))

(defun d-w-show/subsections ()
  (save-window-excursion
    (let* ((info (d-w-show-info/get-all)))
      (d-w-show/do info)
      )))

(defun d-w-show/buffer ()
  (d-w-show-region (point-min) (point-max)))

(defun d-w-show/do (info)
  (save-window-excursion
    (let* ((content (buffer-substring
		     (d-w-show-struc/get-value "beg" info)
		     (d-w-show-struc/get-value "end" info)))
	   (ab-filename-muse (concat d-w-show-tmp-directory d-w-show-tmp-filename ".muse"))
	   (ab-filename-tex  (concat d-w-show-tmp-directory d-w-show-tmp-filename ".tex")))
      (find-file ab-filename-muse)
      (erase-buffer)
      (insert content)
      (save-buffer)
      (kill-buffer)
      (muse-publish-file ab-filename-muse "d-latex")
      (find-file ab-filename-tex)
      (d-w-show/replace-header info)
      (save-buffer)
      (d-latex-test))))

(defun d-w-show-region (beg end)
  (interactive "r")
  (let* ((info (d-w-show-region/get-info)))
    (d-w-show-struc/set-value "beg" beg info)
    (d-w-show-struc/set-value "end" end info)
    (d-w-show/do info)))

(defun d-w-show-region/get-info ()
  "Return the struct d-w-show-info from user input."
  (let* ((result (copy-alist d-w-show-info))
	 (info-struc d-w-show-info))
    (while info-struc
      (let* ((key-value (car info-struc))
	     (key (car key-value))
	     (init-value (cdr key-value))
	     value)
	(setq value (read-string (format "%s: " key) init-value))
	(d-w-show-struc/set-value key value result)

	(setq info-struc (cdr info-struc))))
    result))

(defun d-w-show-info/get-all ()
  "To get current note or section infomation. Returns alist of
  d-w-show-info with values."
  (let* ((len-sec 6)			; To determine section of note
	 sec				; section prefix
	 beg				; the point of beginning
	 end				; the point of end
	 title				; the title of section
	 date				; note contains the date
	 (section-regex "\\(^\\.#[0-9]+\\|^[*\f]+\\|^[@\f]+\\) \\(.+\\)")
	 (result (copy-alist d-w-show-info))
	 )
    (save-excursion
      (re-search-backward section-regex)

      ;;; Let's determine informations
      (forward-line 2)			; We don't need section and under line
      (setq beg (point))
      (if (< len-sec (length (match-string 1)))
	  ;; It's note
	  (progn
	    (setq sec (substring (match-string 1) 0 2))
	    (setq date (substring (match-string 1) 2 12)) ; only note have
	    (setq title (match-string 2))
	    )
	(setq sec (match-string 1))
	(setq title (match-string 2)))
      
      (forward-line)

      ;; We have to distinguish between secion and note. Because it is possible
      ;; that section has subsections. The note does not have that.
      (setq end 
	    (let* ((regex (if date
			      "^\\.#[0-9]+" ; It is note
			    (concat "^" sec " ") ; It is section
			    ))
		   (end (re-search-forward regex nil t)))
	      (if end	  ; Consider the note at the end of buffer
		  ;; End point contains the characters of section. Let's
		  ;; remove that.
		  (- end (+ (length regex) 1))
		(point-max)))))
    
    (d-w-show-struc/set-value "section-type" sec result)
    (d-w-show-struc/set-value "beg" beg result)
    (d-w-show-struc/set-value "end" end result)
    (d-w-show-struc/set-value "title" title result)
    (d-w-show-struc/set-value "date" date result)
    result))

(defun d-w-show/replace-header (info)
  (save-excursion
    (let* ((replace-string-alist d-w-show/replace-string-alist))
      (while (car replace-string-alist)
	(goto-char (point-min))
    
	(setq string (car replace-string-alist))
	(setq from-str (car string))
	(setq value-key (cdr string))	; The key to get value from info
	(setq replace-string-alist (cdr replace-string-alist))

	(setq to-str (cdr (assoc value-key info)))
	;; Fixme: Resolve the 'Warning'.
	(unless to-str
	  (setq to-str ""))
	(replace-string from-str to-str)))))

;; (deftest "test/d-w-show/replace-header"
;;   (with-temp-buffer
;;     (make-local-variable 'd-w-show/replace-string-alist)
;;     (make-local-variable 'd-w-show-info)
;;     (setq d-w-show/replace-string-alist '(("aaa" . "a") ("bbb" . "b")))
;;     (setq d-w-show-info '(("a" . "1") ("b" . "2")))

;;     (insert "aaa\n\n\n\nbbb")
;;     (d-w-show/replace-header d-w-show-info)
;;     (assert-nonnil (progn
;; 		     (goto-char (point-min))
;; 		     (re-search-forward "1")))
;;     (assert-nonnil (progn
;; 		     (goto-char (point-min))
;; 		     (re-search-forward "2")))))



;;; === Inserting with key
;;; --------------------------------------------------------------
(defvar d-worknote-key-insert-alist
  '(("docskip" "#doctest: +SKIP")
    ("docignore" "#doctest: +IGNORE_EXCEPTION_DETAIL")
    ("docellipsis" "#doctest: +ELLIPSIS")
     ;; Alias
    ("skip" "#doctest: +SKIP")
    ("ignore" "#doctest: +IGNORE_EXCEPTION_DETAIL")
    ("ellipsis" "#doctest: +ELLIPSIS")
    ("pdb" "import pdb, sys; pdb.Pdb(stdin=sys.__stdin__,stdout=sys.__stdout__).set_trace()")
    ("docsec" d-worknote/insert/docsec)
    ("ddsec" d-worknote/insert/docsec)
    ("report" d-worknote/insert/report-temp)
    ("tag" d-worknote/insert/tag)
    ("tag-example" (lambda () (d-worknote/insert/tag "example")))
    ("tag-quote" (lambda () (d-worknote/insert/tag "quote")))
    ("example" (lambda () (d-worknote/insert/tag "example")))
    ("quote" (lambda () (d-worknote/insert/tag "quote")))
    ("vspace" d-worknote/insert/latex-vspace)
    ("latex-vspace" d-worknote/insert/latex-vspace)
    ("latex-calendar" d-worknote/insert/latex-calendar)
  ""))

(defun d-worknote/insert ()
  (interactive)
  (let* ((key (completing-read "Choose : " d-worknote-key-insert-alist))
	 (value (car (cdr (assoc key d-worknote-key-insert-alist)))))
    (if (stringp value)
	(insert value)
      (funcall value))))

(defun d-worknote/insert/docsec ()
  (let* ((title (read-string "Section: "))
	 (len (length title))
	 ;(bottom (make-string (+ 4 len) ?\_)))
	 (bottom (make-string (- fill-column 16) ?_)))
    (newline)
    (newline)
    (indent-for-tab-command)
    (insert (concat "### === " title))
    (newline)
    (indent-for-tab-command)
    (insert (concat "### " bottom))
    (newline)
    (indent-for-tab-command)
    (insert ">>> ")))

(defun d-worknote/insert/report-temp ()
  (insert (concat "#" (d-create-citation) "\nREPORT: " )))


(defun d-worknote/insert/tag (&optional tag)
  ""
  (interactive)
  (let* ((tag (if tag
		  tag
		(completing-read "tag: " muse-publish-markup-tags)))
	 (content "aaa"))
    (with-temp-buffer
      (insert-for-yank (current-kill 0))
      (goto-char (point-min))
      (d-worknote/insert/_tag)
      (goto-char (point-min))
      (insert (concat "<" tag ">\n"))
      (goto-char (point-max))
      (insert (concat "\n</" tag ">\n"))
      (setq content (buffer-string))
      )
    (insert content)
    ))

(defun d-worknote/insert/_tag ()
  (while (re-search-forward "\n\n" nil t)
    (previous-line 2)
    (fill-paragraph)
    (next-line))

  (re-search-forward "." nil t)
  (fill-paragraph))

(defun d-worknote/insert/latex-vspace ()
  (insert "<literal>\\vspace{-12pt}</literal>"))

;; TODO: 1304051227, This is not automatically calculate the dates and the
;; days to be marked. Let's insert automatically.
(defun d-worknote/insert/latex-calendar ()
  (insert "
<literal>
\\begin{minipage}[t]{.5\\textwidth}
  September\\\\ 
  \\begin{tikzpicture}
    \\calendar (mycal) [dates=2013-09-01 to 2013-09-last,week list]
    if (weekend,
        between=09-16 and 09-20) [gray]
    if (equals=09-03) [italic]
    if (equals=09-13) [bold];
    \\draw[black] (mycal-2013-09-04) circle (8pt);
    \\node [star,draw] at (mycal-2013-09-10) {};
  \\end{tikzpicture}
\\end{minipage}
</literal>
"))


;;; === Scheduling
;;; --------------------------------------------------------------
(defun d-w-schedule/create-calendar (beg end)
  (interactive "r")
  )
			      


(defun d-cal-tex-cursor-month-landscape (month year &optional n event)
  "The modified function of cal-tex-cursor-month-landscape to
  create landscape calendar.

Use like (d-cal-tex-cursor-month-landscape 5 2013)
"
  (interactive (list (prefix-numeric-value current-prefix-arg)
                     last-nonmenu-event))
  (or n (setq n 1))
  (let* (
         (end-month month)
         (end-year year)
         (cal-tex-which-days '(0 1 2 3 4 5 6))
         (d1 (calendar-absolute-from-gregorian (list month 1 year)))
         (d2 (progn
               (calendar-increment-month end-month end-year (1- n))
               (calendar-absolute-from-gregorian
                (list end-month
                      (calendar-last-day-of-month end-month end-year)
                      end-year))))
         (diary-list (if cal-tex-diary (cal-tex-list-diary-entries d1 d2)))
         (holidays (if cal-tex-holidays (cal-tex-list-holidays d1 d2)))
         other-month other-year small-months-at-start)
    (cal-tex-insert-preamble (cal-tex-number-weeks month year 1) t "12pt")
    (cal-tex-cmd cal-tex-cal-one-month)
    (dotimes (i n)
      (setq other-month month
            other-year year)
      (calendar-increment-month other-month other-year -1)
      (insert (cal-tex-mini-calendar other-month other-year "lastmonth"
                                     "\\cellwidth" "\\cellheight"))
      (calendar-increment-month other-month other-year 2)
      (insert (cal-tex-mini-calendar other-month other-year "nextmonth"
                                     "\\cellwidth" "\\cellheight"))
      (cal-tex-insert-month-header 1 month year month year)
      (cal-tex-insert-day-names)
      (cal-tex-nl ".2cm")
      (if (setq small-months-at-start
                (< 1 (mod (- (calendar-day-of-week (list month 1 year))
                               calendar-week-start-day)
                          7)))
          (insert "\\lastmonth\\nextmonth\\hspace*{-2\\cellwidth}"))
      (cal-tex-insert-blank-days month year cal-tex-day-prefix)
      (cal-tex-insert-days month year diary-list holidays
                           cal-tex-day-prefix)
      (cal-tex-insert-blank-days-at-end month year cal-tex-day-prefix)
      (if (and (not small-months-at-start)
               (< 1 (mod (- (1- calendar-week-start-day)
                            (calendar-day-of-week
                             (list month
                                   (calendar-last-day-of-month month year)
                                   year)))
                         7)))
          (insert "\\vspace*{-\\cellwidth}\\hspace*{-2\\cellwidth}"
                  "\\lastmonth\\nextmonth%
"))
      (unless (= i (1- n))
        (run-hooks 'cal-tex-month-hook)
        (cal-tex-newpage)
        (calendar-increment-month month year 1)
        (cal-tex-vspace "-2cm")
        (cal-tex-insert-preamble
         (cal-tex-number-weeks month year 1) t "12pt" t))))
  (cal-tex-end-document)
  (run-hooks 'cal-tex-hook))



;;; === Window - wmctrl
;;; --------------------------------------------------------------
(defun d-wmctrl/resize (geometry &optional window-title wmctrl_geo_p)
  "Re-geometry for WINDOW-TITLE. See the manual of wmctrl to get
geometry and window-title."
  (let* ((window-title (if window-title
			  window-title
			(frame-parameter (window-frame (frame-selected-window)) 'name)))
	 (cmd-remove-max (concat "wmctrl -r \"" window-title "\" -b remove,maximized_horz"))
	 (cmd (concat "wmctrl -r \"" window-title "\" -e " geometry)))

    (shell-command-to-string cmd-remove-max)
    (shell-command-to-string cmd))
  )

(defun d-wmctrl/title-to-string ()
  (shell-command-to-string "wmctrl -l"))

(defun d-worknote-set-frame-with-chromium ()
  ""
  (interactive)
  (d-wmctrl/resize "0,0,0,1060,1200" "chromium")
  (d-wmctrl/resize "0,1100,0,850,1200")
  )

(defun d-worknote-set-frame-with-firefox ()
  ""
  (interactive)
  (d-wmctrl/resize "0,0,0,1060,1200" "firefox")
  (d-wmctrl/resize "0,1100,0,850,1200")
  )


;;; === plantuml
;;; --------------------------------------------------------------

(defvar d-worknote-plantuml/img-buffer "*plantuml*")
(defvar d-worknote-plantuml/bin "java -jar ~/tmp/plantuml/plantuml.jar")
(defvar d-worknote-plantuml/temp-file "~/tmp/plantuml_temp.txt")
(defvar d-worknote-plantuml/temp-png "~/tmp/plantuml_temp.png")

(defun d-worknote-plantuml/render ()
  (let* ((cmd (concat d-worknote-plantuml/bin " " d-worknote-plantuml/temp-file)))
    (shell-command cmd)))


(defun d-worknote-plantuml/get-text ()
  (save-excursion
    (let* ((start-regexp "^<[A-z]+>")
	   (end-regexp "^</[A-z]+>")
	   (start (progn 
		    (re-search-backward start-regexp nil t)
		    (match-end 0)))
	   (end (progn
		  (re-search-forward end-regexp nil t)
		  (match-beginning 0)))
		
	   (content (buffer-substring start end)))
      content)))
   
(defun d-worknote-plantuml/init ()
  (let* ((content (d-worknote-plantuml/get-text)))
    (d-write-to-file content d-worknote-plantuml/temp-file)
    (d-worknote-plantuml/render)

    (d-buffer/create-new-empty d-worknote-plantuml/img-buffer)
    ))

(defun d-worknote-plantuml/show ()
  "Shows UML image. ex)
<plantuml>
@startuml
User -> (Start)
User -> (Use the application) : A small label

:Main Admin: ---> (Use the application) : This is\nyet another\nlabel
@enduml
</plantuml>
"
  (interactive)
  (d-worknote-plantuml/init)

  (let* ((window (d-window-open-other-window d-worknote-plantuml/img-buffer))
	 (current-window (selected-window)))
    (select-window window)
    (insert-file-contents d-worknote-plantuml/temp-png)
    (image-mode)
    (select-window current-window)))

(defun d-worknote-plantuml/gimp ()
  (interactive)
  (start-process-shell-command "plantuml_gimp" nil (concat "gimp " d-worknote-plantuml/temp-png)))

(defun d-worknote-plantuml/save-to-imgs ()
  "Save d-worknote-plantuml/temp-png to ~/imgs."
  (interactive)
  (let* ((target-name (concat (d-citation-image/get-new-image-name-without-extension) ".png")))
  (shell-command-to-string (concat "cp " d-worknote-plantuml/temp-png " " target-name))))


(provide 'd-worknote2)

