;;; === Test environment
;;; --------------------------------------------------------------
;; Use elispWorknote.el#1212210233


(defvar d-latex-name nil)
(defvar d-latex-filename nil)
(defvar d-latex-debug t)

(defvar d-latex-wait-output nil)


(defvar d-latex-process-buffer-name "*mytest*")

(defvar d-latex-use-pdflatex t
  "We use ln -s pdftex latex. pdftex will directry generate pdf
  from tex. So we don't need dvipdfmx to convert dvi to pdf.")

(defvar d-latex-use-viewer "evince"
  "If non-nil will display the compiled pdf file. The value is one of following.
 - t : docview in emacs
 - ViewerName : such as evince, xpdf etc")


(defun d-latex-test()
  (interactive)

  ;; Init filter buffer
  (setq d-latex-wait-output nil)

  ;; If process is exist, (process-status "mytest") will returns run
  (if (bufferp (get-buffer d-latex-process-buffer-name))
      (kill-buffer d-latex-process-buffer-name))

  (setq d-latex-filename nil)
  (setq d-latex-name nil)
  (setq d-latex-name (substring (buffer-name) 0 -4))
  (setq d-latex-filename (substring (buffer-file-name) 0 -4))
  ;(kill-buffer d-latex-process-buffer-name)

  (if d-latex-use-pdflatex
      (setq process (start-process "mytest"
				   d-latex-process-buffer-name 
				   "pdflatex"
				   (concat d-latex-filename ".tex")))
    ;; start-process returns the process object
    (setq process (start-process "mytest" 
				 d-latex-process-buffer-name 
				 "latex" 
				 (concat d-latex-filename ".tex"))))

  (set-process-filter process 'd-latex-wait-filter)
  (d-latex-wait-for-result2 process "latex has a problem")


  ;; Let's start next process
  (unless d-latex-use-pdflatex
    (setq process (start-process "mytest" 
				 d-latex-process-buffer-name 
				 "dvipdfmx" 
				 (concat d-latex-filename ".dvi")))

    (d-latex-wait-for-result2 process "dvipdfmx has a problem"))

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
    (start-process "mytest" 
		   d-latex-process-buffer-name 
		   d-latex-use-viewer 
		   (concat d-latex-filename ".pdf")))
  ;(switch-to-buffer (concat d-latex-name ".pdf"))
  ;(revert-buffer t t)
  ;(other-window 1))
  )


(defun d-latex-test-error(msg)
  (other-window 1)
  (switch-to-buffer d-latex-process-buffer-name)
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


(defun d-latex-wait-filter (proc output)
  (setq d-latex-wait-output output)
  (save-excursion
    (switch-to-buffer d-latex-process-buffer-name)
    (goto-char (point-max))
    (insert output)
    (goto-char (point-max))
    ))


(defun d-latex-wait-for-result/is-error()
  (let* ((len (let* ((len2 (length d-latex-wait-output)))
		;; len have to >= 0
		(if (> len2 2)
		    (- len2 3)
		  0))))

    (if d-latex-wait-output
	(if (string-match "^\\? " d-latex-wait-output len)
	    t				;It is error
	  nil)
      nil))
  )

(defun d-latex-wait-for-result2(process msg)

  ;;  Wait process is on.
  (sleep-for 0 650)

  (while (and (equal "run" (symbol-name (process-status process)))
  	      (not (d-latex-wait-for-result/is-error)))
    (accept-process-output process 0 3 t)
    )

  ;; The result ouput to be success is " "
  (when (d-latex-wait-for-result/is-error)
    (kill-process process)
    (switch-to-buffer d-latex-process-buffer-name)
    (goto-char (point-max))
    (error msg)
    )
  )

(defun d-latex-wait-for-result(process waittime msg &optional otherwindow)
  " obsolte. Use d-latex-wait-for-result
Wait waittime seconds for process.
PROCESS is the process or process name.

WAITTIME is the time in which accept-process-output will wait
waittime seconds. accept-process-output will wait the output of
process and return t. If process does not output for waittime,
accept-process-output will return nil.

MSG is the message when there is no output in waittime seconds.

If OTHERWINDOW is non-nil, cursor to other window when
accept-process-output returns nil.
"
  ;; Wait process is on.
  (sleep-for 0 650)

  ;; ;fixme I thing filter function is more flexible
  (accept-process-output process waittime 0 t)

  (when (equal "run" (symbol-name (process-status process)))
    (kill-process process)
    (when otherwindow
      (d-window-separate)
      (other-window 1))
    (error msg))
  )



;; for testing
;(defun d-test()
;  (interactive)
;  (let* (bb)
;    (setq process (start-process "mytest" d-latex-process-buffer-name "latex" (concat d-latex-filename ".tex")))
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
