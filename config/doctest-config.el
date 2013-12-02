
;; 1305221052 Fixed bug
;; I have no idea the reason. mmm-mode breaks font-lock of python-mode. It is fixed with
;; Index: doctest-mode.el
;; ===================================================================
;; --- doctest-mode.el	(revision 327)
;; +++ doctest-mode.el	(working copy)
;; @@ -1497,7 +1497,7 @@
       
;;        ;; The front is any triple-quote.  Include it in the submode region,
;;        ;; to prevent clashes between the two syntax tables over quotes.
;; -      :front "\\(\"\"\"\\|'''\\)" :include-front t
;; +      :front "\\(\"\"\"\\|\'\'\'\\)" :include-front t
       
;;        ;; The back matches the front.  Include just the first character
;;        ;; of the quote.  If we didn't include at least one quote, then
;; @@ -1507,8 +1507,8 @@
;;        :save-matches t :back "~1" :back-offset 1 :end-not-begin t
       
;;        ;; Define a skeleton for entering new docstrings.
;; -      :insert ((?d docstring nil @ "\"\"" @ "\"" \n
;; -                   _ \n "\"" @ "\"\"" @)))
;; +      :insert ((?d docstring nil @ "\"\"\"" @ "\"" \n
;; +                   _ \n "\"" @ "\"\"\"" @)))
      
;;       ;; === doctest-example ===
;;       (doctest-example


(add-to-list 'load-path (concat d-dir-emacs "etc2/doctest-mode.el"))
(add-to-list 'auto-mode-alist '("\\.doctest$" . doctest-mode))
(autoload 'doctest-mode "doctest-mode" "doctest mode" t)

(require 'doctest-mode)
;(autoload 'doctest-register-mmm-classes "doctest-mode")
;(doctest-register-mmm-classes t t)

;;; .
;;; === Font-lock
;;; --------------------------------------------------------------
(defvar d-doctest-comment-face 'd-python-doc-result-face)
(defface d-doctest-comment-face
  '((t (:foreground "#FF787A" :bold nil))) 
  "Face for the python-mode ."
  :group 'font-lock-faces)


(defconst doctest-keyword-re
  (let* ((kw1 (mapconcat 'identity
                         '("and"      "assert"   "break"   "class"
                           "continue" "def"      "del"     "elif"
                           "else"     "except"   "exec"    "for"
                           "from"     "global"   "if"      "import"
                           "in"       "is"       "lambda"  "not"
                           "or"       "pass"     "print"   "raise"
                           "return"   "while"    "yield"
                           )
                         "\\|"))
         (kw2 (mapconcat 'identity
                         '("else:" "except:" "finally:" "try:")
                         "\\|"))
         (kw3 (mapconcat 'identity
                         '("ArithmeticError" "AssertionError"
                           "AttributeError" "DeprecationWarning" "EOFError"
                           "Ellipsis" "EnvironmentError" "Exception" "False"
                           "FloatingPointError" "FutureWarning" "IOError"
                           "ImportError" "IndentationError" "IndexError"
                           "KeyError" "KeyboardInterrupt" "LookupError"
                           "MemoryError" "NameError" "None" "NotImplemented"
                           "NotImplementedError" "OSError" "OverflowError"
                           "OverflowWarning" "PendingDeprecationWarning"
                           "ReferenceError" "RuntimeError" "RuntimeWarning"
                           "StandardError" "StopIteration" "SyntaxError"
                           "SyntaxWarning" "SystemError" "SystemExit"
                           "TabError" "True" "TypeError" "UnboundLocalError"
                           "UnicodeDecodeError" "UnicodeEncodeError"
                           "UnicodeError" "UnicodeTranslateError"
                           "UserWarning" "ValueError" "Warning"
                           "ZeroDivisionError" "__debug__"
                           "__import__" "__name__" "abs" "apply" "basestring"
                           "bool" "buffer" "callable" "chr" "classmethod"
                           "cmp" "coerce" "compile" "complex" "copyright"
                           "delattr" "dict" "dir" "divmod"
                           "enumerate" "eval" "execfile" "exit" "file"
                           "filter" "float" "getattr" "globals" "hasattr"
                           "hash" "hex" "id" "input" "int" "intern"
                           "isinstance" "issubclass" "iter" "len" "license"
                           "list" "locals" "long" "map" "max" "min" "object"
                           "oct" "open" "ord" "pow" "property" "range"
                           "raw_input" "reduce" "reload" "repr" "round"
                           "setattr" "slice" "staticmethod" "str" "sum"
                           "super" "tuple" "type" "unichr" "unicode" "vars"
                           "xrange" "zip")
                         "\\|"))
         (pseudokw (mapconcat 'identity
                              '("self" "None" "True" "False" "Ellipsis")
                              "\\|"))
         (string (concat "'\\(?:\\\\[^\n]\\|[^\n']*\\)'" "\\|"
                         "\"\\(?:\\\\[^\n]\\|[^\n\"]*\\)\""))
         (brk "\\(?:[ \t(]\\|$\\)"))
    (concat
     ;; Comments (group 1)
     "\\(#.*\\)"
     ;; Function & Class Definitions (groups 2-3)
     "\\|\\b\\(class\\|def\\)"
     "[ \t]+\\([a-zA-Z_][a-zA-Z0-9_]*\\)"
     ;; Builtins preceeded by '.'(group 4)
     "\\|[.][\t ]*\\(" kw3 "\\)"
     ;; Keywords & builtins (group 5)
     "\\|\\b\\(" kw1 "\\|" kw2 "\\|"
     kw3 "\\|" pseudokw "\\)" brk
     ;; Decorators (group 6)
     "\\|\\(@[a-zA-Z_][a-zA-Z0-9_]*\\)"
     ))
  "A regular expression used for syntax highlighting of Python
source code.")


(defun doctest-source-matcher (limit)
  "A `font-lock-keyword' MATCHER that returns t if the current line
contains a Python source expression that should be highlighted
after the point.  If so, it sets `match-data' to cover the string
literal.  The groups in `match-data' should be interpreted as follows:

  Group 1: comments
  Group 2: def/class
  Group 3: function/class name
  Group 4: builtins preceeded by '.'
  Group 5: keywords & builtins
  Group 6: decorators
  Group 7: strings
"
  (let ((matchdata nil))
    ;; First, look for string literals.
    (when doctest-highlight-strings
      (save-excursion
        (when (doctest-string-literal-matcher limit)
          (setq matchdata
                (list (match-beginning 0) (match-end 0)
                      nil nil nil nil nil nil nil nil nil nil nil nil
                      (match-beginning 0) (match-end 0))))))
    ;; Then, look for other keywords.  If they occur before the
    ;; string literal, then they take precedence.
    (save-excursion
      (when (and (re-search-forward doctest-keyword-re limit t)
                 (or (null matchdata)
                     (< (match-beginning 0) (car matchdata))))
        (setq matchdata (match-data))))
    (when matchdata
      (set-match-data matchdata)
      (goto-char (match-end 0))
      t)))

;; Define the font-lock keyword table.
(defconst doctest-font-lock-keywords
  `(
    ;; The following pattern colorizes source lines.  In particular,
    ;; it first matches prompts, and then looks for any of the
    ;; following matches *on the same line* as the prompt.  It uses
    ;; the form:
    ;;
    ;;   (MATCHER MATCH-HIGHLIGHT
    ;;            (ANCHOR-MATCHER nil nil MATCH-HIGHLIGHT))
    ;;
    ;; See the variable documentation for font-lock-keywords for a
    ;; description of what each of those means.
    ("^[ \t]*\\(>>>\\|\\.\\.\\.\\)"
     (1 'doctest-prompt-face)
     (doctest-source-matcher
      nil nil
      (1 'font-lock-comment-face t t)         ; comments
      (2 'font-lock-keyword-face t t)         ; def/class
      (3 'font-lock-type-face t t)            ; func/class name
      ;; group 4 (builtins preceeded by '.') gets no colorization.
      (5 'font-lock-keyword-face t t)         ; keywords & builtins
      (6 'font-lock-preprocessor-face t t)    ; decorators
      (7 'font-lock-string-face t t)          ; strings
      ))

    ;; The following pattern colorizes output lines.  In particular,
    ;; it uses doctest-output-line-matcher to check if this is an
    ;; output line, and if so, it colorizes it, and any special
    ;; markers it contains.
    (doctest-output-line-matcher
     ;; (0 'doctest-output-face t)
     (0 'font-lock-doc-face t)
     ("\\.\\.\\." (beginning-of-line) (end-of-line)
      (0 'doctest-output-marker-face t))
     (,doctest-blankline-re (beginning-of-line) (end-of-line)
                            (0 'doctest-output-marker-face t))
     (doctest-traceback-line-matcher (beginning-of-line) (end-of-line)
                                     (0 'doctest-output-traceback-face t))
     (,doctest-traceback-header-re (beginning-of-line) (end-of-line)
                                   (0 'doctest-output-traceback-face t))
     )

    ;; A PS1 prompt followed by a non-space is an error.
    ("^[ \t]*\\(>>>[^ \t\n][^\n]*\\)" (1 'font-lock-warning-face t))
    ("^[ \t]+>>> \\(#.*\\)$" 1 d-python-doctest-comment-face t)
    ("^[ \t]+>>> \\(# .*\\)$" 1 font-lock-comment-face t)
    ("^[ \t]*\\(>>>\\|\\.\\.\\.\\)[ \t]*def \\([^\(]+\\)"
     (2 'font-lock-function-name-face t))
    ("^[ \t]+>>> \\(# .*\\)$" 1 font-lock-comment-face t)
    ("^[ \t]+>>> ### .*$" 0 d-python-section-face t)
    ("^[ \t]+>>> ### =+ \\(.*\\)$" 1 d-python-section-bold-face t)


    )
  "Expressions to highlight in doctest-mode.")

;;; === Etc
;;; --------------------------------------------------------------
(defun d-doctest-replace-output ()
  (interactive)
  (window-configuration-to-register d-note-register)
  (doctest-replace-output)
  (jump-to-register d-note-register))
  
