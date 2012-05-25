(require 'cal-tex)


;;; main core
(defun d-cal-tex-get-vevent (filename date)
  "Returns a list of events in DATE. FILENAME is the abpath of
ics file."

  (let* ((dtstart (concat "dtstart.*" date))
	 result ; value returned
	 )

    (save-excursion
      (find-file filename)
      (goto-char 0)
      (while (re-search-forward dtstart nil t)
	(setq result (cons (buffer-substring (d-cal-tex-point-begin) (d-cal-tex-point-end)) result))
	)
      (kill-buffer))
    result))


(defun d-cal-tex-get-vevent-with-time (filename date)
  "Returns a lists of events in DATE. The lists is a form '(alist
list). (((\"001500\" . content) ...) (content ...)). This
function is based on d-cal-tex-get-vevent."
  (let* ((cont-list (d-cal-tex-get-vevent filename date))
	 cont
	 time-check ; will be nil or time
	 time-alist
	 todo-list
	 result)
    (while (car cont-list)
      (setq cont (car cont-list))
      (if (setq time-check (d-cal-tex-get-vevent-with-time-check cont))
	  (setq time-alist (cons (cons time-check cont) time-alist))
	(setq todo-list (cons cont todo-list)))
      (setq cont-list (cdr cont-list)))
    
    (setq result (list time-alist todo-list))
    result))
	
      

     
(defun d-cal-tex-get-vevent-with-time-check (str)
  "If no time stamp, will be nil."
  ;;TODO more regexp
  (let* (poi)
    (setq poi (string-match "^DTSTART;TZID[^T]*T\\([0-9]\\{4\\}\\)" str))
    (if poi
	(match-string 1 str)
      nil)))


(defun d-cal-tex-get-vevent-dates (filename dates)
  "Returns evnets in DATES. FILENAME is the abpath of ics file.
DATES is a list of date")

(defun d-cal-tex-get-vevent-weeks (filename date &optional week-count)
  "Return a list of event"
)


(defun d-cal-tex-header (content header)
  "Returns the value of header. CONTENT is a string of icalendar
format which will be returned from d-cal-tex-get-vevent as a
element of list. If content do not has header, then returns nil"
  (let* ((header (upcase header))
	 (regexp (concat "^" header ".*:\\(.*\\)")))
    (string-match regexp content)
    (match-string 1 content))
  )




(defun d-cal-tex-point-begin ()
  (re-search-backward "^BEGIN:"))

(defun d-cal-tex-point-end ()
  (re-search-forward "^END:")
  (end-of-line)
  (point))



;;; cal-tex related

(defvar d-cal-tex-ics-filename "/media/data/0-files/korganizer/life.ics")

(defun d-cal-tex-change-ics-filename ()
  (interactive)
  (let* ((filename (read-file-name "What is abname of ics" "/media/data/0-files/korganizer/")))
    (setq d-cal-tex-ics-filename filename)))

; Important headers is
; - DTSTART;TZID=Asia/Seoul:20100512T011500
; - SUMMARY:22222222222 ---> It is title
; - DESCRIPTION:texttexttext


(defun d-cal-tex-day ()
  "Print today's todo list"
  (interactive)
  )

(defun d-cal-tex-week ()
  "Print this week's todo list"
  (interactive)
  )


(defun d-cal-tex-create-latex-day (date)
)

(defvar d-cal-tex-preamble-korean
  "%%% For korean language
\\usepackage[hangul]{kotex}
\\usepackage[default]{dhucs-interword}
\\usehangulfontspec{ut}
\\usepackage[hangul]{dhucs-setspace}
\\usepackage{dhucs-gremph}
\\usepackage{ifpdf}
\\ksnamedef{abstractname}{Abstract}
\\ifpdf
  \\usepackage[unicode,pdftex,colorlinks]{hyperref}
  \\input glyphtounicode\\pdfgentounicode=1
\\else
  \\usepackage[unicode,dvipdfm,colorlinks]{hyperref}
\\fi

")


(defvar d-cal-tex-buffer-name "d-cal-tex.tex")

(defun d-cal-tex-get-buffer ()
  (set-buffer (get-buffer-create d-cal-tex-buffer-name)))


(defun d-cal-tex-preamble (&optional args)
  ""
  (d-cal-tex-get-buffer)
  (insert (format "\\documentclass%s{article}\n"
                  (if (stringp args)
                      (format "[%s]" args)
                    "")))
  ;(if (stringp cal-tex-preamble-extra)
  ;    (insert cal-tex-preamble-extra "\n"))
  (insert d-cal-tex-preamble-korean)
  (insert "\\hbadness 20000
\\hfuzz=1000pt
\\vbadness 20000
\\lineskip 0pt
\\marginparwidth 0pt
\\oddsidemargin  -2cm
\\evensidemargin -2cm
\\marginparsep   0pt
\\topmargin      0pt
\\textwidth      7.5in
\\textheight     9.5in
\\newlength{\\cellwidth}
\\newlength{\\cellheight}
\\newlength{\\boxwidth}
\\newlength{\\boxheight}
\\newlength{\\cellsize}
\\newcommand{\\myday}[1]{}
\\newcommand{\\caldate}[6]{}
\\newcommand{\\nocaldate}[6]{}
\\newcommand{\\calsmall}[6]{}
%
\\renewcommand{\\tabcolsep}{0cm} % babular will has 0 cell space(?).
\\renewcommand{\\arraystretch}{1} % 글자의 아래위 간격. 글자칸으로
\\def\\LangTable{14.5cm} % 가로테이블 길이
\\def\\LangTableChar{15pt} % today' 칸 높이
%
"))

;; Hack d-cal-tex-cursor-today. The function generates today texpage.
(defun d-cal-tex-cursor-today (&optional n event)
  (interactive (list (prefix-numeric-value current-prefix-arg)
                     last-nonmenu-event))
  (or n (setq n 1))
  (setq event (d-cal-tex-get-vevent-with-time "/media/data/0-files/korganizer/life.ics" "20100512"))
  (let ((date (calendar-absolute-from-gregorian
	       (calendar-current-date))))
    (d-cal-tex-preamble "12pt")
    (cal-tex-cmd "\\textwidth 6.5in")
    (cal-tex-cmd "\\textheight 10.5in")
    (cal-tex-b-document)
    (cal-tex-cmd "\\pagestyle{empty}")
    (d-cal-tex-daily-page (calendar-gregorian-from-absolute date) event)
    (d-cal-tex-end-document)
    ))

(defun d-cal-tex-end-document ()
  "Based on the function cal-tex-end-document."
  (cal-tex-e-document)
  (latex-mode)
  (pop-to-buffer d-cal-tex-buffer-name)
  (goto-char (point-min))
  ;; FIXME auctex equivalents?
  (cal-tex-comment
   (format "\tThis buffer was produced by cal-tex.el.
\tTo print a calendar, type
\t\tM-x tex-buffer RET
\t\tM-x tex-print  RET")))



(defun d-cal-tex-daily-page (date event-list)
  "The function d-cal-tex-daily-page creates time-line part. I
want to modify that to be the form I want."
  (let* ((month-name (cal-tex-month-name (calendar-extract-month date)))
        (i (1- cal-tex-daily-start))
	;; The schedules that time related.
	(time-event-alist (car event-list))
	;; Let's sort time
	(time-event-keys-list (d-cal-tex-sort-alist-keys time-event-alist))
	;; The schedules with no time.
	(todo-event-list (car (cdr event-list)))
	summary
	description
	description-list
        hour)
	
    ;------------- up
    (cal-tex-banner "cal-tex-daily-page")
    (cal-tex-b-makebox "4cm" "l")
    (cal-tex-b-parbox "b" "3.8cm")
    (cal-tex-rule "0mm" "0mm" "2cm")
    (cal-tex-Huge (number-to-string (calendar-extract-day date)))
    (cal-tex-nl ".5cm")
    (cal-tex-bf month-name )
    (cal-tex-e-parbox)
    (cal-tex-hspace "1cm")
    (cal-tex-scriptsize (eval cal-tex-daily-string))
    (cal-tex-hspace "3.5cm")
    (cal-tex-e-makebox)
    (cal-tex-hfill)
    (cal-tex-b-makebox "4cm" "r")
    (cal-tex-bf (cal-tex-LaTeXify-string (calendar-day-name date)))
    (cal-tex-e-makebox)
    (cal-tex-nl)
    (cal-tex-hspace ".4cm")
    (cal-tex-rule "0mm" "16.1cm" "1mm")
    (cal-tex-nl ".1cm")
    ;---------------- end up

    (cal-tex-cmd "\\noindent")

    ;; time schedule
    (cal-tex-cmd "% Start time schedule")
    (d-cal-tex-b-tabular nil "p{1.2cm}p{.8cm}p{\\LangTable}")
    (cal-tex-cmd " & & \\rule{\\LangTable}{1ex}\\\\")
    (while (setq hour (car time-event-keys-list)) ; hour is number. not string

      (setq hour (number-to-string hour))
      ;;Fixed "0015" will be 15 that can not assoc time-event-alist. Conside
      ;;also "0005".
      (let* (count)
	(when (> 4 (setq count (length hour)))
	  (setq count (- 4 count))
	  (setq hour (d-libs-string-create-zero-prefix hour count))))
      
      (let* ((ics (cdr (assoc hour time-event-alist))))
	;; Let's extract infos.
	(setq summary (d-cal-tex-header ics "summary"))
	(if (setq description (d-cal-tex-header ics "description"))
	    (setq description-list (cons description description-list))
	  (setq description-list (cons "" description-list))))

      ;; Write to tex buffer
      (d-cal-tex-tabular-item-time hour summary)
      ;; Init
      (setq time-event-keys-list (cdr time-event-keys-list))
      (setq summary nil)
      (setq description nil))
    (d-cal-tex-e-tabular)

    ;; todo schedule
    (cal-tex-cmd "% Start todo schedule")
    (cal-tex-cmd "\\\\\\vspace{.7cm}")
    (d-cal-tex-b-tabular nil "p{1.2cm}p{.8cm}p{\\LangTable}")
    (while todo-event-list

      ;; Let's extract infos
      (let* ((ics (car todo-event-list)))
	(setq summary (d-cal-tex-header ics "summary"))
	(if (setq description (d-cal-tex-header ics "description"))
	    (setq description-list (cons description description-list))
	  (setq description-list (cons "" description-list))))

      ;; Write to tex buffer
      (d-cal-tex-tabular-item-todo summary)
      ;; Init
      (setq todo-event-list (cdr todo-event-list))
      (setq summary nil)
      (setq description nil))
    (d-cal-tex-e-tabular)

    (cal-tex-hfill)
    (insert (cal-tex-mini-calendar
             (calendar-extract-month (cal-tex-previous-month date))
             (calendar-extract-year (cal-tex-previous-month date))
             "lastmonth" "1.1in" "1in"))
    (insert (cal-tex-mini-calendar
             (calendar-extract-month date)
             (calendar-extract-year date)
             "thismonth" "1.1in" "1in"))
    (insert (cal-tex-mini-calendar
             (calendar-extract-month (cal-tex-next-month date))
             (calendar-extract-year (cal-tex-next-month date))
             "nextmonth" "1.1in" "1in"))
    (insert "\\hbox to \\textwidth{")
    (cal-tex-hfill)
    (insert "\\lastmonth")
    (cal-tex-hfill)
    (insert "\\thismonth")
    (cal-tex-hfill)
    (insert "\\nextmonth")
    (cal-tex-hfill)
    (insert "}")
    (cal-tex-banner "end of cal-tex-daily-page")))

(defun d-cal-tex-sort-alist-keys(alist)
  "Returns a list that is sorted keys of alist."
  (let* ((bb alist)
	 element
	 slist)
    (while (setq element (car bb))
      (setq slist (cons (string-to-number (car element)) slist))
      (setq bb (cdr bb)))
    (sort slist '<)))




;\\begin{tabular}{lll}
;  \\rule{0pt}{0pt} & & \\\\
;  \\rule{100pt}{0pt} & & \\\\
;  \\hspace{30pt}\\rule{0ex}{4ex}\\bf \\large Purpose :~~ & &\\\\\\\\
;  \\hspace{30pt}\\begin{tabular}{l}
; DocPurpose
;  \\end{tabular} && \\\\


(defun d-cal-tex-b-tabular (pos cols)
  "Insert a rule with parameters LOWER WIDTH HEIGHT."
  (insert "\\begin{tabular}" (if pos (concat "[" pos "]") "") "{" cols "}")
  (newline))


(defun d-cal-tex-e-tabular ()
  (cal-tex-comment)
  (insert "\\end{tabular}")
  (newline)
  (cal-tex-comment "end tabular"))

(defun d-cal-tex-tabular-item-time(r1 r3)
  (let* ((str (concat r1 " & & " r3 "\\rule{0pt}{\\LangTableChar}\\\\\\cline{3-3}")))
    (insert str)
    (newline)))

(defun d-cal-tex-tabular-item-todo(r3)
  (let* ((str (concat " & & " r3 "\\rule{0pt}{\\LangTableChar}\\\\\\cline{3-3}")))
    (insert str)
    (newline)))
  