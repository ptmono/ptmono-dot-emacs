
(defvar d-dired-find-file-lists
  '(("html" d-dired-find-file-html)
    ("php" d-dired-find-file-php))
  "list of extensions and functions used for d-dired-find-file")

;; IF file extension is one of d-dired-find-file-lists
;; condition is public_html, directory
(defun dired-find-file ()
  "Modified from dired-find-file. In Dired, visit the file or directory named on this line.
함수는 현재 dired 의 cursor 의 파일명의 확장자가
d-dired-find-file-lists 에 포함되어 있는지를 검사한다. 확장자가
p있다면 함수는 단지 확장자에 규정한 함수를 불러오는 역활만을
한다."
  (interactive)
  ;; Bind `find-file-run-dired' so that the command works on directories
  ;; too, independent of the user's setting.
  (let* ((find-file-run-dired t)
	 (file-name (dired-get-file-for-visit))
	 (extension (file-name-extension file-name))
	 (extension-list (assoc extension d-dired-find-file-lists)))
    (if extension-list
	(funcall (car (cdr extension-list)) file-name)
      (find-file (dired-get-file-for-visit)))))


(defun d-dired-public-file-name (name)
  "If name contains public_html, the function returns sub-file
  name that is the string following public_html. e.g) If file
  name is /home/ptmono/public_html/aaa/index.html, the function
  returns /aaa/index.html. If else returns nil"
  (interactive)
  (if (string-match "\\(.*\\)public_html\\(.*\\)" name)
      (match-string 2 name)))



(defun d-dired-find-file-html (name)
  (let ((public-file-name (d-dired-public-file-name name)))
    (if public-file-name
	(w3m-browse-url (concat d-localhost public-file-name) t)
      (w3m-browse-url name t))))

(defun d-dired-find-file-php (name)
  (let ((public-file-name (d-dired-public-file-name name)))
    (if public-file-name
	(w3m-browse-url (concat d-localhost public-file-name) t)
      (find-file-noselect name))))



;;; === Compression
;;; --------------------------------------------------------------
;; From http://stackoverflow.com/questions/1431351/how-do-i-uncompress-unzip-within-emacs

(eval-after-load "dired"
  '(define-key dired-mode-map "z" 'dired-zip-files))

(defun dired-zip-files (zip-file)
  "Create an archive containing the marked files."
  (interactive "sEnter name of zip file: ")

  ;; create the zip file
  (let ((zip-file (if (string-match ".zip$" zip-file) zip-file (concat zip-file ".zip"))))
    (shell-command 
     (concat "zip -r " 
             zip-file
             " "
             (concat-string-list 
              (mapcar
               '(lambda (filename)
                  (concat "\"" (file-name-nondirectory filename) "\""))
               (dired-get-marked-files))))))

  (revert-buffer)

  ;; remove the mark on all the files  "*" to " "
  ;; (dired-change-marks 42 ?\040)
  ;; mark zip file
  ;; (dired-mark-files-regexp (filename-to-regexp zip-file))
  )

(defun concat-string-list (list) 
   "Return a string which is a concatenation of all elements of the list separated by spaces" 
    (mapconcat '(lambda (obj) (format "%s" obj)) list " "))

;;; === Dired-x
;;; --------------------------------------------------------------
;; To hide *~ files. To show *~ files, use M-x dired-omit-mode
(load-library "dired-x")
(add-hook 'dired-load-hook
	  (function (lambda () (load "dired-x"))))
(add-hook 'dired-mode-hook
	  (lambda ()
	    (dired-omit-mode 1)))
