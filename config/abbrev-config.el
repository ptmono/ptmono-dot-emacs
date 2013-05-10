;;; === Logs
;;; --------------------------------------------------------------
;; 0910150226
;;
;; - def-python-skeleton 을 다른 모드에도 쓸 수 있도록 수정했습니다. d-def-skeleton
;; - ddNAME 식으로 abbrev를 사용할까 생각중입니다.
;;


;;; === Using
;;; --------------------------------------------------------------
;;(d-def-skeleton MODE NAME ...) 의 형태로 사용할 abbrev를 만드시면
;;됩니다. MODE는 "lisp" 같이 이름을 사용하시면 됩니다. NAME은
;;abbrev name 입니다.
;;
;;각 mode에는
;;(defcustom d-abbrev-MODE-use-skeletons t "")
;;같은 변수가 존재합니다. MODE는 mode 이름을 사용하시면 됩니다.
;;(defcustom d-abbrev-lisp-use-skeletons t "")
;;같이요. 이 변수는 각 모드에서 d-def-skeleton 으로 설정된 abbrev를
;;사용할지 안할지를 결정하게 됩니다. nil이면 사용하지 않겠다는
;;거여요.

;See emacsModes#0910141523. explanation about abbrev and skeleton

;;; examples
;; See http://www.emacswiki.org/emacs/SkeletonMode : has examples
;; and http://www.emacswiki.org/emacs/AbbrevMode

;;(define-abbrev global-abbrev-table "rnf" "rel=\"nofollow\"")
;;
;;(define-abbrev global-abbrev-table "stcod"
;;  "style=\"font-size: 130%; background: #eee; padding: 3px;\"")

;;(define-abbrev global-abbrev-table "stsrc"
;;  (concat "<pre style=\"font-size: 130%; border: 1px solid #bbb;"
;;                       "background: #eee; margin: 15px 5px; padding: 5px;\">"))


;;; === Simple example
;;; --------------------------------------------------------------
;(define-skeleton latex-skeleton
;  "Inserts a Latex letter skeleton into current buffer.
;    This only makes sense for empty buffers."
;  "Empfänger: "
;  "\\documentclass[a4paper]{letter}\n"
;  "\\usepackage{german}\n"
;  "\\usepackage[latin1]{inputenc}\n"
;  "\\name{A. Schröder}\n"
;  "\\address{Alexander Schröder \\\\ Langstrasse 104 \\\\ 8004 Zürich}\n"
;  "\\begin{document}\n"
;  "\\begin{letter}{" str | " *** Empfänger *** " "}\n"
;  "\\opening{" _ "}\n\n"
;  "\\closing{Mit freundlichen Grüssen,}\n"
;  "\\end{letter}\n"
;  "\\end{document}\n")
;
;-------------------------------------------------------------------------------- 
;
;(define-abbrev fortran-mode-abbrev-table ";ife"
;  "" 'fortran-skeleton-if-else-endif)
;
;--------------------------------------------------------------------------------
;

;;; === Repeated input example
;;; --------------------------------------------------------------
;(define-skeleton hello-class
;  "Example for repeated input."
;  "this prompt is ignored"
;  ("Enter name of student: " "hello, " str \n))
;
;And assuming some very simple input, here’s the result:
;
;    hello, a
;    hello, b
;    hello, c
;

;;; === Using multiple variables example
;;; --------------------------------------------------------------
;(define-skeleton read-two-vars
;  "Prompt the user for two variables, and use them in a skeleton."
;  ""
;  > "variable A is " (setq v1 (skeleton-read "Variable A? ")) \n
;  > "variable B is " (setq v2 (skeleton-read "Variable B? ")) \n
;  > "A: " v1 "    B: " v2 \n)
;

;;; === More things to do with variables examples
;;; --------------------------------------------------------------
;(define-skeleton vote
;  ""
;  nil
;  >"|----------------+----------+--------------|" \n
;  >"|Vote:           |For: " (setq v1 (skeleton-read "How many for? "))"    |Against: " (setq v2 (skeleton-read "How many against? "))"    |" \n
;  >"|----------------+----------+--------------|" \n
;  "|" (if (< (string-to-number v1)(string-to-number v2)) (insert "Not Carried                               |")
;	(insert "Carried                                    |")) \n
;	>"|------------------------------------------|" \n
;	)
;

;;; === Quoted S-Expressions example
;;; --------------------------------------------------------------
;
; /* **************************************************************** */
; /* **                        Lirum larum                         ** */
; /* **************************************************************** */

;
;(define-skeleton insert-c-comment-header
;  "Inserts a c comment in a rectangle into current buffer."
;  ""
;  '(setq str (skeleton-read "Comment: "))
;  ;; `str' is set explicitly here, because otherwise the skeleton
;  ;; program would set it, only when it is going to insert it into the
;  ;; buffer. But we need to determine the length of the string
;  ;; beforehand, with `(length str)' below.
;  '(when (string= str "") (setq str " - "))
;  '(setq v1 (make-string (- fill-column 6) ?*))
;  '(setq v2 (- fill-column 10 (length str)))
;  "/* " v1 " */" \n
;  "/* **"
;  (make-string (floor v2 2) ?\ )
;  str
;  (make-string (ceiling v2 2) ?\ )
;  "** */" \n
;  "/* " v1 " */")
;
;--------------------------------------------------------------------------------
;; more useful
;(define-skeleton xhtml-trans-skeleton
;  "Inserts a skeletal XHTML file with the DOCTYPE declaration
;    for the XHTML 1.0 Transitional DTD"
;  "Title: "
;  "<?xml version=\"1.0\""
;  (if buffer-file-coding-system
;      (concat " encoding=\""
;	      (setq v1
;		    (symbol-name
;		     (coding-system-get buffer-file-coding-system
;                                        'mime-charset))) "\""))
;  "?>\n"
;  "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\"\n"
;  > "\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n"
;  > "<html xmlns=\"http://www.w3.org/1999/xhtml\">\n"
;  > "<head>\n"
;  (when buffer-file-coding-system
;    (indent-according-to-mode)
;    (concat
;     "<meta http-equiv=\"Content-type\" content=\"text/html; charset="
;     v1 "\" />\n"))
;  > "<meta name=\"Author\" content=\"" (user-full-name) "\" />\n"
;  > "<title>" - str
;  '(save-excursion (sgml-quote skeleton-point (point)))
;  "</title>\n"
;  "</head>" > \n
;  > "<body>\n"
;  > "<h1>" - str
;  '(save-excursion (sgml-quote skeleton-point (point)))
;  "</h1>\n"
;  > - \n
;  "</body>" > \n
;  "</html>" > \n \n)

;;; end of example


;;; === Common
;;; --------------------------------------------------------------
;(eval-when-compile
(defmacro d-def-skeleton (mode name &rest elements)
  "(d-def-skeleton MODE ABBREV. Where ABBREV is possible \\;abbrevname"
  (let* ((mode-prefix (concat "d-abbrev-" mode))
	 (name (symbol-name name))
	 (function (intern (concat mode-prefix "-insert-" name)))
	 (mode-use-skeletons (intern (concat mode-prefix "-use-skeletons")))
	 (mode-abbrev-table (intern (concat mode "-mode-abbrev-table"))))
    `(progn

       (define-abbrev ,mode-abbrev-table ,name ""
	 ',function
	 nil t)

       (define-skeleton ,function
	 ,(format (concat "Insert" mode "\"%s\" template.") name)
	 ,@elements))))
;)


;;; === Configuration
;;; --------------------------------------------------------------
;; all mode loads abbrev-mode
(setq default-abbrev-mode t) ;obsolete variable use 'abbrev-mode


;;; === For global
;;; --------------------------------------------------------------
(define-abbrev global-abbrev-table "ddtoc" "* Table Of Contents\n\n<contents>\n")
(define-abbrev global-abbrev-table "ddfootnote" "Footnotes::\n [1]")
(define-abbrev global-abbrev-table "ddsrc" "")


;;; === For muse and planner
;;; --------------------------------------------------------------
(d-def-skeleton "muse" ddsrc
		nil
		"<src lang=\"c++\">"\n
		> _ \n
		"</src>" \n)

(d-def-skeleton "planner" ddsrcp
		nil
		"<src lang=\"python\">"\n
		> _ \n
		"</src>" \n)

(d-def-skeleton "muse" ddsrcp
		nil
		"<src lang=\"python\">"\n
		> _ \n
		"</src>" \n)

(d-def-skeleton "muse" ddsrce
		nil
		"<src lang=\"elisp\">"\n
		> _ \n
		"</src>" \n)

(d-def-skeleton "muse" ddsrcc
		nil
		"<src lang=\"c\">"\n
		> _ \n
		"</src>" \n)

(d-def-skeleton "muse" ddsrcc++
		nil
		"<src lang=\"c++\">"\n
		> _ \n
		"</src>" \n)

(d-def-skeleton "muse" ddsrccpp
		nil
		"<src lang=\"c++\">"\n
		> _ \n
		"</src>" \n)

;; The information is in config.article_informations
;; title, author, date, update, tag, category, unpublished
(d-def-skeleton "muse" ddpublish
		nil
		'(setq title (skeleton-read "Title: "))
		'(setq tag (skeleton-read "Tags: "))
		'(setq category (skeleton-read "Category: "))
		'(setq ctime (d-create-citation))
		"#title " title \n
		"#author dalsoo" \n
		"#date " ctime \n
		"#update " ctime \n
		"#tag " tag \n
		"#category " category \n
		"#unpublished false" \n)

(d-def-skeleton "muse" ddheader
		nil
		"-*- mode: muse -*-" \n)

(d-def-skeleton "muse" ddreport
		nil
		"#"
		'(setq time (d-insert-time))
		\n
		"REPORT: ")



;;; === For lisp
;;; --------------------------------------------------------------
;; ddtest를 쓰기를 웠했는데요. lisp-mode에서 abbrev로 사용할 수가 없었습니다.
;(d-def-skeleton "lisp" \;ddtest
;		nil
;		"(defun d-test ()" \n
;		"\"\"" \n
;		"(interactive)" \n
;		> _ \n
;		")" \n)

(d-def-skeleton "lisp" ddtest
		nil
		"(defun d-test ()" \n
		"\"\"" \n
		"(interactive)" \n
		> _ \n
		")" \n)

;(d-def-skeleton "lisp" ddsec
;		nil
;		'(setq str (skeleton-read "Title: "))
;		'(when (string= str "") (setq str " - "))
;		'(setq v1 (make-string (+ (length str) 7) ?=))
;		";" v1  \n
;		";;; " str " ;;;"\n
;		";" v1 \n
;		> _)

; wide version

;; (d-def-skeleton "lisp" ddsec
;; 		nil
;; 		'(setq str (skeleton-read "Comment: "))
;; 		'(when (string= str "") (setq str " - "))
;; 		'(setq v1 (make-string (- fill-column 4) ?=))
;; 		'(setq v2 (- fill-column 10 (length str)))
;; 		";" v1 \n
;; 		";;; "
;; 		str
;; 		(make-string (- (* 2(ceiling v2 2)) 
;; 				(if (eq (mod (length str) 2) 1) 1 0)) ?\ )
;; 		";;;" \n
;; 		";" v1 \n
;; 		> _)


(d-def-skeleton "lisp" ddsec
		nil
		'(setq str (skeleton-read "Comment: "))
		'(when (string= str "") (setq str " - "))
		'(setq v1 (make-string (- fill-column 12) ?-))
		";;; === " str \n
		";;; " v1 \n
		> _)


;;; === For python
;;; --------------------------------------------------------------
(d-def-skeleton "python" ddheader
  nil
  "#!/usr/bin/python"\n
  "# coding: utf-8"\n
  \n
  \n
  )

(d-def-skeleton "python" ddsec
		nil
		'(setq str (skeleton-read "Comment: "))
		'(when (string= str "") (setq str " - "))
		'(setq v1 (make-string (- fill-column 12) ?_))
		"### === " str \n
		"### " v1 \n
		> _)


(d-def-skeleton "python" ddmain
    nil
  "if __name__ == \"__main__\":" \n
  "main()"
  )

(d-def-skeleton "python" ddcomment
		nil
		"\"\"\"" \n
		> _ \n
		"\"\"\"")

(d-def-skeleton "python" dddignore
    nil
  "#doctest: +IGNORE_EXCEPTION_DETAIL"
  )

(d-def-skeleton "python" dddskip
    nil
  "#doctest: +SKIP"
  )

(d-def-skeleton "python" ddsconsqt
		nil
		"import os" \n
		"os.environ['QT4DIR'] = '/usr/lib64/qt4'" \n
		"env = Environment()" \n
		"env.Tool('qt4')" \n
		"env.EnableQt4Modules(['QtCore', 'QtGui', 'QtTest'])" \n
		\n
		"# Base sources" \n
		"sources_base = ["
		"'build/main.cpp'" \n
		 "]" \n
		\n
		"# For testing" \n
		"dir_test = 'tests/'" \n
		"sources_test = [" \n
		"'test_prepare.cpp'" \n
		"]" \n
		"sources_test = map((lambda a : dir_test + a), sources_test)" \n
		"objects_test = env.Object(sources_test)" \n
		\n
		"# qjson"\n
		"dir_qjson = 'tools/qjson/src/'" \n
		"sources_qjson = [" \n
		"]" \n
		\n
		"sources_qjson = map((lambda a : dir_qjson + a), sources_qjson)" \n
		"objects_qjson = env.Object(sources_qjson)" \n
		\n
		"# header directories" \n
		"env['CPPPATH'] = env['CPPPATH'] + [dir_qjson] + [dir_test]" \n
		\n
		"sources = sources_base + objects_qjson + objects_test" \n
		"env.VariantDir('build', 'src', duplicate=0)" \n
		"env.Program(target = 'build/Test', source = sources)" \n
		)


(d-def-skeleton "python" ddtest
		nil
		'(setq str (skeleton-read "Name: "))
		"#!/usr/bin/python"\n
		"# coding: utf-8"\n
		\n
		"from unittest import TestCase"\n
		\n
		\n
		"class Test_" str "(TestCase):" \n
		"@classmethod" \n
		"def setUpClass(cls):" \n
		>"pass" \n
		"@classmethod" \n
		"def tearDownClass(cls):" \n
		>"pass" \n
		"def setUp(self):" \n
		>"pass" \n
		"def tearDown(self):" \n
		>"pass" \n
		_)


(d-def-skeleton "python" dddocsec
		nil
		\n
		_">>>")

(d-def-skeleton "python" dddoctest
		nil
		'(setq name (skeleton-read "Name: "))
		"def " name "():"\n
		>"'''"\n
		>">>> " name "()"\n
		>"'''"\n
		>_)

;;; === Csharp
;;; --------------------------------------------------------------
(require 'csharp-mode)

(d-def-skeleton "csharp" ddcw
		nil
		"Console.WriteLine" \n
		)

(d-def-skeleton "csharp" ddgs
		nil
		"{ get; private set; }" \n
		)



;;; === For python (I not use this)
;;; --------------------------------------------------------------
;; python.el에 포함되어 있습니다. 이유는 모르겠지만, 시작시 로드하지 않아서 여기에
;; 붙여요.
;; def-python-skeleton의 장점은 함수에 대한 질답식 입력이 가능하다는 겁입니다.
;; default is nil. 그냥은 로드되지 않아서 여기로 가져왔어요.
(defcustom d-python-use-skeletons nil
  "Non-nil means template skeletons will be automagically inserted.
This happens when pressing \"if<SPACE>\", for example, to prompt for
the if condition."
  :type 'boolean
  :group 'python)

(define-abbrev-table 'd-python-mode-abbrev-table ()
  "Abbrev table for Python mode."
  :case-fixed t
  ;; Allow / inside abbrevs.
  :regexp "\\(?:^\\|[^/]\\)\\<\\([[:word:]/]+\\)\\W*"
  ;; Only expand in code.
  :enable-function (lambda () (not (python-in-string/comment))))

(eval-when-compile
  ;; Define a user-level skeleton and add it to the abbrev table.
(defmacro d-def-python-skeleton (name &rest elements)
  (let* ((name (symbol-name name))
	 (function (intern (concat "python-insert-" name))))
    `(progn
       ;; Usual technique for inserting a skeleton, but expand
       ;; to the original abbrev instead if in a comment or string.
       (when d-python-use-skeletons
         (define-abbrev d-python-mode-abbrev-table ,name ""
           ',function
           nil t))                      ; system abbrev
       (define-skeleton ,function
	 ,(format "Insert Python \"%s\" template." name)
	 ,@elements)))))
(put 'd-def-python-skeleton 'lisp-indent-function 2)

(d-def-python-skeleton ddheader
  nil
  "#!/usr/bin/python"\n
  "# coding: utf-8"\n)

;; Conflict to d-defskeleton. Why?
;; (d-def-python-skeleton ddsec
;;     nil
;;   '(setq str (skeleton-read "Comment: "))
;;   '(when (string= str "") (setq str " - "))
;;   '(setq v1 (make-string (- fill-column 4) ?=))
;;   '(setq v2 (- fill-column 10 (length str)))
;;   "#" v1
;;   '(newline)
;;   "### "
;;   str
;;   (make-string (- (* 2(ceiling v2 2)) 
;; 		  (if (eq (mod (length str) 2) 1) 1 0)) ?\ )
;;   "###"
;;   '(newline)
;;   "#" v1
;;   '(newline)
;;   )

(d-def-python-skeleton ddmain
    nil
  "if __name__ == \"__main__\":" \n
  "main()"
  )


;; From `skeleton-further-elements' set below:
;;  `<': outdent a level;
;;  `^': delete indentation on current line and also previous newline.
;;       Not quite like `delete-indentation'.  Assumes point is at
;;       beginning of indentation.

;; (def-python-skeleton if
;;   "Condition: "
;;   "if " str ":" \n
;;   > -1	   ; Fixme: I don't understand the spurious space this removes.
;;   _ \n
;;   ("other condition, %s: "
;;    <			; Avoid wrong indentation after block opening.
;;    "elif " str ":" \n
;;    > _ \n nil)
;;   '(python-else) | ^)

;; (define-skeleton python-else
;;   "Auxiliary skeleton."
;;   nil
;;   (unless (eq ?y (read-char "Add `else' clause? (y for yes or RET for no) "))
;;     (signal 'quit t))
;;   < "else:" \n
;;   > _ \n)

;; (def-python-skeleton while
;;   "Condition: "
;;   "while " str ":" \n
;;   > -1 _ \n
;;   '(python-else) | ^)

;; (def-python-skeleton for
;;   "Target, %s: "
;;   "for " str " in " (skeleton-read "Expression, %s: ") ":" \n
;;   > -1 _ \n
;;   '(python-else) | ^)

;; (def-python-skeleton try/except
;;   nil
;;   "try:" \n
;;   > -1 _ \n
;;   ("Exception, %s: "
;;    < "except " str '(python-target) ":" \n
;;    > _ \n nil)
;;   < "except:" \n
;;   > _ \n
;;   '(python-else) | ^)

;; (define-skeleton python-target
;;   "Auxiliary skeleton."
;;   "Target, %s: " ", " str | -2)

;; (def-python-skeleton try/finally
;;   nil
;;   "try:" \n
;;   > -1 _ \n
;;   < "finally:" \n
;;   > _ \n)

;; (def-python-skeleton def
;;   "Name: "
;;   "def " str " (" ("Parameter, %s: " (unless (equal ?\( (char-before)) ", ")
;; 		     str) "):" \n
;;   "\"\"\"" - "\"\"\"" \n     ; Fixme:  extra space inserted -- why?).
;;   > _ \n)

;; (def-python-skeleton class
;;   "Name: "
;;   "class " str " (" ("Inheritance, %s: "
;; 		     (unless (equal ?\( (char-before)) ", ")
;; 		     str)
;;   & ")" | -2				; close list or remove opening
;;   ":" \n
;;   "\"\"\"" - "\"\"\"" \n
;;   > _ \n)


;;; === c/c++ mode
;;; --------------------------------------------------------------

(d-def-skeleton "c" ddmain
		nil
		"int main (int argc, char **argv)" ?\n
		"{" \n
		> _ ?\n
		"}" ?\n)

(d-def-skeleton "c++" ddmain
		nil
		"int main (int argc, char **argv)" ?\n
		"{" \n
		> _ ?\n
		"}" ?\n)


(d-def-skeleton "c++" ddtestheader
		nil
		"#ifndef " (d-cc-abbr/get-filename) ?\n
		"#define " (d-cc-abbr/get-filename) ?\n
		\n
		"class " (d-cc-abbr/get-classname-for-test) " : public QObject" ?\n
		"{" \n
		> "Q_OBJECT" ?\n
		?\n
		"private slots:" ?\n
		> "void initTestCase();" ?\n
		> "void test_init();" ?\n
		> "void cleanupTestCase();" ?\n
		"};" ?\n
		\n
		"DECLARE_TEST(" (d-cc-abbr/get-classname-for-test) ")" ?\n
		"#endif")


(d-def-skeleton "c++" ddtesth
		nil
		"#ifndef " (d-cc-abbr/get-filename) ?\n
		"#define " (d-cc-abbr/get-filename) ?\n
		\n
		"#include \"AutoTest.h\"" ?\n
		\n
		"class " (d-cc-abbr/get-classname-for-test) " : public QObject" ?\n
		"{" \n
		> "Q_OBJECT" ?\n
		?\n
		"private slots:" ?\n
		> "void initTestCase();" ?\n
		> "void test_init();" ?\n
		> "void cleanupTestCase();" ?\n
		"};" ?\n
		\n
		"DECLARE_TEST(" (d-cc-abbr/get-classname-for-test) ")" ?\n
		"#endif")

(d-def-skeleton "c++" ddheaderinit
		nil
		"#ifndef " (d-cc-abbr/get-filename) ?\n
		"#define " (d-cc-abbr/get-filename) ?\n
		\n
		> _ ?\n
		\n
		"#endif")

(d-def-skeleton "c" ddheaderinit
		nil
		"#ifndef " (d-cc-abbr/get-filename) ?\n
		"#define " (d-cc-abbr/get-filename) ?\n
		\n
		> _ ?\n
		\n
		"#endif")

(d-def-skeleton "c++" ddqde
		nil
		> "qDebug() << ")


(defun d-cc-abbr/get-filename()
  (upcase (replace-regexp-in-string "\\." "_" (buffer-name))))

(defun d-cc-abbr/get-classname-for-test()
  (let* ((result (replace-regexp-in-string "^test_" "" (buffer-name)))
	 (end (string-match "\\." result))
	 (result (substring result 0 end))
	 (result (concat "Test" (upcase-initials result))))
    result))

;;; === html-mode
;;; --------------------------------------------------------------
(require 'sgml-mode)

(d-def-skeleton "sgml" dddiv
		nil
		'(setq str (skeleton-read "Class name: "))
		"<div class=\"" str "\">" \n
		> _ \n
		-2 "</div> <!-- End " str " -->"  ?\n)
