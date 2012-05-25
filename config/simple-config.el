(defun eval-expression (eval-expression-arg
			&optional eval-expression-insert-value)
  "Evaluate EVAL-EXPRESSION-ARG and print value in the echo area.
Value is also consed on to front of the variable `values'.
Optional argument EVAL-EXPRESSION-INSERT-VALUE, if non-nil, means
insert the result into the current buffer instead of printing it in
the echo area.

If `eval-expression-debug-on-error' is non-nil, which is the default,
this command arranges for all errors to enter the debugger."
  (interactive
   (list (let ((minibuffer-completing-symbol t))
	   (read-from-minibuffer "Eval: "
				 nil read-expression-map t
				 'read-expression-history))
	 current-prefix-arg))

  (if (null eval-expression-debug-on-error)
      (setq values (cons (eval eval-expression-arg) values))
    (let ((old-value (make-symbol "t")) new-value)
      ;; Bind debug-on-error to something unique so that we can
      ;; detect when evaled code changes it.
      (let ((debug-on-error old-value))
	(setq values (cons (eval eval-expression-arg) values))
	(setq new-value debug-on-error))
      ;; If evaled code has changed the value of debug-on-error,
      ;; propagate that change to the global binding.
      (unless (eq old-value new-value)
	(setq debug-on-error new-value))))

  (let ((print-length eval-expression-print-length)
	(print-level eval-expression-print-level))
    (if eval-expression-insert-value
	(with-no-warnings
	 (let ((standard-output (current-buffer)))
	   (prin1 (car values))))
      (prog1
          (prin1 (car values) t)
        (let ((str (eval-expression-print-format (car values))))
          (if str (princ str t)))))))
