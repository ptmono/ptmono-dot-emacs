

;------------------------------------------------------------
;; for remember, load-path is ~/.emacs.d/ 밑의 require는 하나만 필요
;; 했다. remember는 ~/.notes 파일에 기록되었고, remember-planner 는 ~/Plans/ 의
;; 파일들에 기록되었다. 날짜를 넣어주면 그 날짜의 2006.03.28.muse에 기록되고
;; TaskPoll을 입력하여주면 그날의 2006.03.28.muse와 TaskPool.muse 둘다에
;; 입력되었다.
;------------------------------------------------------------

;; Builtin package
;; (add-to-list 'load-path (concat d-dir-emacs "cvs/remember/"))

;  (require 'remember)
    (require 'remember-planner)
     (setq remember-handler-functions '(remember-planner-append))
    (setq remember-annotation-functions planner-annotation-functions)

;(add-to-list 'remember-mode-hook 'd-remember-init)
;remeber는 page를 불러오고 난 후 hook을 불러오고, 그 다음에 annotation을 가져온다.
;hook을 넣었을 때에 annotation이 생성되지 않는 현상이 있었다.

(defun d-remember ()
  "for auto footnote and numberring and 3 newline. It add to remember-mode-hook"
  (interactive)
  (if (get-buffer "*Remember*")
      (switch-to-buffer "*Remember*")
    (remember)
    (if (eq (point-min) (point-max))
	(progn (dotimes (c 2) (newline))
	       (insert "Footnotes:")
	       (dotimes (d 3) (newline))
	       (goto-char (point-min)))
      (dotimes (b 2) (newline))
      (insert "Footnotes:")
      (end-of-buffer)
      (move-beginning-of-line nil)
      (if (equal "[" (char-to-string (char-after)))
	  (insert "[1] ")
	)
      (end-of-buffer)
      (dotimes (a 3) (newline))
      (beginning-of-buffer))
    (auto-fill-mode)
    (footnote-mode)))





;-----------------------------------------------------------------
;;; problem
; remember를 이용하여 내용을 저장 할 때에 꼭 day-page와 plan-page가 같이 저장되는
; 현상이 있다. 하지만 나는 plan page에만 저장하고 싶다.
; 
;;; **how to remember to do?**
; 
; remember가 구동하여 문서를 작성하고 C-c C-c(remember-buffer)를 부르면,
; remember-region이 실행된다. remember-region은 
; (run-hook-with-args-until-success 'remember-handler-functions)
; 의 함수들을 구동한다. 여기에 나의 함수를 넣었다.
; 
; (add-to-list 'remember-handler-functions 'd-remember-planner-append)
; 
; 기존에 구동되었던 함수는 remember-planner-append 이다. 이 함수가 어떻게 페이지를
; 저장하는지 살펴보자.
; 
;  1. (let ((text (buffer-string))) 은 페이지의 내용을 변수화 해준다.
;  2. (planner-crete-note page) 를 이용하여 note를 만든다.
;  3. (insert text)로 넣어준다.
; 
; 함수에서는 (save-restriction (narrow-to-region 을 이용하여 좀 더 편리하게
; section의 내용을 추가하였다. 특이한 사항은 save-restriction 된 영영을 저장해도
; 전체가 저장이 된다는 것이다.
; 
; remember-planner-add-xref 를 이용하여 현재 section에 day page와 link를 추가
; 한다. 그리고 remember-planner-append-hook을 이용하여 hook을 실행한다.
; 
; 
;;; **how to solve?**
; 
; #0704081504
; remember-planner-append 에서 적절히 수정하는 방법을 사용하였다. 하지만 multi
; task에 대해서 적용할 수가 없다. 현재는 mult task(p-page)를 입력 받아도 가장
; 먼저오는 task를 page로 적용한다.
; 
; 
;;; **to do**
; 
;  - multi task에 대하여 실행할 수 있도록 하자. remember-planner-add-xrf 가
;    remember-planner-append 에서 그 역활을 하였다.
; 
;; See [[worknote#0704081441]]

(defun d-remember-planner-append (&optional page p-page)
  "Remember this text to PAGE or today's page.
This function can be added to `remember-handler-functions'."
  (unless (or page (not planner-use-plan-pages))
    (setq page
          (let ((planner-default-page (or remember-planner-page (planner-today))))
            (when (or (not planner-use-day-pages)
                      remember-planner-xref-p)
              (planner-read-name (planner-file-alist))))))
					; nil값을 받으면 plan page 다시 지정한다.
  (if (eq page nil)
      (setq p-page (planner-read-name (planner-file-alist) "plan page:")))
  (if p-page
      (let ((text (buffer-string))
	    start
	    (page (if (string-match "^\\(.+\\) " p-page)
		      (match-string 1 p-page)
		    p-page)))
	(save-window-excursion
					; 여기서 plan-page값이 주어진다면 plan-page를 만든다.
	  (planner-create-note page)
	  (setq start (planner-line-beginning-position))
	  (insert text)
	  (unless (bolp) (insert "\n\n")) ;; trailing newline
	  (save-restriction
	    (narrow-to-region start (point))
;; todo: multi task
;					;이 부분은 page 가 nil이 아닐 때에만 필요
;	    (if (string-match "^\\(.+\\) " p-page)
;		(when remember-planner-xref-p
;		  (remember-planner-add-xref p-page))) ;; 이 함수가 multi task하게 하였다.
	    (mapcar
	     (lambda (hook)
	       (save-window-excursion
		 (save-restriction
		   (funcall hook))))
	     remember-planner-append-hook)
	    (when remember-save-after-remembering
	      (save-buffer)))
	  t))

;일반적인 remember
    (let ((text (buffer-string))
	  start)
      (save-window-excursion
	(if planner-use-day-pages
	    (planner-create-note (planner-today))
	  (planner-create-note page))
	(setq start (planner-line-beginning-position))
	(insert text)
	(unless (bolp) (insert "\n\n")) ;; trailing newline
	(save-restriction
	  (narrow-to-region start (point))
	  (when remember-planner-xref-p
	    (remember-planner-add-xref page))
	  (mapcar
	   (lambda (hook)
	     (save-window-excursion
	       (save-restriction
		 (funcall hook))))
	   remember-planner-append-hook)
	  ;; Should be back on today's page
	  (unless (or remember-planner-copy-on-xref-flag
		      (null page)
		      (if planner-use-day-pages
			  (string= page (planner-today))
			t))
	    (delete-region (planner-line-end-position) (point-max))))
	(when remember-save-after-remembering
	  (save-buffer)))
      t)))

(add-to-list 'remember-handler-functions 'd-remember-planner-append)




