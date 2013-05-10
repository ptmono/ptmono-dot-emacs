

(defun d-windowp ()
  ""
  (if (equal window-system 'w32)
      t
    nil))

;(defvar d-dir-emacs (if (d-windowp)
;			   "g:\.emacs.d/" ;debug for test
;
;			   ; the location of init.el is the location of emacs.exe
;;			   (concat default ".emacs.d/")
;
;			 "/home/ptmono/.emacs.d/")
;  "The directory for emacs. configuration, packages.Note that
;  this contains last /")


(defvar d-localhost "http://localhost/~ptmono")

;(defcustom d-note-section-regexp "^\\.#[A-z]?[0-9]+\\|^*+ " "for planner's note section")
(defvar d-note-section-regexp "^\\.#+[A-z]?[0-9]+\\|^[*\f]+ \\|^[A-Z]+: \\|^[@\f]+ " "for planner's note section")


;;; === Type
;;; --------------------------------------------------------------


(defun d-libs/symbol (input)
  "Returns symbol. INPUT is a string or symbol"
  (unwind-protect
      (condition-case err
	  (setq ak (intern input))
	;(error (message (format "Caught exception: [%s]" err))))
	(error
	 (if (symbolp input)
	     (setq ak input)
	   (error "INPUT can be a string or a symbol.")
	   )))
    ak))
      
	    

    

;;; === String
;;; --------------------------------------------------------------
(defun d-string-count (string)
  "The function returns the number of string character with space"
  (let ((a string)
	(b))
    (with-temp-buffer
      (insert a)
      (setq b (- (point-max) 1)))
    b))


(defun d-lib-replace-regexp (regexp to-string &optional delimited start end)
  "replace-regexp is modified for convenient."
  (interactive
   (let ((common
	  (query-replace-read-args
	   (concat "Replace"
		   (if current-prefix-arg " word" "")
		   " regexp"
		   (if (and transient-mark-mode mark-active) " in region" ""))
	   t)))
     (list (nth 0 common) (nth 1 common) (nth 2 common)
	   (if (and transient-mark-mode mark-active)
	       (region-beginning))
	   (if (and transient-mark-mode mark-active)
	       (region-end)))))
  (mark-whole-buffer)
  (perform-replace regexp to-string nil t delimited nil nil start end))


(defun d-libs-check-beginning-of-line ()
  "If current point is in beginning-of-line, then return t. Other will returns nil"
  (let* ((current-point (point))
	 (beginning-point (save-excursion
			    (move-beginning-of-line nil))))
    (if (equal current-point beginning-point)
	t
      nil)))


(defun d-libs-string-delete-whitespace (string)
  (with-temp-buffer
    (insert string)
    (delete-whitespace-rectangle (point-min) (point-max))
    (buffer-string)))


(defun d-libs-string-create-zero-prefix (string num &optional pre_str)
  "(d-libs-string-create-zero-prefix \"15\" 2) will return
  \"0015\""
  (let* ((prefix (if pre_str
		     pre_str
		   "0")))
    (while (< 0 num)
      (setq string (concat prefix string))
      (setq num (- num 1)))
    string))


(defun d-libs-string-replace-regexp (regexp to-string contents)
  "Replace REGEXP to TO-STRING in CONTENTS. Returns the replaced
contnets."
  (interactive)
  (let* (result)
    (with-temp-buffer
      (insert contents)
      (goto-char (point-min))
      (replace-regexp regexp to-string)
      (setq result (buffer-substring (point-min) (point-max))))
    result)
  )


;;; === List
;;; --------------------------------------------------------------
(defun d-lib-list-element-x-y (variable &optional x y z)
  "함수는 단순한 list의 element를 얻기위해 만들어 졌다. 여기서
단순하다는 말은 alist의 계산을 생각치 않는다는 말이다. 함수는
list의 순차적인 x y z 을 return x가 없으면 y z 도 없다. y가 없으면
z도 없다.

VARIABLE 은 분석될 list이다. X, Y, Z 는 숫자이거나 nil
이다. 여기서 Z가 있을 경우에는 X, Y는 nil이 될 수 없다. Z는
nil이고 Y가 있을 경우에는 X는 nil이 될 수 없다.

함수를 만드는 다른 방법으로 변수를 하나두고 차례대로 계산하면 되겠다.
e.g)
  (if x
      (setq variable (nth x variable)))
  (if y
      (setq variable (nth y variable)))
  (if z
      (setq variable (nth z variable))) 

이것은 2 nil 3 같은 경우에는 잘못된 답을 리턴하므로 따로 error
handlling이 필요하다.

함수는 별로 필요는 없을 듯 하다. car cdr을 사용하면 되기 때문이다.
"
  (cond ((not x) ;nothing
	 variable)
	((and x (not y)) ;only x
	 (nth x variable))
	((and x y (not z))
	 (nth y (nth x variable)))
	((and x y z)
	 (nth z (nth y (nth x variable))))
	(t
	 (message "The variable x y is only number when z is exists."))))

(defun d-libs-list/to-string (list)
  "LIST is a list of strings. The function will merge the list as
a string where string will separated by a space."
  (let* ((listc list)
	 (str "")
	 (startp t))
    (while listc
      (if (not startp)
	  (setq str (concat str " " (car listc)))
	(setq str (car listc))
	(setq startp nil))
      (setq listc (cdr listc)))
    str))

;;; === Variable
;;; --------------------------------------------------------------
(defvar d-lib-variables "/home/ptmono/myscript/variables" "")
(defvar d-lib-variables-value-regexp ".*" "")


(defun d-lib-var-value (variable &optional variables-file)
  "The function returns the value of VARIABE. The function opens
VARIABLES-FILE if it is exist. The default is
d-lib-variables. Then the functions searchs the VARIABLE and
returns the value of variable.

함수는 string을 return 한다. 만약 변수가 list type이라면 read
function으로 변환해 주어야 한다.

VARIABLE is a string. VARIABLES_FILE is the name variables file.

함수는 변수가 있는지 없는지 검사하는 곳에도 사용될 수가
있다. 변수가 없으면 함수는 nil을 return 한다."
  (if variable
      (let (value string)
	(with-temp-buffer
	  (insert-file-contents (if variables-file variables-file d-lib-variables))
	  (goto-char (point-min))
	  (re-search-forward (concat "^" variable " \\(" d-lib-variables-value-regexp "\\)") nil t)
	  (setq value (match-string 1))))
    nil))
  


(defun d-lib-var-add (variable value &optional variables-file)
  "The function modifies the the value of variable. IF the
variable does not exists, then the function adds the variable and
the value of variable to the end of the file.

variables-file는 한 line에

^VARIABLE VALUE

을 가진다. VALUE는 string이다. list를 주려면 prin1-to-string을 이용하여
list를 string으로 바꾸어주자.

If VARIABLES-FILE does not exists, default value is d-lib-variables."
;  (interactive (list (progn
;		       (let (varp var)
;			 (setq var (read-string "Input the variable"))
;			 (if (d-lib-var-value var)
;			   (setq mes "The variable already exists."))))))
; todo Complete interactive 만약 input된 변수가 이미 존재한다면, 변수가 이미
; 존재한다는 것을 알려주고, 변수를 바꾸어줄 것인지를 물어본다.

  (let ((var-file (if variables-file variables-file d-lib-variables))
	(app-value (concat variable " " value)))
    (with-temp-file var-file
      (insert-file-contents var-file)
      (goto-char (point-min))
      (if (d-lib-var-value variable)
	  (let* ((match (re-search-forward (concat "^\\(" variable "\\)" " \\(" d-lib-variables-value-regexp "\\)") nil t))
		 (pre-value (match-string 2))
		 (beg-value (match-beginning 2))
		 (end-value (match-end 2)))
	    (delete-region beg-value end-value)
	    (goto-char beg-value)
	    (insert value))
	(goto-char (point-max))
	(if (looking-at "^$")
	    (insert app-value)
	  (newline)
	  (insert app-value))))))


;;; === Window and Frame
;;; --------------------------------------------------------------
(defun d-window-name (hol ver)
  "This function returns the window name.
 +---------+---------+
 |         |         |
 |         |         |
 |    1    |         |
 |         |    3    |
 +---------+         |
 |         |         |
 |    2    +---------+
 |         |    4    |
 +---------+---------+
1 --> ver is 1 and hol is 1
2 --> ver is 2 and hol is 1
3 --> ver is 1 and hol is 2
4 --> ver is 2 and hol is 2

think following x-y catesian coordinate system
"
  (let ((x (1+ hol))
	(y (1+ ver)))
    (condition-case nil
	(nth y (nth x (nth 0 (window-tree))))
      (error
       (nth x (nth 0 (window-tree)))))))


; d-citation-substring : 문장의 원하는부분을 substitute 한다.


(defun d-window-separate ()
  "If window is one window, then separate the window holizontally."
  (if (one-window-p)
      (split-window nil nil t)))



; See elisp.frame

(defun d-frame-set-phw-with-pixel(geometry)
  "The frame-char-height returns the pixel per line. phw is short
  for Point Height Width.

GEOMETRY has the form \"HEIGHTxWIDTH+LEFT-TOP\" e.g
\"35x70+10-0\". Where left is x-coordinate, top is y coordinate,
height and width specify the size of frame.
"
; The result of the function (x-parse-geometry "35x70+10-0" is
; ((height . 70) (width . 35) (top - 0) (left . 10))
  (let* ((geo-alist (x-parse-geometry geometry))
	 (pixel-h (cdr (assoc 'height geo-alist)))
	 (pixel-w (cdr (assoc 'width geo-alist)))
	 (pixel-x (cdr (assoc 'left geo-alist)))
	 ;top has a minus value
	 (pixel-y (- (cdr (assoc 'top geo-alist))))
	 (current-frame (window-frame (frame-selected-window))))

; 프래임의 문자의 높이. 단위 pixel
;frame-char-height
;frame-char-width

; 프래임의 높이. 단위 char
;frame-height
;frame-width

    ; if no value
    (cond
     ((not pixel-h) (setq pixel-h (* (frame-height) (frame-char-height))))
     ((not pixel-w) (setq pixel-w (* (frame-width) (frame-char-width))))
     ((not pixel-x) (setq pixel-x (frame-parameter (window-frame (frame-selected-window)) 'left)))
     ((not pixel-y) (setq pixel-y (frame-parameter (window-frame (frame-selected-window)) 'top))))

    (set-frame-position current-frame pixel-x pixel-y)
    (set-frame-size (window-frame (frame-selected-window)) 200 80)
    (set-frame-height current-frame (/ pixel-h (frame-char-height)))
    (set-frame-width current-frame (/ pixel-w (frame-char-width)))))


(defun d-frame-set-phw(geometry)
  "Resize current frame. GEOMETRY is the form
\"HEIGHTxWIDTH+LEFT-TOP\". e.g \"35x70+10-0\". The unit of HEIGHT
is line. So HEIGHT is the number of lines. The unit of WIDTH is
character. So WIDTH is the number of characters. LEFT is
x-coordinate of left top point of the frame. TOP is y-coordinate.
The unit of LEFT and TOP is pixel.

The height of a character is the height of a line. Also The width
of character is the width of character. The function
'frame-char-height and frame-char-width returns the size of a
character as the unit of pixel.

It is possible that the values of geometry are \"84x100\" \"+300\"

Problem:
 - Does not do in maximum mode.
"
  (modify-frame-parameters (window-frame (frame-selected-window)) (x-parse-geometry geometry)))


(defun d-window-info/splited-windowp ()
  (listp (nth 0 (window-tree))))


(defun d-window-info/left-window ()
  (d-window-info/window 2))

(defun d-window-info/right-window ()
  (d-window-info/window 3))

(defun d-window-info/window (n)
  (let* ((tree (condition-case nil
		   (nth n (nth 0 (window-tree)))
		 (error nil)))
	 result)
    (if (and tree (listp tree))
	(dolist (win tree)
	  (if (windowp win)
	      (setq result (cons win result))))
      (setq result tree))
    result))

(defun d-window/get-not-matched (windows matched-window)
  "Returns a list not matched windows. WINDOWS is a list of window.
MATCHED-WINDOW is the window to be not matched."
  (let* (result)
    (condition-case nil
	(dolist (win windows)
	  (unless (eq win matched-window)
	    (setq result (cons win result))))
      (error nil))
    result))

(defun d-window/get-matched (windows matched-window)
  (let* (result)
    (condition-case nil
	(dolist (win windows)
	  (if (eq win matched-window)
	      (setq result (cons win result))))
      (error nil))
    result))

(defun d-window-info/rigth-window ()
  (condition-case nil
      (nth 3 (nth 0 (window-tree)))
    (error nil)))
      
  
(defun d-window-other-window/get-target ()
  (let* ((splited-windowp (d-window-info/splited-windowp))
	 (current-window (selected-window))
	 (left-windows (d-window-info/left-window))
	 (right-windows (d-window-info/right-window))

	 ;; Where the current buffer
	 (left-windowp (d-window/get-matched left-windows current-window))
	 (right-windowp (d-window/get-matched right-windows current-window))
	 result)

    (cond ((not splited-windowp)
	   nil)
	  (left-windowp
	   (nth 0 (d-window/get-not-matched left-windows current-window)))
	  (right-windowp
	   (nth 0 (d-window/get-not-matched right-windows current-window))))))

(defun d-window-open-other-window (buffer-name)
  "Open BUFFER-NAME other window. And return the target window."
  (interactive)
  (let* ((splited-windowp (d-window-info/splited-windowp))
	 (target (d-window-other-window/get-target)))

    (cond ((not splited-windowp)
	   (split-window-horizontally)
	   (setq target (nth 3 (nth 0 (window-tree))))
	   (set-window-buffer target buffer-name))

	  ;; This window is vertically separated
	  (target
	   (set-window-buffer target buffer-name))
	  
	  (t
	   (split-window-vertically)
	   (setq target (d-window-other-window/get-target))
	   (set-window-buffer target buffer-name)))
    target))

(defun d-other-window (buffer-name)
  "See d-window-open-other-window"
  (d-window-open-other-window buffer-name))







;;; === Text
;;; --------------------------------------------------------------
(defun d-append-to-file (text file)
  "To insert file, we can use the function append-to-file. This
use the region of current buffer. I need a direct way.

We also can use write-region.
"
  (with-temp-buffer
    (insert text)
    (append-to-file (point-min) (point-max) file)))

(defun d-write-to-file (text file)
  ""
  (with-temp-buffer
    (insert text)
    (write-region (point-min) (point-max) file)))


(defun strip-text-properties(txt)
  (set-text-properties 0 (length txt) nil txt)
      txt)



;;; === File
;;; --------------------------------------------------------------
(defun d-file-trash ()
  "Delete current buffer file"
  (interactive)
  (let ((file (buffer-file-name)))
    (shell-command (concat "mv " file " ~/tmp/trash/"))
    (message (concat "You can restore " file " from ~/tmp/trash"))))

(defun d-trash-buffer ()
  (interactive)
  (d-file-trash))


(defun d-sudo-file-move ()
  "for file moving"
  (interactive)
  (let ((aa (read-file-name "What?: " "/media/data/ebooks/computers/"))
	(bb (dired-get-file-for-visit)))
    (shell-command (concat "sudo mv \"" bb  "\" " aa))))


(defun d-dired-file-del-sudo ()
  "for file deleting"
  (interactive)
  (let	((bb (dired-get-file-for-visit)))
    (shell-command (concat "sudo rm -r \"" bb "\""))))


(defun d-buffer-delete-last-newline ()
  "The function deletes last ^$ line"
  (goto-char (point-max))
  (if (re-search-forward "^$" nil t)
      (backward-delete-char-untabify 1)))


(defun d-buffer-shell-command ()
  "shell command to current buffer file. The function
shell-command-read-minibuffer is used for completion"
  (interactive)
  (let* ((file (buffer-file-name))
	 (files (list file))
	 (directory (file-name-directory file))
	 (command (shell-command-read-minibuffer "! on : " directory)))
    (message (shell-command-to-string (concat command " " file)))))


;;; === Buffer
;;; --------------------------------------------------------------

(defun d-buffer/create-new-empty (buffer-name)
  "Create new empty buffer."
  (when (get-buffer buffer-name)
    (kill-buffer buffer-name))
  (get-buffer-create buffer-name))

    
  
  


;;; === Screenshot
;;; --------------------------------------------------------------
(unless (boundp 'd-dir-emacs)
  (defvar d-dir-emacs (concat (getenv "HOME") "/.emacs.d/")))

(defvar d-libs-image/default-dir (concat d-dir-emacs "imgs/") "")

(defvar d-libs-image/dir nil)

(defun d-libs-image/setDir (&optional dirname)
  (unless dirname
    (setq dirname (read-directory-name "Directory: " default-directory)))
  (setq d-libs-image/dir (expand-file-name dirname)))

(defun d-libs-image/unsetDir ()
  (setq d-libs-image/dir nil))
  

(defun d-libs-image-max-number ()
  "Same code with d-citation-max-number. The function created for
  ~/myscript/screenshot.sh
"
  (let* ((image-dir (if d-libs-image/dir
			d-libs-image/dir
		      d-libs-image/default-dir))
	 (d-image-file-alist (directory-files image-dir t "image[0-9]+\\.[A-z0-9]+"))
	 (carlist (car d-image-file-alist))
	 (cdrlist (cdr d-image-file-alist))
	 numlist)
    (while carlist
      (string-match "image\\([0-9]+\\)" carlist)
      (setq numlist (cons (string-to-number (match-string 1 carlist)) numlist))
      (setq carlist (car cdrlist))
      (setq cdrlist (cdr cdrlist)))
    (let ((b 0))
      (dolist (a numlist b)
	(setq b (max a b)))
      b)))


(defun d-libs-image/maxNumber (dir)
  (let* ((d-image-file-alist (directory-files dir t "image[0-9]+\\.[A-z0-9]+"))
	 (carlist (car d-image-file-alist))
	 (cdrlist (cdr d-image-file-alist))
	 numlist)
    (while carlist
      (string-match "image\\([0-9]+\\)" carlist)
      (setq numlist (cons (string-to-number (match-string 1 carlist)) numlist))
      (setq carlist (car cdrlist))
      (setq cdrlist (cdr cdrlist)))
    (let ((b 0))
      (dolist (a numlist b)
	(setq b (max a b)))
      b)))


  

(defun d-libs-image-max-number-plus-one()
  "Return function d-citaion-max-number + 1"
  (+ (d-libs-image-max-number) 1))

(defun d-libs-image/getFilename()
  (interactive)
  (let* ((image_dir (if d-libs-image/dir
			d-libs-image/dir
		      d-libs-image/default-dir))
	 (new_num (number-to-string (d-libs-image-max-number-plus-one)))
	 ;; Default extension is jpg. other is png.
	 (extension (if d-libs-image/dir ;We need more flexible way
			"png"
		      "jpg"))
	 (full_filename (concat image_dir
				"image"
				new_num
				"."
				extension))
	 )
    full_filename))

(defun d-libs-image/getExtension(filename)
  "FILENAME contains abpath like /tmp/img. The return will be
/tmp/img.jpg or /tmp/img.png. You can add extension."
  (let* ((exts (list "jpg" "png"))
	 abname-with-ext
	 ext
	 result)
    (while exts
      (setq ext (car exts))
      (setq exts (cdr exts))

      (setq abname-with-ext (concat filename "." ext))
      (if (file-exists-p abname-with-ext)
	  (setq result ext)))
    ext))



;;; === Process
;;; --------------------------------------------------------------
(defun d-libs/detect-end-process-and-kill-buffer (process-name buffer-name second)
  (let* ((pid (get-process process-name)))
    (if pid
	(run-at-time (format "%d sec" second) nil 
		     'd-libs/detect-end-process-and-kill-buffer process-name buffer-name second)
      (kill-buffer buffer-name))))


;;; === Etc
;;; --------------------------------------------------------------
(defun d-insert-times(start end)
  ""
  (interactive (list (read-number "Start: ")
		     (read-number "End: ")))
  (if (< start end)
      (while (not (equal start end))
	(insert (format " - %s:30~%s:30" (number-to-string start) (number-to-string (+ start 1))))
	(newline)
	(setq start (+ start 1))))
  )


(defun d-go-worknote ()
  ""
  (interactive)
  (let* ((filename (concat "~/plans/" d-worknote-name ".muse")))
    (find-file "~/plans/worknote2.muse"))
  )

(provide 'd-library)

