(require 'find-dired)

;; find-dired-ebooks See myel.el

;; TODO: so complicate. Clear.
(defun find-dired-ebooks-mody (dir args &optional regexp)
  "Run `find' and go into Dired mode on a buffer of the output.
The command run (after changing into DIR) is

    find . \\( ARGS \\) -ls

except that the variable `find-ls-option' specifies what to use
as the final argument.
---------------------------------------------------------------

This is modified from find-dired to search ebooks. Following dirt
variable is the directories of ebook. You can edit AB-ARGS and
FL-ARGS. These are the option and string of find.

DIR is not required in the function where the function use DIRT
value. You can search two ways. First ARGS concretes \"-iregex
\\\".*ARGS.*.pdf\\\\|chm\\\|rar\\\\|zip\\\"\" which is managed by
AB-ARGS and FL-ARGS. So conveniously type the string or short
regexp. If you type empty space for first ARGS, you can type
while args.
"
; You can type two type argument. First choose
  (interactive (let ((regexpp nil))
;		 (list (read-file-name "Run find in directory: " nil "" t)
		 (list (file-name-directory (or buffer-file-name "~/.w3m/"))
;	       (read-string "Run find in directory: " "/tmp/0-incoming/directories/ /media/data/ebooks/computers/ "))
		       (let ((qqq (read-string "Run find (just words of regexp): " "")))
			 (if (equal qqq "")
			     (progn
			       (setq regexpp t)
			       (read-string "Run find (with args): " "-iregex \".*art.*.\\(pdf\\|chm\\|rar\\|zip\\)\""
					    '(find-args-history . 1)))
			   qqq))
		       (if regexpp
			   t
			 nil))))
  (let ((dired-buffers dired-buffers)
	(dirt "/tmp/0-incoming/directories/ /media/data/ebooks/ /tmp/0-incoming/files/ /media/data/0-incoming/") ;default-directory dir
	(ab-args2 "-iregex \".*") ;; the option part
	(fl-args2 ".*.\\(pdf\\|chm\\|rar\\|zip\\)\"")) ;; the regexp part
    ;; Expand DIR ("" means default-directory), and make sure it has a
    ;; trailing slash.....
    (setq dir (file-name-as-directory (expand-file-name dir)))
;    (setq dir "/tmp/0-incoming/directories/ /media/data/ebooks/computers/ /media/data/tmp/incoming2/directories/")
    ;; Check that it's really a directory.
;    (or (file-directory-p dir)
;	(error "find-dired needs a directory: %s" dir))

    (d-window-separate)
    (other-window 1)
    (switch-to-buffer (get-buffer-create "*Find*"))

    ;; See if there's still a `find' running, and offer to kill
    ;; it first, if it is.
    (let ((find (get-buffer-process (current-buffer))))
      (when find
	(if (or (not (eq (process-status find) 'run))
		(yes-or-no-p "A `find' process is running; kill it? "))
	    (condition-case nil
		(progn
		  (interrupt-process find)
		  (sit-for 1)
		  (delete-process find))
	      (error nil))
	  (error "Cannot have two processes in `%s' at once" (buffer-name)))))
    (widen)
    (kill-all-local-variables)
    (setq buffer-read-only nil)
    (erase-buffer)
    (if regexp
	(setq args2 args)
      (setq args2 (concat ab-args2 args fl-args2)))  ;;---> regexp
    (setq find-args args2	      ; save for next interactive call

;	  args2 (concat find-dired-find-program " " dirt " "
;;; modified in emacs 23.0.60
	  args2 (concat find-program " " dirt " "

		       (if (string= args2 "")
			   ""
			 (concat
			  (shell-quote-argument "(")
			  " " args2 " "
			  (shell-quote-argument ")")
			  " "))
		       (if (equal (car find-ls-option) "-exec ls -ld {} \\;")
			   (concat "-exec ls -ld "
				   (shell-quote-argument "{}")
				   " "
				   (shell-quote-argument ";"))
			 (car find-ls-option))))
    ;; Start the find process.
    (shell-command (concat args2 "&") (current-buffer))
    ;; The next statement will bomb in classic dired (no optional arg allowed)
    (dired-mode dir (cdr find-ls-option))
    (let ((map (make-sparse-keymap)))
      (set-keymap-parent map (current-local-map))
      (define-key map "\C-c\C-k" 'kill-find)
      (use-local-map map))
    (make-local-variable 'dired-sort-inhibit)
    (setq dired-sort-inhibit t)
    (set (make-local-variable 'revert-buffer-function)
	 `(lambda (ignore-auto noconfirm)
	    (find-dired ,dir ,find-args)))
    ;; Set subdir-alist so that Tree Dired will work:
    (if (fboundp 'dired-simple-subdir-alist)
	;; will work even with nested dired format (dired-nstd.el,v 1.15
	;; and later)
	(dired-simple-subdir-alist)
      ;; else we have an ancient tree dired (or classic dired, where
      ;; this does no harm)
      (set (make-local-variable 'dired-subdir-alist)
	   (list (cons default-directory (point-min-marker)))))
    (set (make-local-variable 'dired-subdir-switches) find-ls-subdir-switches)
    (setq buffer-read-only nil)
    ;; Subdir headlerline must come first because the first marker in
    ;; subdir-alist points there.
    (insert "  " dir ":\n")
    ;; Make second line a ``find'' line in analogy to the ``total'' or
    ;; ``wildcard'' line.
    (insert "  " args2 "\n")
    (setq buffer-read-only t)
    (let ((proc (get-buffer-process (current-buffer))))
      (set-process-filter proc (function find-dired-filter))
      (set-process-sentinel proc (function find-dired-sentinel))
      ;; Initialize the process marker; it is used by the filter.
      (move-marker (process-mark proc) 1 (current-buffer)))
    (setq mode-line-process '(":%s"))))



(require 'grep)

(defun d-find-grep/get-grep-find-command (extension)
  (format "find . -iregex '.*%s$' -type f -print0 | xargs -0 -e grep -nHE -e " extension))

(defun d-find-grep/base (extension)
  "This is created to use conveniently of 'find-grep for file
type. d-find-grep-python is used for python file with
find-dired.
EXTENSION is the file extension.
"
  (let* ((command-args (progn
			 (grep-compute-defaults)
			 (read-shell-command "Run find (like this): "
					     (d-find-grep/get-grep-find-command extension)
					     'grep-find-history)))
	 (null-device nil))
    (grep command-args)))


(defun d-find-grep-python ()
  ""
  (interactive)
  (d-find-grep/base "py"))

(defun d-find-grep-c ()
  ""
  (interactive)
  (d-find-grep/base "c"))

(defalias 'find-grep-python 'd-find-grep-python)
(defalias 'find-grep-c 'd-find-grep-python)
