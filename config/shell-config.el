
;;; === font-lock
;;; --------------------------------------------------------------

(defvar shell-font-lock-keywords
  '(("[ \t]\\([+-][^ \t\n]+\\)" 1 font-lock-comment-face)
    ("^[^ \t\n]+:.*" . font-lock-string-face)
    ("^\\[[1-9][0-9]*\\]" . font-lock-string-face)
    ;; Added to Qt test
    ("^FAIL!  :" . font-lock-warning-face)
    ("^QDEBUG :" . font-lock-constant-face)
    )
  "Additional expressions to highlight in Shell mode.")
