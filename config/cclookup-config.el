;; add cclookup to your loadpath, ex) "~/.lisp/addons/cclookup"
(setq cclookup-dir "~/.emacs.d/etc2/cclookup")
(add-to-list 'load-path cclookup-dir)
;; load cclookup when compile time
(eval-when-compile (require 'cclookup))

;; set executable file and db file
(setq cclookup-program (concat cclookup-dir "/cclookup.py"))
(setq cclookup-db-file (concat cclookup-dir "/cclookup.db"))

;; to speedup, just load it on demand
(autoload 'cclookup-lookup "cclookup"
  "Lookup SEARCH-TERM in the C++ Reference indexes." t)
(autoload 'cclookup-update "cclookup" 
  "Run cclookup-update and create the database at `cclookup-db-file'." t)


;;; It has a problem with w3m

;; M-x cclookup-lookup 을 실행하여 함수 "fseek" 을 찾는다고 하자.
;; ~/.emacs.d/etc/cclookup/cclookup.db 의 데이터베이스를 이용하여, 다운
;; 받아둔 페이지
;; "~/.emacs.d/etc/cclookup/www.cppreference.com/wiki/c/io/fseek"를
;; browse-url 함수를 이용하여 연다. 현재 나는 w3m-browse-url 을 사용하고
;; 있다. 문제는 이 받아둔 파일이 xhtml 문서 형식을 취하고 있는데,
;; w3m-browse-url 이 이 문서를 열지 못하고 편집파일로 열어버린다는 것이다.
;; 다시말해서 편집모드 xhtml 로 열어버린다.(w3m이 아닌)

;; 문제는 emacs-w3m이 html 확장가 없는 파일을 열지 못하는것에 있습니다.


;; FIXME: *CClokup Completions*에서 C-m은 cclookup-mode-lookup-and-leave에
;; 바운드되어있습니다. f는 cclookup-mode-lookup에 바운드되어 있습니다. f는
;; 지금 동작합니다. C-m을 고쳐주세요. 그리고 d-cclookup-with-web nil 일 때
;; 문제가 있습니다. 파일이 확장자를 .html로 가지지 않기 때문에 emacs-w3m이
;; 열지를 못합니다. 수정해 주세요.
(defvar d-cclookup-with-web t)

(defun cclookup-mode-lookup ()
  "Lookup the current line in a browser."
  (interactive)
  
  (let ((url (get-text-property (point) 'cclookup-target-url)))
    (if url
        (progn
          (beginning-of-line)
          (message "Browsing: \"%s\"" url)
	  (if d-cclookup-with-web
	      (browse-url (concat "http://" url))
	    (browse-url (cclookup-url url))))

      (error "No URL on this line"))))


(defun cclookup-url (url)
  "Change proper url form"
  (let ((default-directory (file-name-directory cclookup-db-file)))
    (concat "file://" (expand-file-name url))))

(defun cclookup-mode-lookup-and-leave ()
  "Lookup the current line in a browser and leave the completions window."
  (interactive)
  
  (call-interactively 'cclookup-mode-lookup)
  (cclookup-mode-quit-window))
