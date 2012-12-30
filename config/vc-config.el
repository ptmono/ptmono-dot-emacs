
;; The version 24.0.50.1 of vc of emacs has a problem with
;; vc-rcs-create-tag. It has 4 argument. But called with 3 argument by
;; vc-call-backend. It is the reason why vc-create-tag invokes error.
;; See [[worknote.muse#1111031823]]
(defun vc-rcs-create-tag (dir name branchp)
  (when branchp
    (error "RCS backend does not support module branches"))
  (let ((result (vc-tag-precondition dir)))
    (if (stringp result)
	(error "File %s is not up-to-date" result)
      (vc-file-tree-walk
       dir
       (lambda (f)
	 (vc-do-command "*vc*" 0 "rcs" (vc-name f) (concat "-n" name ":")))))))
