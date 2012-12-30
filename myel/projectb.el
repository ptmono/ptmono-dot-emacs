;; Convenient temporary function for project

(defun d-test-server ()
  ""
  (interactive)
  (let* (url
	 msg)
    
    (setq url "http://localhost/~ptmono/0ttd/0ppf2/ppf/")
    ;;(setq url "http://localhost/~ptmono/0ttd/0ppf2/server/htmls/comment.html")
    (setq msg (concat "gBrowser.selectedTab = gBrowser.addTab(\"" url "\");"))
    (comint-send-string (inferior-moz-process) msg)
    (call-process-shell-command "wmctrl -a Firefox")
    ))


(defun d-test ()
  (interactive)
  (d-test-server))


(defun goto-work ()
  (interactive)
  (find-file "~/works/0cvs/trunk/eManual3/"))

(goto-work)

;;(load-file "/home/ptmono/works/0cvs/trunk/ppf/tools/ppf.el")
;;(find-file "~/public_html/0ttd/0ppf2/ppf/")
;;(find-file "~/works/0cvs/trunk/ppf/tools/")



(provide 'projectb)
