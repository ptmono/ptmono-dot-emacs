;; TODO: Clear

;;; requires
;; - muse-mode
;; - planner-mode

;;; explanation

;M-x d-citations functions을 이용하여 citation을 할수가 있다.
;기본적인 citation은 'd-citation으로 planner의 planner-annotation-functions에 있는 함수들을
;연속적으로 대입하여 얻어낸 값을 다른 윈도우(next-window)에 cite한다.
;이함수의 기본적인 함수는 다음과 같다.
;(defcustom planner-annotation-functions
;  '(planner-annotation-from-planner-note
;    planner-annotation-from-planner
;    planner-annotation-from-wiki
;    planner-annotation-from-dired
;    planner-annotation-from-file-with-position)
;각각은 current-buffer가 planner-note이냐 planner냐 wiki냐 dired냐 file이냐에
;따라 정해진다. 원하는 부분이 있다면 추가하면 되겠다. add-to-list를 이용하자.
;
;
;;;추가사항
;
;C-u를 이용하여 추가적인 부분으로 다음 세가지를 선택할 수가 있다. 이 list는 d-citation-function-alist
;가 가지고 있다. add-to-list를 이용하여 함수를 추가하자.
;
;1. d-citation2
;기본적인 기능의 앞부분에 "!!from: "을 첨자한다.
;
;2. d-amazon-citation
;amazon.com의 best seller부분에서 책이름과 지은이 발행연도를 cite 한다. w3m상에서 구동한다.
;
;3. d-dired-ciattion-book
;dired상에서 파일을 [[파일의 절대경로][파일명]]으로 cite한다.
;
;
;;;;구동개요
;
;기본적으로 d-citation으로 구동하고 C-u를 통해서
;1,2,3을 불러올수가 있고, 1은 불러왔을 경우 1번만 실행되고
;2,3은 그 모드 안에서는 계속적으로 실행이된다.(각각 w3m-mode, dired-mode
;이며 이 모드에서 실행하다 다른 모드에서 실행을 하면 다시 d-citation이 실행
;된다. 이 부분은 d-citation-function-alist에서 결정할 수가 있다.
;
;
;0702201825 w3m에서 web상의 image를 muse로 삽입하기 위하여 d-citation-w3m-image 함수를
; 작성. ~/files/에서 마지막 image 번호를 뽑는 함수를 d-insert-last-image로 부터 분리하여
; d-citation-max-number를 작성. f10을 이용하여 w3m의 image에서 바로 citation 하도록 하였다.

;;; Logs

;; 1201050852 Fixed section facility
;; 1109071616 Added section facility
;; 0911300650 Added inter facility

;======================================================================
;;; TODO                                                            ;;;
;======================================================================

;; 0805200045 ::: re-make the structure of d-citation more simplely.
;; 
;;  Current pre-doc is bad. Re-write pre-doc.

;; 1109072049 ::: re-write entire functions. Use d-worknote-section-info.


;======================================================================
;;; Problems                                                        ;;;
;======================================================================
;; 1105020510 C-u C-c d c note uses absolute path like
;; /home/ptmono/plans/apache.muse#1104181456. The link is blocken in
;; Windows.




(require 'muse)
(require 'planner)
;(require 'd-worknote2)

(defvar d-citation-function-alist
  '(("amazon" d-amazon-citation w3m-mode)
    ("ebook" d-dired-citation-book dired-mode)
    ("from" d-citation2 nil)
    ("file" d-dired-citation-file nil)
    ("annotation" d-citation-annotation nil)
    ;; ("note" d-citation-note major-mode)
    ;; ("notes" d-note major-mode)
    ("image" d-insert-last-image nil)
    ("date" d-citation-date-position nil)
    ("fr" d-citation-from nil)
    ("last" d-citation-last-file nil)
    ("point" d-citation-point nil)
    ("anchor" d-citation-anchor nil)
    ("anchor-absolute" d-citation-anchor-absolute nil)
    ("note" d-citation-planner-note-with-title nil)
    ("note-title" d-citation-planner-note-with-title-only nil)
    ("note-short" d-citation-planner-note-with-title-short nil)
    ("note-file" d-citation-file/cite nil)
    ("nf" d-citation-file/cite nil)
    ("inter" d-citation-inter)
    ("section" d-citation-section/insert)
    ("sikuli" d-citation-sikuli/insert))
  "list for 'd-citation the list form is
name function mode. name is used to call function.
if mode is nil, its name is do not restored
so that function is used only one time. If the mode is non-nil,
it used without the prefix in the mode.")



(defvar d-citation-del-regexp-list
  '(" - [a-zA-Z0-9\.]* | Google Groups"
    " | Google Groups"
    " | KLDP"
    "KLDPWiki: "
    " | Hardware Secrets"
    )
  "some web citation contains \"|\" and regular strings do not need.
This variables are regexps of that strings"
  )



(defvar d-citation-prefix nil
  "car of d-citation-function-alist")

(defvar d-citation-prefix2 nil
  "to set continuous using of the added functions")

(defvar d-wbuffer-name nil
  "buffer to be write")

(defvar d-prefix2 nil)




;; core function
(defun d-citation ()
  "if you want to choose the mode, use prefix. if you want to write to other buffer
use prefix."
  (interactive)
  (when (member (buffer-file-name) d-worknote-list)
    (if current-prefix-arg
	()
      (progn
	;; (insert "!!!from: ")
	(other-window 1))))
	
  (let ((d-citation-prefix (if current-prefix-arg
				 (completing-read "Choose : " d-citation-function-alist)
			       d-citation-prefix2)))

    ;; 위에서 d-citation-prefix 값은 "amazon"을 받게 된다. 계속적으로
    ;; citation 할 수 있는 것은 d-citation-prefix가 존재하기 때문이다.
    (if d-citation-prefix
	;; d-citation-prefix2 는 "amazon"이 된다.
	(progn (setq d-citation-prefix2 d-citation-prefix)
	       (d-citation-type d-citation-prefix))
      (d-citation-annotation))))

;follwing main function

(defun d-citation-type (type)
  (let* ((con (assoc type d-citation-function-alist))
	(name (car con))
	(func (car (cdr con)))
	(mode (car (cddr con))))
    ;; mode
    (if (or (eq major-mode mode) (eq 'major-mode mode))
	(progn (setq d-citation-prefix2 name)
	       (funcall func))
      ;; mode but do not same
      (if (eq mode t)
	  (funcall func)
	(if mode
	    (progn
	      (setq d-citation-prefix2 nil)
	      (funcall func))
	  ;; mode is nil
	  (progn
	    (setq d-citation-prefix2 nil)
	    (funcall func)))))))


;; core function of d-citation
(defun d-citation-annotation ()
  "insert current the citation to the next window
0611292336과 같은 label에 대한 정보는 'd-planner-goto-label
을 참고하자.
"
  (interactive)
  (let* ((word (current-word))
	 (file-name (buffer-file-name)))
    ;; to use d-planner-goto-label
    (let* ((annotation (run-hook-with-args-until-success 'planner-annotation-functions))
	   (str (d-citation-del-string annotation)))
      (if str
	  (progn (select-window (next-window)) (insert str))
	(progn (select-window (next-window)) (insert annotation))))))


;;; === Citation string control
;;; --------------------------------------------------------------
;;; citation의 필요 없는 부분을 삭제.

(defun d-citation-del-string (string) ; string is annotation
  "d-citation-del-regexp-list의 element를
d-citation-else-strings에 값이 있을 때 까지 적용한다."
  (let ((str nil) 
	(cdr d-citation-del-regexp-list))
    (while (and (equal str nil) (not (equal cdr nil)))
      (let* ((car (car cdr)))
	(setq str (d-citation-else-strings string car))
	(setq cdr (cdr cdr))))
    str))



;;지워질 문장이 match되면 문장을 지운값을 설정한다.
(defun d-citation-else-strings (string regexp)
  "string에서 regexp를 제거하여 return 한다. 현재 muse link에
적용된다. string에서 regexp를 찾지못한다면 nil을 return 한다.

todo : match 위치인 0 1 등을 사용할 수 있게끔 한다.
"
  (if (string-match regexp string)
      
      ; length는 문장의 길이를 return 한다. 시작은 1부터이다. substring은 0부터
      ; 시작이다.  그러므로 length가 7을 return한다면, 0~6까지 사용할 수가 있다는
      ; 말이다.
      (let ((length (length string))  ; (- (length string) 1))
	    (begin (match-beginning 0)) ; (- (match-beginning 0) 1))
	    (end (match-end 0))) ; (+ (match-end 0) 1)))

      ;when string matchs at the point of start
	(concat (substring string 0 begin) (substring string end length)))))


;; 문장의 원하는 부분을 substitute 한다.
(defun d-citation-substring (string regexp subs)
  "string is substited subs by regexp match 1. Using example, see
  d-citation-from
"
  (if (string-match regexp string)
      (let ((length (length string))
	    (begin (match-beginning 1))
	    (end (match-end 1)))
	(concat (substring string 0 begin) subs (substring string end length)))))
	    

(defun d-citation-date-position ()
  "To create \"^#0701181321\" link on muse-mode"
  (let* ((word (current-word))
	 (file-name (buffer-file-name)))
    (if (and word
	     (string-match ".*\\([A-z]?[0-9]\\{10\\}\\).*" word))
	(when (not (string-match "^.#" (thing-at-point 'line)))
	  (progn
	    (select-window (next-window))
	    (insert (concat "[[lisp:/(d-planner-goto-label \"section\" \"" file-name "\" \"" word "\")][" word "]]"))))
      (message "You need to move the cursor to the date"))))


					;d-citation에 from을 붙인것 뿐이다.
					;[[/usr/local/info/]]
					;planner-annotation-functions을 하나씩 실행시킨다.

;;; === Citation functions
;;; --------------------------------------------------------------
(defun d-citation2 ()
  "insert current the citation to the next window"
  (interactive)
  (let* ((annotation (run-hook-with-args-until-success 'planner-annotation-functions)))
    (progn (select-window (next-window)) (insert (concat "!!from: " annotation " ")))
    ))
					;dired에서 파일을 citation 해온다.
					;(when (eq major-mode 'dired-mode)를 이용하여 현재의 모드를 확인 할 수가 있겠다.
(defun d-dired-citation-book ()
  "In dired, call this function will make the file explicit link at
WBUFFER. You can specify WBUFFER with C-u(prefix command."
  (interactive)		
  (let ((path (dired-get-filename nil nil))
	(filename (dired-get-filename 'no-dir nil))
	(buffer1 (if current-prefix-arg
		     (setq d-wbuffer-name (read-buffer "writting buffer: "))
		   (if d-wbuffer-name
			d-wbuffer-name
		      (setq d-wbuffer-name (read-buffer "writting buffer: ")))))
	(explanation (read-string "comment :")))
    (save-window-excursion
      (switch-to-buffer buffer1)
      (insert (concat " - " "[[" path "][" filename "]]" ": " explanation "\n")))))


(defun d-dired-citation-file ()
  "citate file link"
  (interactive)
  (let ((path (dired-get-filename nil nil))
	(filename (dired-get-filename 'no-dir nil)))
    (other-window 1)
    (insert (concat "[[" path "][" filename "]]"))))


					;하나의 mode로서 만들어야 하겠다.
(defun d-amazon-citation ()
  "This function restore the information of book at the part of best seller of
amazon.com"
  (interactive)
  (let* ((aa (progn (beginning-of-line) (d-amazon-book-line)))
	 (rank (match-string 1))
	 (bookname (match-string 2))
	 (all (match-string 3))
	 (author (match-string 4))
	 (year (match-string 5))
	 (buffer1 (if current-prefix-arg
		      (setq d-wbuffer-name (read-buffer "writting buffer: "))
		    d-wbuffer-name)))
    (save-window-excursion
      (if buffer1
	  (progn (switch-to-buffer buffer1)
		 (insert (concat " " rank " **" bookname "** " all "\n")))
	(progn (select-window (next-window))
	       (insert (concat " " rank " **" bookname "** " all "\n"))))
      (message "citated"))))


(defun d-amazon-book-line ()
  (if (re-search-forward "\\([0-9]+\\). +\\(.+\\)\\( by \\(.+\\) (.+ - \\(.+\\)[)]\\)")
      (goto-char (match-beginning 0))))

(defun d-amazon-book-next-line ()
  (interactive)
  (if (re-search-forward "\\([0-9]+\\). +\\(.+\\)\\( by \\(.+\\) (.+ - \\(.+\\)[)]\\)" nil t 2)
      (goto-char (match-beginning 0))))



(defun d-citation-note ()
  "you can insert some sentence from minibuffer to the specific buffer"
  (interactive)
  (let ((buffer1 (if current-prefix-arg
		      (setq d-wbuffer-name (read-buffer "writting buffer: "))
		    (if d-wbuffer-name
			d-wbuffer-name
		      (setq d-wbuffer-name (read-buffer "writting buffer: ")))))
	 (content (read-string "note: ")))
    (setq d-prefix2 major-mode)
    (save-window-excursion
      (switch-to-buffer buffer1)
      (insert (concat content "\n\n")))))


(defun d-citation-point ()
  "insert current the citation to the next window
0611292336과 같은 label에 대한 정보는 'd-planner-goto-label
을 참고하자.
"
  (interactive)
  (let* ((word (current-word))
	 (file-name (buffer-file-name)))
					;to use d-planner-goto-label
    (let* ((annotation (planner-annotation-from-file-with-position))
	   (str (d-citation-del-string annotation)))
      (if str
	  (progn (select-window (next-window)) (insert str))
	(progn (select-window (next-window)) (insert annotation))))))


;;; === Insert image
;;; --------------------------------------------------------------
;; for screenshot
(defvar d-dir-emacs-for-screenshot "~/.emacs.d/")

(defvar d-image-file-alist nil
  "")

(defvar d-dir-imgs
  (if (d-windowp)
      (concat d-dir-emacs-for-screenshot "imgs_xp/")
    (concat d-dir-emacs-for-screenshot "imgs/"))
  "")

(defvar d-dir-files (concat d-dir-emacs-for-screenshot "files/") "")

(defun d-insert-last-image ()
  "insert last image to muse-mode
"
  (interactive)
  (if (and (equal major-mode 'w3m-mode) (w3m-image))
      (d-citation-w3m-image)

    (let* ((filename-without-ext (concat d-dir-imgs "image" (number-to-string (d-citation-max-number))))
	   (filename (concat filename-without-ext "." (d-libs-image/getExtension filename-without-ext))))
      (insert (concat "[[" filename "]]")))))

(defun d-citation-image/get-new-image-name-without-extension ()
  (let* ((filename-without-ext (concat d-dir-imgs "image" (number-to-string (d-libs-image-max-number-plus-one)))))
    filename-without-ext))



(defun d-citation-w3m-image ()
  "to insert directry web image into muse. The function downloads
the image to ~/files/image directory and then citate the link
other window"
  (interactive)
  (let* ((url (w3m-image))
	 (filename (file-name-nondirectory url))
	 (extension (file-name-extension url))
	 (new-filename (concat d-dir-imgs "image" (number-to-string (+ 1 (d-citation-max-number))) "." extension)))
    (w3m-download url new-filename)
;    (unless (equal extension "jpg")
;      (shell-command "convert " new-filename (concat "~/files/image" (number-to-string (d-citation-max-number)) ".jpg"))
;      (shell-command (concat "rm" new-filename))))
    (other-window 1)
    (insert (concat "[[" new-filename "]]"))))

(defun d-citation-max-number ()
  "returns the max number of image of ~/Desktop/Documents/files directory.

 emacs 상에서 [[image13.jpg]]와 같은 문구를 넣기 위한 함수이다.
snapshot의 경우 image숫자. jpg의 모양으로 파일을 저장한다. 함수는
/home/ptmono/~plans의 jpg file 중 가장 큰 숫자의 image를 muse상에
넣어준다.

variable 'd-image-file-number-alist'에서 jpg image의 list를
'directory-files' function 을 이용하여 저장한다.

car와 cdr, string-match, match-string을 이용하여 숫자만을 추출하여
list를 만든 변수가 'numlist' 이다.

이 list중 가장 큰 숫자를 뽑아내기 위하여 dolist를 사용하였다. max
함수의 경우 (max 1 2 3) 과 같은 모양을 가져야 했다. string과
number의 type에 대하여 number-to-string 과 string-to-number를
적절히 사용하였다."
  (let* ((d-image-file-alist (directory-files d-dir-imgs t "image[0-9]+\\.[A-z0-9]+"))
	 (carlist (car d-image-file-alist))
	 (cdrlist (cdr d-image-file-alist))
	 numlist)
    (while carlist
      (string-match "[0-9]+" carlist)
      (setq numlist (cons (string-to-number (match-string 0 carlist)) numlist))
      (setq carlist (car cdrlist))
      (setq cdrlist (cdr cdrlist)))
    (let ((b 0))
      (dolist (a numlist b)
	(setq b (max a b))))))

(defun d-citation-max-number-plus-one()
  "Return function d-citaion-max-number + 1"
  (+ (d-citation-max-number) 1))

(defun d-citation-from ()
  "insert current the citation to the next window
0611292336과 같은 label에 대한 정보는 'd-planner-goto-label
을 참고하자.
"
  (let* ((word (current-word))
	 (file-name (buffer-file-name)))
    ;; to use d-planner-goto-label
    (let* ((annotation (run-hook-with-args-until-success 'planner-annotation-functions))
	   (str (d-citation-substring annotation "\\[\\[[^][]+\\]\\[\\([^][]+\\)\\]\\]" "!!!from")))
      (if str
	  (progn (select-window (next-window)) (insert str))
	(progn (select-window (next-window)) (insert annotation))))))

(defun d-citation-last-file ()
  "The function insert the last created file link into the
  buffer. The purpose is to conveniently insert a presentation
  file and a odt file stored ~/files directory. If you have
  created a ppt, use this function for inserting muse mode."
 ;; (interactive
 ;;  (list
 ;;   (if prefix-arg
 ;;       (read-directory-name "where? :")
 ;;     "~/files/"))
  ;; 애들은 다른 directory의 file에도 적용하기 위해서 만들어 졌다.
  ;; get the file name
  (let ((buffer-name "*Shell-command ls-tc*")
	(dir d-dir-files)
	file)
    (save-excursion
      (shell-command (concat "ls -tc " dir " |head -1") buffer-name)
      (switch-to-buffer buffer-name)
      (d-buffer-delete-last-newline)
      (setq file (buffer-substring-no-properties (point-min) (point-max)))
					; buffer-substring-no-properties 해야 highlighting 부분 같은 부분이 안나온다.
      (kill-buffer buffer-name))
					;    (if prefix-arg
					;	(insert (concat "[[" dir file "]]"))
					; 애들은 다른 directory의 file에도 적용하기 위해서 만들어 졌다.
    (insert (concat "[[" d-dir-files file "]]"))))
  



(defvar d-citation-muse-project-list nil "The list of muse-project directory")
(unless (d-windowp)
  (dolist (i muse-project-alist d-citation-muse-project-list)
    (push (car (car (cdr i))) d-citation-muse-project-list)
    ))


(defun d-citation-anchor ()
  "Muse use the anchor for internal link. For instance
#0908310711. There is no function to cite the anchor. This
function helps to create [[PAGE#0908310711]]
"
; other page use [[PAGE.muse#0908310736]]
; muse에서는 두가지 #NUMBER를 사용한다. 하나는 point이다. pos:/// 이렇게
; 시작한다. 하나는 anchor이다. / 이렇게 시작한다. 우리는 anchor를 사용한다.

  (let* ((anchor (replace-regexp-in-string "\n" "" (thing-at-point 'line))) ; thing-at-point contains newline character
	 (filename (buffer-file-name))
	 (dir (file-name-directory filename)) ; or use (muse-page-name)
	 link)

    (if muse-current-project
	(if (equal (car muse-current-project) "Plans")
	    (setq link (concat "[[" (muse-page-name) anchor "]]"))
	  (setq link (concat "[[" (car muse-current-project) "::" (muse-page-name) anchor "]]")))
      
      (setq link (concat "[[" filename anchor "]]")))

    (other-window 1)
    (insert link)))

(defun d-citation-anchor-absolute ()
  "d-citation-anchor use muse project. Let' assume that A buffer
is in project and B buffer is not. We want to citate a anchor of
A into the buffer B. It will use [[PAGE#CNUMBER]]. The link
couldn't used in B buffer. To solve this problem we need
PATH+PAGE#CNUMBER."
  (let* ((anchor (d-citation-inter-getAnchorInSection))
	 link)
    (if (not anchor)
	(message "Current line has no Cnumber.")
      (setq link (concat buffer-file-name anchor))
      (setq link (concat "[[" link "][" (buffer-name) "]]"))
      (other-window 1)
      (insert link))))
    
(defun d-citation-planner-note-with-title ()
  "When we cite the planner note, the function does not cite the
title of note. I want to create a function which cite the title."

  (let* (link
	 link-1
	 (o-dir (d-libs-string-replace-regexp "/home/ptmono" "~"
					      (save-window-excursion
						(other-window 1)
						default-directory)))
	 ;; t when other window is plans directory
	 (o-dir-p (if (eq o-dir "~/plans/")
		      t
		    nil)))
			
    (when (and (planner-derived-mode-p 'planner-mode)
	       (planner-page-name))
      (save-excursion
	(re-search-backward "^.\\(#[0-9]+\\)" nil t)
	;; (goto-char (planner-line-beginning-position))
	;; (when (looking-at ".\\(#[0-9]+\\)")
	
	(if o-dir-p
	    (setq link-1 (concat (planner-page-name) ".muse"
				 (planner-match-string-no-properties 1)))
	  (setq link-1 (concat o-dir (planner-page-name) ".muse"
			       (planner-match-string-no-properties 1))))
	
	(setq link (planner-make-link
		    link-1
		    (concat (planner-note-title (planner-current-note-info)) " - " link-1)
		    t))))
    (other-window 1)
    (insert link)))

(defun d-citation-planner-note-with-title-only ()
  "When we cite the planner note, the function does not cite the
title of note. I want to create a function which cite the title."

  (let* (link
	 link-1
	 (o-dir (d-libs-string-replace-regexp "/home/ptmono" "~"
					      (save-window-excursion
						(other-window 1)
						default-directory)))
	 ;; t when other window is plans directory
	 (o-dir-p (if (eq o-dir "~/plans/")
		      t
		    nil)))
			
    (when (and (planner-derived-mode-p 'planner-mode)
	       (planner-page-name))
      (save-excursion
	(re-search-backward "^.\\(#[0-9]+\\)" nil t)
	;; (goto-char (planner-line-beginning-position))
	;; (when (looking-at ".\\(#[0-9]+\\)")
	
	(if o-dir-p
	    (setq link-1 (concat (planner-page-name) ".muse"
				 (planner-match-string-no-properties 1)))
	  (setq link-1 (concat o-dir (planner-page-name) ".muse"
			       (planner-match-string-no-properties 1))))
	
	(setq link (planner-make-link
		    link-1
		    (concat (planner-note-title (planner-current-note-info)))
		    t))))
    (other-window 1)
    (insert link)))


(defun d-citation-planner-note-with-title-short ()
  "When we cite the planner note, the function does not cite the
title of note. I want to create a function which cite the title."

  (let* (link
	 link-1
	 (o-dir (d-libs-string-replace-regexp "/home/ptmono" "~"
					      (save-window-excursion
						(other-window 1)
						default-directory)))
	 ;; t when other window is plans directory
	 (o-dir-p (if (eq o-dir "~/plans/")
		      t
		    nil)))
			
    (when (and (planner-derived-mode-p 'planner-mode)
	       (planner-page-name))
      (save-excursion
	(re-search-backward "^.\\(#[0-9]+\\)" nil t)
	;; (goto-char (planner-line-beginning-position))
	;; (when (looking-at ".\\(#[0-9]+\\)")
	
	(if o-dir-p
	    (setq link-1 (concat (planner-page-name) ".muse"
				 (planner-match-string-no-properties 1)))
	  (setq link-1 (concat o-dir (planner-page-name) ".muse"
			       (planner-match-string-no-properties 1))))
	
	(setq link (planner-make-link
		    link-1
		    "link"
		    t))))
    (other-window 1)
    (insert link)))


(defun d-citation-file/cite ()
  (let* ((section (d-citation-section/getInfo))
	 note )

    (progn
      (other-window 1)
      (setq note (d-citation-file/getNoteInfo))
      (other-window 1))
    (insert note)
    (other-window 1)
    (re-search-backward "^.#[0-9]+ " nil t)
    (forward-line 1)
    (newline)
    (insert (concat "Filed to\n" section))
    (newline)
    (other-window 1)
    ))

  
(defun d-citation-file/getNoteInfo ()
  (let* (link
	 link-1
	 (o-dir (d-libs-string-replace-regexp "/home/ptmono" "~"
					      (save-window-excursion
						(other-window 1)
						default-directory)))
	 ;; t when other window is plans directory
	 (o-dir-p (if (eq o-dir "~/plans/")
		      t
		    nil)))
			
    (when (and (planner-derived-mode-p 'planner-mode)
	       (planner-page-name))
      (save-excursion
	(re-search-backward "^.\\(#[0-9]+\\)" nil t)
	;; (goto-char (planner-line-beginning-position))
	;; (when (looking-at ".\\(#[0-9]+\\)")
	
	(if o-dir-p
	    (setq link-1 (concat (planner-page-name) ".muse"
				 (planner-match-string-no-properties 1)))
	  (setq link-1 (concat o-dir (planner-page-name) ".muse"
			       (planner-match-string-no-properties 1))))
	
	(setq link (planner-make-link
		    link-1
		    (concat (planner-note-title (planner-current-note-info))
			    " - " (planner-match-string-no-properties 1))
		    t))))
    link))

;;; inter
(defvar d-citation-inter-register ?Y)


(defun d-citation-inter ()
  "You can select the section with outline-mode. In hide-body of
outline-mode, select section you want to citate. Then the
function will get citation number of the section. If no citation
number, the function will create a citation number and get it.
Eventually the citation number of section will be inserted as
link. See outline [[worknote2.muse#0911270802]]"
  (interactive)
  (point-to-register d-citation-inter-register)
  (hide-body)
  (d-citation-inter-minor-mode))

(define-minor-mode d-citation-inter-minor-mode
  "For d-citation-inter"
  :init-value nil
  :lighter " InterAnchor"
  :keymap '(([?\C-m] . d-citation-inter-insertCitation)))
  

(defun d-citation-inter-insertCitation ()
  "In hide-body of outline-mode, the function"
  (interactive)
  (let* ((note-info (planner-current-note-info)) ;If not note, note-info is nil
	 (anchor (if note-info
		     (concat "#" (planner-note-anchor note-info))
		   (d-citation-inter-getAndCreateAnchorInSection)))
	 (title (if note-info
		    (planner-note-title note-info)
		  (d-worknote-get-section-name))))
    (show-all)
    (jump-to-register d-citation-inter-register)
    (insert "[[" anchor "][" title " " anchor"]]")
    (d-citation-inter-minor-mode -1)))
    

(defun d-citation-inter-getAndCreateAnchorInSection ()
  (let* ((anchor (d-citation-inter-getAnchorInSection)))
    (unless anchor
      (setq anchor (d-citation-inter-createAnchorInSectionLine)))
    anchor))

(defun d-citation-inter-createAnchorInSectionLine ()
  (let* ((cnum (d-current-time))
	 (anchor (concat "#" cnum)))
    (save-excursion
      (end-of-line)
      (re-search-backward d-note-section-regexp nil t)
      (end-of-line)
      (newline)
      (insert anchor))
    anchor))

;TODO We can improve this function to be used for sections. So we can obtains
;the cnumber in wherever.
(defun d-citation-inter-getAnchorInSection ()
  "Returns current paragraph cnumber(anchor). Where the paragraph
is separated by ^$. There is no cnumber, then returns nil.
Currently only used for outline-mode of d-citation-inter-anchor."
  (save-excursion
    ;; Previous section anchor is at above of the section. Currently
    ;; the anchor is at below of the section. Fix that.
    (d-citation-change-anchor-which-in-section-line)
    (d-worknote-get-sub-anchor-in-section-line)))


;; Section
(defun d-citation-section/insert ()
  (interactive)
  (let* ((tag (d-citation-section/getInfo)))
    (other-window 1)
    (insert tag)))

(defun d-citation-section/getInfo ()
  (let* ((buffers-sync-p (d-citation-section/checkSyncDirs))
	 (buffer-file-name (if buffers-sync-p
			       (buffer-name)
			     (buffer-file-name)))
	 (buffer-name (file-name-nondirectory (buffer-file-name)))
	 (note-info (d-worknote-section-info))
	 (anchor (cdr (assoc 'anchor note-info)))
	 (title (cdr (assoc 'title note-info))))
    (concat "[[" buffer-file-name anchor "][" title " " buffer-name anchor "]]")))

(defun d-citation-section/checkSyncDirs ()
  "Check two buffer is in same directory."
  (let* ((buf1 (file-name-directory (buffer-file-name)))
	 (buf2 (save-window-excursion
		 (other-window 1)
		 (file-name-directory (buffer-file-name)))))
    (if (equal buf1 buf2)
	t
      nil)))
		   

;;; === d-citation-sikuli
;;; --------------------------------------------------------------
(defun d-citation-sikuli/insert ()
  (interactive)
  (let* ((current-dir (expand-file-name default-directory))
	 (file-number (d-libs-image/maxNumber current-dir)))
    (insert "\"image" (number-to-string file-number) ".png\"")))



(provide 'd-citation)

