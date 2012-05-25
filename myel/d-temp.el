;;; Explanation
;; d-worknote2.el contains "show". It will more useful.


;;; Change Log

;; 1107111450 Added d-print-replace-string-alist



(defvar d-temp-title-head 
  "
%%% for define


\\documentclass[12pt]{article}
\\oddsidemargin    -.25in
\\evensidemargin   -.25in
\\textwidth        7.00in
\\topmargin       -0.75in
\\textheight      10.00in

%%% For korean language

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

%%% For heading
\\usepackage{fancyhdr}
\\pagestyle{fancy}
\\renewcommand{\\headrulewidth}{0pt} %% To remove line
%\\fancyhead[r]{fdksfskdl}
\\rhead{\\bf DocNumber}
%\\fancyfoot[r]{\\thepage}
\\fancyfoot[]{}
\\begin{document}
\\parindent       0ex % This is left-side indent

\\setlength{\\tabcolsep}{0pt}" "DocNumber is the string of right header.")


(defvar d-temp-title-title
"%--> The part of Title
  \\begin{tabular}{c}
    \\rule{0pt}{100pt} \\bf\\Huge DocTitle\\\\
  \\end{tabular}" "DocTitle is the string of title. Replace that." )

(defvar d-temp-title-purpose
"%--> The part of Purpose
\\begin{tabular}{lll}
  \\rule{0pt}{0pt} & & \\\\
  \\rule{100pt}{0pt} & & \\\\
  \\hspace{30pt}\\rule{0ex}{4ex}\\bf \\large Purpose :~~ & &\\\\\\\\
  \\hspace{30pt}\\begin{tabular}{l}
 DocPurpose
  \\end{tabular} && \\\\
%  \\rule{0pt}{10pt} & & \\\\
%  \\rule{0ex}{4ex}\\bf Link &:~~& DocLink	\\\\
%  \\rule{0ex}{4ex}\\bf \\large Contents &:~~ & DocContents \\\\
\\end{tabular}" "Replace DocPurpose for purpose")


(defvar d-temp-title-abstract
"%--> The part of Title
\\begin{abstract}
  DocAbstract
\\end{abstract}" "Replace DocAbstract for abstract")


(defvar d-temp-title-end
"\\end{document}")


(defvar d-temp-title-dir "~/tmp/" "The directory is used to compile tex file.")
(defvar d-temp-title-filename "title")
(defvar d-temp-title-buffer "*LaTex*")


(defvar d-print-replace-string-alist
  '(("$" "\\\\\\\\")
    ("_" "$\\\\_$")
    )
  "The list is used to replace the latex characters.")


(defun d-temp-title(&optional title purpose abstract docnumber)
  "Returns the latex doc.

TITLE is the string. It will be the title.

PURPOSE is the string. It is the content of purpose.

ABSTRACT is the string. It is the content of abstract.
"
  (when (not title)
      (setq title (d-tex-fill-paragraph-for-latex (read-string "Input title: ") 80))
      (setq purpose (d-tex-fill-paragraph-for-latex (read-string "Input purpose: ") 80))
      (setq abstract (d-tex-fill-paragraph-for-latex (read-string "Input abstract: ") 70))
      (setq docnumber (read-string "Input docNumber: " (d-current-time))))
  (get-buffer-create d-temp-title-buffer)
  (switch-to-buffer d-temp-title-buffer)
  (erase-buffer)
  (unless (equal docnumber "")
    (d-tex-insert-body-with-replacement d-temp-title-head "DocNumber" docnumber)
    (newline 2))
  (unless (equal title "")
    (d-tex-insert-body-with-replacement d-temp-title-title "DocTitle" title)
    (newline 2))
  (unless (equal purpose "")
    (d-tex-insert-vspace 30)
    (newline 2)
    (d-tex-insert-body-with-replacement-with-lines d-temp-title-purpose "DocPurpose" purpose)
    (newline 2))
  (unless (equal purpose "")
    (d-tex-insert-vspace 100)
    (newline 2))
  (unless (equal purpose "")
    (d-tex-insert-body-with-replacement d-temp-title-abstract "DocAbstract" abstract)
    (newline 2))
  (insert d-temp-title-end))

(defun d-temp-title-print()
  (interactive)
   (d-temp-title)
   (save-window-excursion
     (switch-to-buffer d-temp-title-buffer)
     (write-file (concat d-temp-title-dir d-temp-title-filename ".tex"))
     (save-buffer)
     (shell-command-to-string (concat "latex " d-temp-title-dir d-temp-title-filename ".tex"))
     (shell-command-to-string (concat "dvipdfmx " d-temp-title-dir d-temp-title-filename ".dvi"))
     ;(shell-command-to-string (concat "lpr -o Resolution=300x300dpi,PageSize=A4 " d-temp-title-dir d-temp-title-filename ".pdf"))
     (shell-command-to-string (concat "xpdf " d-temp-title-dir d-temp-title-filename ".pdf"))
     ))
     ;(kill-buffer)))

(defun d-tex-insert-body-with-replacement(body string new)
  "The function will replace the string and insert that.
BODY is the content. STRING is targeted string. NEW is the string
replaced."
  (with-temp-buffer
    (insert body)
    (goto-char (point-min))
    (while (search-forward string nil t)
      (replace-match new nil t))
    (setq body (buffer-string)))
  (insert body))


(defun d-tex-insert-body-with-replacement-with-lines(body string new &optional separator)
  ""
  (unless separator
    (setq separator "\n"))
  (setq new (split-string new separator))
  (dolist (xx new)
    (d-tex-insert-body-with-replacement body string xx)
    (newline 2)))
  
    

(defun d-tex-insert-vspace(pt)
  (insert "\\vspace*{" (number-to-string pt) "pt}"))


(defun d-tex-fill-paragraph-for-latex (string column)
  (with-temp-buffer
    (insert string)
    (let* ((fill-column column))
      (fill-region (point-max) (point-min))
      (goto-char (point-min))
      (while (search-forward "\n" nil t)
	(replace-match "\\\\" nil t))
      (buffer-string))))


;;; === Print region with latex
;;; --------------------------------------------------------------
(defvar d-print-region-latex-temp
  "
%%% for define


\\documentclass[12pt]{article}
\\oddsidemargin    -.25in
\\evensidemargin   -.25in
\\textwidth        7.00in
\\topmargin       -0.75in
\\textheight      10.00in

%%% For korean language

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

%%% For heading
\\usepackage{fancyhdr}
\\pagestyle{fancy}
\\renewcommand{\\headrulewidth}{0pt} %% To remove line

\\begin{document}
\\parindent       0ex % This is left-side indent

\\setlength{\\tabcolsep}{0pt}

\\vspace*{30pt}

\\noindent
DDCONTENTS

\\vspace*{100pt}

%--> The part of Title
\\end{document}" "")


(defun d-print-region-create-tex (body string new)
  (let* (result)
    (with-temp-buffer
      (insert body)
      (goto-char (point-min))
      (while (search-forward string nil t)
	(replace-match new nil t))
      (setq result (buffer-substring (point-min) (point-max))))
    result))


(defun d-print-region (start end)
  (interactive
   (list (region-beginning) (region-end)))
  (let* ((str (buffer-substring start end))
	 (str-used (d-print-region-convert str))
	 (str-tex (d-print-region-create-tex d-print-region-latex-temp "DDCONTENTS" str-used)))
    (save-window-excursion
      (switch-to-buffer d-temp-title-buffer)
      (erase-buffer)
      (insert str-tex)
      (write-file (concat d-temp-title-dir d-temp-title-filename ".tex"))
      (save-buffer)
      (shell-command-to-string (concat "pdflatex " d-temp-title-dir d-temp-title-filename ".tex"))
      ;; (shell-command-to-string (concat "lpr -o Resolution=300x300dpi,PageSize=A4 " d-temp-title-dir d-temp-title-filename ".pdf")))))
      ;; (shell-command-to-string (concat "cupsdoprint " d-temp-title-dir d-temp-title-filename ".pdf")))))
      (shell-command-to-string (concat "evince " d-temp-title-dir d-temp-title-filename ".pdf&")))))


(defun d-print-region-convert (str)
  (let* ((p-alist d-print-replace-string-alist)
	 result)
    (with-temp-buffer
      (insert str)
      (while (car p-alist)
	(goto-char (point-min))
	(replace-regexp (car (car p-alist)) (cdr (car p-alist)))
	(setq p-alist (cdr p-alist)))
      (setq result (buffer-substring (point-min) (point-max))))
    result))



