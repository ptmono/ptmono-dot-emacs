;;; === How to add markup strings ?
;;; --------------------------------------------------------------
;; Let's see an example. We want to chage "^@ section" to work. We will do
;; that
;;  1. Add the regexp into d-muse-publish-markup-regexps
;;  2. Add the function into d-muse-latex-markup-functions
;;  3. Create the function
;; The style specify the regexp and the function alist. The style is
;; defined by the function 'muse-define-style.


;;; === Test environment
;;; --------------------------------------------------------------
;; Use elispWorknote.el#1212210233

(require 'planner-publish)

;;; === Define the style
;;; --------------------------------------------------------------
(muse-define-style "d-html"
                   :suffix    'muse-html-extension
                   :regexps   'muse-html-markup-regexps
                   :functions 'muse-html-markup-functions
                   :strings   'muse-html-markup-strings
                   :tags      'muse-html-markup-tags
                   :specials  'muse-xml-decide-specials
                   :before    'muse-html-prepare-buffer
                   :before-end 'muse-html-munge-buffer
                   :after     'muse-html-finalize-buffer
                   :header    'muse-html-header
                   :footer    'muse-html-footer
                   :style-sheet 'd-muse-html-style-sheet
                   :browser   'muse-html-browse-file)



(muse-derive-style "d-html-derive" "html"
		   :suffix    'muse-html-extension
                   :regexps   'd-muse-publish-markup-regexps
		   ;; functions for regexps
                   :functions 'd-muse-publish-markup-functions
                   :tags      'd-planner-publish-markup-tags
                   :specials  'planner-publish-decide-specials
                   :strings   'd-muse-html-markup-strings
                   :before    'planner-publish-prepare-buffer
                   :after     'planner-publish-finalize-buffer
                   :header    'd-muse-html-header
                   :footer    'd-muse-html-footer
		   :style-sheet 'd-muse-html-style-sheet)

(muse-define-style "d-latex"
                   :suffix    'muse-latex-extension
                   :regexps   'd-muse-publish-markup-regexps
                   :functions 'd-muse-latex-markup-functions
                   :tags      'd-planner-publish-markup-tags
                   :strings   'muse-latex-markup-strings
                   :specials  'muse-latex-decide-specials
                   :before-end 'muse-latex-munge-buffer
                   :header    'd-muse-latex-header
                   :footer    'muse-latex-footer
                   :browser   'find-file)

;; (add-to-list 'muse-publish-markup-regexps (quote (3500 "^\\([A-Z]+\\): " 0 dtag)))
;; (add-to-list 'muse-publish-markup-functions (quote (dtag . d-muse-publish-markup-dtag)))

;    (begin-dl        . "\\begin{description}\n")
;    (end-dl          . "\n\\end{description}")
;    (begin-ddt       . "\\item[")
;    (end-ddt         . "] \\mbox{}\n"))


;;; === For publish
;;; --------------------------------------------------------------
(unless (d-windowp)
  ;; The file link uses this extension.
  (setq muse-xhtml-extension ".html")
  (with-temp-buffer
    (insert-file-contents "/home/ptmono/plans/sachaHeader")
    (setq planner-xhtml-header (buffer-substring (point-min) (point-max))))
  
  (with-temp-buffer
    (insert-file-contents "/home/ptmono/plans/sachaFooter")
    (setq planner-xhtml-footer (buffer-substring (point-min) (point-max))))
  )

(defcustom d-muse-publish-markup-regexps
  '(;; Remove subsection underline
    (1030 "^ +=+\n" 0 "")
    (1040 "^ +-+\n" 0 "")
    ;; In planner-mode start-->
    ;; There is planner-publish-markup-regexps. We include that.
    (1275 "^#\\([A-C]\\)\\([0-9]*\\)\\s-*\\([_oXDCP]\\)\\s-*\\(.+\\)" 0 task)
    (1280 "^\\.#[0-9]+\\s-*" 0 note)
    (3200 planner-date-regexp 0 link)
    ;; <--In planner-mode end
    (1999"^Footnotes:?\\s-*" 0 d-fn-sep)
    (2099 "\\[\\([1-9][0-9]*\\)\\]" 0 d-footnote)
    (7501 "^\\([A-Z]+\\): " 0 dtag)
    ;;(7508 "^\\(\\@+\\)\\s-+" 0 d-note-section)
    (8508 "^\\(\\@+\\)\\s-+" 0 dsection)
    )
  "List of markup rules for publishing my muse pages.
For more on the structure of this list, see `muse-publish-markup-regexps'."
  :type '(repeat (choice
                  (list :tag "Markup rule"
                        integer
                        (choice regexp symbol)
                        integer
                        (choice string function symbol))
                  function))
  :group 'd-muse-publish)

(defcustom d-muse-publish-markup-functions
  '((task . planner-publish-markup-task)
    (note . planner-publish-markup-note)
    (dtag . d-muse-publish-markup-dtag)
    (d-fn-sep . d-muse-publish-markup-fn-sep)
    (d-footnote  . d-muse-html-markup-footnote)
    )
    "An alist of style types to custom functions for that kind of text.
For more on the structure of this list, see
`muse-publish-markup-functions'."
  :type '(alist :key-type symbol :value-type function)
  :group 'd-muse-publish)


(defcustom d-planner-publish-markup-tags
  '(("nested-section" t nil t planner-publish-nested-section-tag)
    ("title" t t nil planner-publish-title-tag)
    ("content" t nil nil planner-publish-content-tag)
    ("diary-section" t nil nil planner-publish-diary-section-tag)
    ("tasks-section" t nil nil planner-publish-tasks-section-tag)
    ("notes-section" t nil nil planner-publish-notes-section-tag)
    ("notes"   nil nil nil planner-publish-notes-tag)
    ("past-notes" nil t nil planner-publish-past-notes-tag)
    ("task"    t t nil planner-publish-task-tag)
    ("note"    t t nil planner-publish-note-tag))
  "A list of tag specifications, for specially marking up PLANNER.
See `muse-publish-markup-tags' for more information."
  :type '(repeat (list (string :tag "Markup tag")
                       (boolean :tag "Expect closing tag" :value t)
                       (boolean :tag "Parse attributes" :value nil)
                       (boolean :tag "Nestable" :value nil)
                       function))
  :group 'planner-publish)


;;; === For html
;;; --------------------------------------------------------------
(defcustom d-muse-html-header
  "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\">
<html>
  <head>
    <title><lisp>
  (concat (muse-publishing-directive \"title\")
          (let ((author (muse-publishing-directive \"author\")))
            (if (not (string= author (user-full-name)))
                (concat \" (by \" author \")\"))))</lisp></title>
    <meta name=\"generator\" content=\"muse.el\">
    <meta http-equiv=\"<lisp>muse-html-meta-http-equiv</lisp>\"
          content=\"<lisp>muse-html-meta-content-type</lisp>\">
    <lisp>
      (let ((maintainer (muse-style-element :maintainer)))
        (when maintainer
          (concat \"<link rev=\\\"made\\\" href=\\\"\" maintainer \"\\\">\")))
    </lisp><lisp>
      (muse-style-element :style-sheet muse-publishing-current-style)
    </lisp>
  </head>
  <body>
    <h1><lisp>
  (muse-publishing-directive \"title\")
  </lisp></h1>
    <!-- Page published by Emacs Muse begins here -->\n"
  "muse-html-header is modifed."
  :type 'string
  :group 'd-muse-html)

(defcustom d-muse-html-footer "
<!-- Page published by Emacs Muse ends here -->
  </body>
</html>\n"
  "muse-html-footer is modified."
  :type 'string
  :group 'd-muse-html)


(defcustom d-muse-html-markup-strings
  '((planner-begin-nested-section . "<div class=\"section\">")
    (planner-end-nested-section   . "</div>")
    (planner-begin-title         . "<h%s>")
    (planner-end-title           . "</h%s>")
    (planner-begin-content       . "<div class=\"content\">")
    (planner-end-content         . "</div>")
    (planner-begin-body          . "<div class=\"body\">")
    (planner-end-body            . "</div>")
    (planner-begin-diary-section . "<div id=\"diary\" class=\"section\">")
    (planner-end-diary-section   . "</div>")
    (planner-begin-task-section  . "<div id=\"tasks\" class=\"section\">")
    (planner-end-task-section    . "</div>")
    (planner-begin-task-body     . "<ul class=\"body\">")
    (planner-end-task-body       . "</ul>")
    (planner-begin-note-section  . "<div id=\"notes\" class=\"section\">")
    (planner-end-note-section    . "</div>")
    (planner-begin-task   . "<li class=\"task\"><span class=\"%s\"><span class=\"%s\" id=\"%s\">%s</span>")
    (planner-end-task     . "</span></li>")
    (planner-begin-note   . "<div class=\"note\"><a name=\"%s\"></a><span class=\"anchor\">%s</span>")
    (planner-end-note     . "</div>")
    (planner-begin-note-details . "<div class=\"details\"><span class=\"timestamp\">%s</span>")
    (planner-end-note-details . "</div>")
    (planner-begin-note-link . " <span class=\"link\">")
    (planner-end-note-link . "</span>")
    (planner-begin-note-categories . " <span class=\"categories\">")
    (planner-end-note-categories . "</span>"))

  "Strings used for marking up text as HTML.
These cover the most basic kinds of markup, the handling of which
differs little between the various styles.

If a markup rule is not found here, `muse-html-markup-strings' is
searched."
  :type '(alist :key-type symbol :value-type string)
  :group 'd-muse-publish)


(defcustom d-muse-html-style-sheet
    "<style type=\"text/css\">
body {
  background: white; color: black;
  margin-left: 3%; margin-right: 7%;
  width:630px;
  border-style:solid;
  border-width:1px;
  padding:15px 19px 5px;
  
}

p { margin-top: 1% }
p.verse { margin-left: 3% }

.example { margin-left: 3% }

h1 {
  margin-top: 25px;
  margin-bottom: 10px;
}

h2 {
  margin-top: 65px;
  margin-bottom: 38px;
  margin-left: -20px;
}
h3 {
  margin-top: 38px;
  margin-bottom: 24px;
}

h4 {
  margin-top: 38px;
  margin-bottom: 14px;
}    

pre {
  background: #3c3c3c; color: white;
  border-style:solid;
  border-width:1px;
  border-color: blue;
  padding: 15px 19px 5px;
  font-size: 10px;
  overflow: auto;
}

blockquote {
  font-size: 10px;
}

p.image img {
  max-width: 630px;
}

table.muse-table { margin: 0; font-size: 11px;
                   border-collapse: collapse;
                   background: #e2effa;
                   border: 1px solid #aadeed; }

table.muse-table tbody td { border: 1px solid #ccdeed; }

/* nested sections */
.section { margin: 0; padding: 10px;
           margin-bottom: 15px;
           font-size: 12px; }

.section .section { margin: 0; margin-left: 5px;
                    font-size: 11px; }

.title { margin: 0; padding; 0 }

/* Diary section */
#diary p { margin-top: 1em; }

/* Tasks section */
.task .A { color: red }
.task .B { color: green }
.task .C { color: navy }
.task .done      { color: gray; text-decoration: line-through; }
.task .cancelled { color: gray; text-decoration: italic; }

/* Notes section */
.note { margin-top: 1.5em; }
.note .anchor  { float: left; margin-right: 5px; }
.note .details { margin-top: .5em; }

</style>"
    "Store your stylesheet definitions here.
This is used in `muse-html-header'.
You can put raw CSS in here or a <link> tag to an external stylesheet.
This text may contain <lisp> markup tags.

An example of using <link> is as follows.

<link rel=\"stylesheet\" type=\"text/css\" charset=\"utf-8\" media=\"all\" href=\"/default.css\">"
  :type 'string
  :group 'd-muse-publish)


;; To modify footnote modify muse-publish-markup-fn-sep and
;; d-muse-html-markup-footnote
(defun d-muse-publish-markup-fn-sep ()
  (delete-region (match-beginning 0) (match-end 0))
  ;(muse-insert-markup (muse-markup-text 'fn-sep)))
  )


(defun d-muse-html-markup-footnote ()
  (cond
   ((get-text-property (match-beginning 0) 'muse-link)
    nil)
   ((= (muse-line-beginning-position) (match-beginning 0))
    (prog1
        (let ((text (match-string 1)))
          (muse-insert-markup
           (concat "<p class=\"footnote\">"
                   "<a class=\"footnum\" name=\"fn." text
                   "\" href=\"#fnr." text "\">"
                   text ".</a>")))
      (save-excursion
        (save-match-data
          (let* ((beg (goto-char (match-end 0)))
                 (end (and (search-forward "\n\n" nil t)
                           (prog1
                               (copy-marker (match-beginning 0))
                             (goto-char beg)))))
            (while (re-search-forward (concat "^["
                                              muse-regexp-blank
                                              "]+\\([^\n]\\)")
                                      end t)
              (replace-match "\\1" t)))))
      (replace-match "")))
   (t (let ((text (match-string 1)))
        (muse-insert-markup
         (concat "<sup><a class=\"footref\" name=\"fnr." text
                 "\" href=\"#fn." text "\">"
                 text "</a></sup>")))
      (replace-match ""))))

(defun d-muse-publish-markup-footnote ()
  "Scan ahead and snarf up the footnote body."
  (cond
   ((get-text-property (match-beginning 0) 'muse-link)
    nil)
   ((= (muse-line-beginning-position) (match-beginning 0))
    "")
   (t
    (let ((footnote (save-match-data
                      (string-to-number (match-string 1))))
          (oldtext (match-string 0))
          footnotemark)
      (delete-region (match-beginning 0) (match-end 0))
      (save-excursion
        (when (re-search-forward (format "^\\[%d\\]\\s-+" footnote) nil t)
          (let* ((start (match-beginning 0))
                 (beg (goto-char (match-end 0)))
                 (end (save-excursion
                        (if (search-forward "\n\n" nil t)
                            (copy-marker (match-beginning 0))
                          (goto-char (point-max))
                          (skip-chars-backward "\n")
                          (point-marker)))))
            (while (re-search-forward
                    (concat "^[" muse-regexp-blank "]+\\([^\n]\\)")
                    end t)
              (replace-match "\\1" t))
            (let ((footnotemark-cmd (muse-markup-text 'footnotemark))
                  (footnotemark-end-cmd (muse-markup-text 'footnotemark-end)))
              (if (string= "" footnotemark-cmd)
                  (setq footnotemark
                        (concat (muse-markup-text 'footnote)
                                (muse-publish-escape-specials-in-string
                                 (buffer-substring-no-properties beg end)
                                 'footnote)
                                (muse-markup-text 'footnote-end)))
                (setq footnotemark (format footnotemark-cmd footnote
                                           footnotemark-end-cmd))
                (unless muse-publish-footnotes
                  (set (make-local-variable 'muse-publish-footnotes)
                       (make-vector 256 nil)))
                (unless (aref muse-publish-footnotes footnote)
                  (setq footnotemark
                        (concat
                         footnotemark
                         (concat (format (muse-markup-text 'footnotetext)
                                         footnote)
                                 (buffer-substring-no-properties beg end)
                                 (muse-markup-text 'footnotetext-end))))
                  (aset muse-publish-footnotes footnote footnotemark))))
            (goto-char end)
            (skip-chars-forward "\n")
            (delete-region start (point))
            (set-marker end nil))))
      (if footnotemark
          (muse-insert-markup footnotemark)
        (insert oldtext))))))



;;; === For latex
;;; --------------------------------------------------------------
(defcustom d-muse-latex-markup-functions
  '((table . muse-latex-markup-table)
    (dtag  . d-muse-publish-markup-dtag)
    (dsection . d-muse-publish-markup-dnotesection)
    )
  "An alist of style types to custom functions for that kind of text.
For more on the structure of this list, see
`muse-publish-markup-functions'."
  :type '(alist :key-type symbol :value-type function)
  :group 'muse-latex)


(defcustom d-muse-latex-header
  "%%% for define

\\documentclass[12pt,a4]{article}

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
%\\usepackage{lastpage} % To get the number of total page
%\\usepackage{totpages}

\\pagestyle{fancy}
\\renewcommand{\\headrulewidth}{0.4pt} %% To remove line
\\fancyhead[R]{\\tiny id$:$ DDocNumber}
\\fancyhead[LO, RE]{\\bf\\large DDocTitle}
%\\rhead{\\bf DDocNumber}
%\\fancyhead[LO]{\\bfseries\\rightmark}
%\\fancyfoot[r]{\\thepage/\\ref{TotPages}}
%\\fancyfoot[r]{\\thepage/\\pageref{LastPage}}
\\fancyfoot[c]{\\thepage}
\\headwidth 492pt                % width of header
%\\setcounter{page}{2}


%%%% For boxing
%\\usepackage{listings}
%\\lstset{
%language=C,
%basicstyle=\\small\\sffamily,
%numbers=left,
%numberstyle=\\tiny,
%frame=tb,
%columns=fullflexible,
%showstringspaces=false
%}
%
%
%\\renewenvironment{verbatim}
%{\\begin{lstlisting}}{\\end{lstlisting}}
% I have a problem with boxing. I couldn't use korean with listings.
% See latex#1003241327


%% page layout
% 1in = 25.4mm = 72pt = 72px
% for A4
\\paperwidth 595.2pt             %8.267in
\\paperheight 841.9pt            %11.693in

\\textheight 10.69in
\\hoffset -29pt                    % default 1in+\\hoffset
\\voffset -49pt                    % default 1in+\\hoffset
\\headheight 12pt
\\textheight 690pt
\\textwidth 442pt


%%% For image
\\usepackage[pdftex]{graphicx}

\\def\\museincludegraphics{%
  \\begingroup
  \\catcode`\\|=0
  \\catcode`\\\\=12
  \\catcode`\\#=12
  \\includegraphics[width=0.75\\textwidth]
}

%%% other packages
\\usepackage[parfill]{parskip}
\\usepackage{enumitem}
\\setlist{parsep=0pt,listparindent=\\parindent}
\\usepackage{color}


%%% calendar
% from http://tex.stackexchange.com/questions/82153/option-clash-when-using-graphicx-and-tikz-packages
% The tikz package load the graphicx package automatically, so you can't
% load it again. Trying to load it with different options will cause the
% Option clash error. You can use
% \\PassOptionsToPackage{<option>}{graphicx} before loading tikz to pass
% any additional options to the internally loaded graphicx. However, you
% do not need and should not use the pdftex option manually with modern
% LaTeX distributions. Packages which are driver dependent are very well
% capable to detect the right driver by themselves and providing a wrong
% one causes all kinds of trouble.
\\PassOptionsToPackage{pdftex}{graphicx}
\\usepackage{tikz}
\\usetikzlibrary{calendar,shapes.geometric}


%% Extra keys for bold and italic dates.
\\pgfkeys{/tikz/italic/.code =
  {
    \\itshape{#1}
  }
}

\\pgfkeys{/tikz/bold/.code =
  {
    \\bfseries{#1}
  }
}



\\begin{document}
\\parindent       0ex % This is left-side indent

\\setlength{\\tabcolsep}{0pt}
% For paragraph
\\setlength{\\parindent}{0pt}
\\setlength{\\parskip}{13pt}
%\\thispagestyle{empty} % conflict with fancyhdr

"
  "Header used for publishing LaTeX files.  This may be text or a filename."
  :type 'string
  :group 'd-muse-latex)


;;(defcustom planner-publish-markup-regexps




(defcustom d-muse-latex-markup-specials-document
  '((?\\ . "\\textbackslash{}")
    (?\_ . "\\textunderscore{}")
    (?\< . "\\textless{}")
    (?\> . "\\textgreater{}")
    (?^  . "\\^{}")
    (?\~ . "\\~{}")
    ;; @ is no need escape character.
    ;(?\@ . "\\@")
    (?\$ . "\\$")
    (?\% . "\\%")
    (?\{ . "\\{")
    (?\} . "\\}")
    (?\& . "\\&")
    (?\# . "\\#")
    )
  "A table of characters which must be represented specially.
These are applied to the entire document, sans already-escaped
regions."
  :type '(alist :key-type character :value-type string)
  :group 'd-muse-latex)

;; defcustom does not overraped. So manualy delete
(assq-delete-all 64 muse-latex-markup-specials-document)


;;; === <br13> for styles d-latex, d-html-derive
;;; --------------------------------------------------------------
;; I use <br13> to paragraph in planner-mode.
;; Finaly I solved paragraph problem with
;; \setlength{\parskip}{13pt}

;; We define markup-string for latex
(add-to-list 'muse-latex-markup-strings (quote (line-break13 . "\\\\[13pt]")))
;; We define markup-string for html
(add-to-list 'muse-html-markup-strings (quote (line-break13 . "<br>")))

(add-to-list 'd-planner-publish-markup-tags (quote ("br13" nil nil nil d-muse-publish-br13-tag)))

(add-to-list 'muse-latex-markup-strings (quote (section2 . "\\section*{")))

(add-to-list 'muse-latex-markup-strings (quote (section5 . "\\sectionnn*{")))


;;; === Used functions
;;; --------------------------------------------------------------
(defun d-muse-publish-markup-dtag ()
  (let* ((str (match-string 1)))

    (save-excursion
      ;; insert begin. We use goto-char. So we insert from end.
      (goto-char (match-end 0))
      (backward-delete-char-untabify 2)
      (muse-insert-markup (muse-markup-text 'end-ddt))
      (goto-char (match-beginning 0))
      (muse-insert-markup (muse-markup-text 'begin-dl))
      (muse-insert-markup (muse-markup-text 'begin-ddt))
			  
      ;; insert end
      (if (re-search-forward "\n\n\n" nil t)
	  (progn
	    (goto-char (match-beginning 0))
	    (muse-insert-markup-end-list (muse-markup-text 'end-dl)))
	;; The tag in the end of buffer
	(goto-char (point-max))
	(muse-insert-markup-end-list (muse-markup-text 'end-dl)))))
  nil)

(defun planner-publish-content-tag (beg end)
  (save-excursion
    (goto-char end)
    (planner-insert-markup (muse-markup-text 'planner-end-content))
    (goto-char beg)
    (planner-insert-markup (muse-markup-text 'planner-begin-content))))

(defun muse-publish-contents-tag (beg end attrs)
  (set (make-local-variable 'muse-publish-generate-contents)
       (cons (copy-marker (point) t)
             (let ((depth (cdr (assoc "depth" attrs))))
               (or (and depth (string-to-number depth))
                   muse-publish-contents-depth)))))

(defun muse-publish-markup-lineb ()
  ;; (let* ((str (match-string 1)))
  ;;   (save-excursion
  ;;     (goto-char (match-end 0))
  ;;     (muse-insert-markup (muse-markup-text 'd-line-break)))))
  (delete-region (match-beginning 0) (match-end 0))
  (muse-insert-markup (muse-markup-text 'd-line-break)))

(defun d-muse-publish-br13-tag (beg end)
  (delete-region beg end)
  (muse-insert-markup (muse-markup-text 'line-break13)))


(defun d-muse-publish-markup-dnotesection ()
  (let* ((len (length (match-string 1)))
         (start (muse-markup-text
                 (cond ((= len 1) 'section2)
                       ((= len 2) 'subsection)
                       ((= len 3) 'subsubsection)
                       (t 'section-other))
                 len))
         (end   (muse-markup-text
                 (cond ((= len 1) 'section-end)
                       ((= len 2) 'subsection-end)
                       ((= len 3) 'subsubsection-end)
                       (t 'section-other-end))
                 len)))
    (delete-region (match-beginning 0) (match-end 0))
    (muse-insert-markup start)
    (end-of-line)
    (when end
      (muse-insert-markup end))
    (forward-line 1)
    (unless (eq (char-after) ?\n)
      (insert "\n"))
    (muse-publish-section-close len)))


(provide 'd-muse-publish)



