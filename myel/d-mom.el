(defun d-mom (type)
  "O means out. I is mean in"
  (let* ((time (format-time-string "%y%m%d%H%M%S" (current-time)))
	 (file "/home/ptmono/plans/0812231558.muse"))
    (shell-command-to-string (concat "echo -en \" " type time "\" >> " file))))


(defun d-mom-out ()
  ""
  (interactive)
  (d-mom "O"))


(defun d-mom-in ()
  ""
  (interactive)
  (d-mom "I"))


(defun d-mom-me ()
  "I am late than mom"
  (interactive)
  (d-mom "M"))

(defun d-mom-eat ()
  "Mon eat in home"
  (interactive)
  (d-mom "E"))
