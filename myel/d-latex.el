(defvar d-latex-name nil)
(defvar d-latex-filename nil)
(defvar d-latex-debug t)

(defvar d-latex-use-pdflatex t
  "We use ln -s pdftex latex. pdftex will directry generate pdf
  from tex. So we don't need dvipdfmx to convert dvi to pdf.")

(defvar d-latex-use-viewer "evince"
  "If non-nil will display the compiled pdf file. The value is one of following.
 - t : docview in emacs
 - ViewerName : such as evince, xpdf etc")


(defun d-latex-test()
  (interactive)
  (setq d-latex-filename nil)
  (setq d-latex-name nil)
  (setq d-latex-name (substring (buffer-name) 0 -4))
  (setq d-latex-filename (substring (buffer-file-name) 0 -4))
  ;(kill-buffer "*mytest*")

  ;; If process is exist, (process-status "mytest") will returns run
  (if (process-status "mytest")
      (error "There is aleady \"mytest\" process"))

  ;(setq process (start-process "mytest" "*mytest*" "/home/ptmono/tmp/testd/0tex/mytest3.sh"))

  (if d-latex-use-pdflatex
      (setq process (start-process "mytest" "*mytest*" "pdflatex" (concat d-latex-filename ".tex")))
    ;; start-process returns the process object
    (setq process (start-process "mytest" "*mytest*" "latex" (concat d-latex-filename ".tex"))))

  ;; only used to wait for the return of process. Not used to check that the
  ;; process is exist. Use the function process-status to check the exist.
  (d-window-separate)
  (other-window 1)
  (switch-to-buffer "*mytest*")
  (goto-char (point-max))

  (d-latex-wait-for-result process 2 "latex has a problem")

  ;; Let's start next process
  (unless d-latex-use-pdflatex
    (setq process (start-process "mytest" "*mytest*" "dvipdfmx" (concat d-latex-filename ".dvi")))

    (d-latex-wait-for-result process 5 "dvipdfmx has a problem"))

  ;; Let's show the pdf
  (if (equal d-latex-use-viewer t)
      (progn
	(when (get-buffer (concat d-latex-name ".pdf"))
	  (kill-buffer (concat d-latex-name ".pdf")))
	;; dired use this
	(other-window 1)
	(display-buffer (find-file-noselect (concat d-latex-filename ".pdf")))
	(sleep-for 1) ; for doc-view mode
	)
    (start-process "mytest" "*mytest*" d-latex-use-viewer (concat d-latex-filename ".pdf")))
  ;(switch-to-buffer (concat d-latex-name ".pdf"))
  ;(revert-buffer t t)
  ;(other-window 1))
  )


(defun d-latex-test-error(msg)
  (other-window 1)
  (switch-to-buffer "*mytest*")
  (goto-char (point-max))
  (insert "\n\n===================\nThere is a problem.\n===================\n" msg)
  (other-window 1)
  ;; End the sequence
  (error msg))

(defun d-latex-kill-process(process)
  "To kill a process.
kill-process does not imediately kill the process. So we need
  accept-process-output. After accept-process-output process
  lives some microseconds. So we use sleep-for"
  (kill-process process)
  (accept-process-output process 10 0 t)
  (sleep-for 1 65))


(defun d-latex-wait-for-result(process waittime msg &optional otherwindow)
  "Wait waittime seconds for process.
PROCESS is the process or process name.

WAITTIME is the time in which accept-process-output will wait
waittime seconds. accept-process-output will wait the output of
process and return t. If process does not output for waittime,
accept-process-output will return nil.

MSG is the message when there is no output in waittime seconds.

If OTHERWINDOW is non-nil, cursor to other window when
accept-process-output returns nil.
"
  (while (equal "run" (symbol-name (process-status process)))

    ;fixme I thing filter function is more flexible
    (unless (accept-process-output process waittime 0 t)
      (kill-process process)
      (if otherwindow
	  (d-window-separate)
	  (other-window 1))
      (error msg)))
  (sleep-for 0 65) ; wait for the exit of process. accept 하고 나서 프로세스가 끝나는데 시간이 필요하
  )


;; for testing
;(defun d-test()
;  (interactive)
;  (let* (bb)
;    (setq process (start-process "mytest" "*mytest*" "latex" (concat d-latex-filename ".tex")))
;    ;; only used to wait for the return of process. Not used to check that the
;    ;; process is exist. Use the function process-status to check the exist.
;    (while (setq dd (accept-process-output process 10 0 t))
;      (setq count (+ 1 cc)))
;    (y-or-n-p bb)
;    (sleep-for 0 64)
;    (setq bb (symbol-name (process-status process)))
;        (if (equal bb "exit")
;	(setq bb "ok exit")
;      (setq bb "nono"))
;    (y-or-n-p bb)))
;
