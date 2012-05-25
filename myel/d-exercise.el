; d-exercise를 실행하면 함수는 팔굽혀펴기를 몇개하였는지를 물어본다. 시간이 날
; 때마다 팔굽혀펴기를 하고서는 d-exercise를 실행시켜 기록해 두자. d-exercise는
; d-exercise-type-number를 실행한다.
;
; 여러가지 운동 상황에 적용하기 위해, 여러가지 변수값의 list를 사용하기 위해
; d-exercise-var-list 와 d-exercise-type-list 를 사용하였으며,
; d-exercise-var-list의 값이 실행시마다 변하므로 d-exercise-read-var-list 를
; 이용하여 d-exercise 가 실행할 때마다 경신된다.
;
; 꾸준히 숫자되거나 시간되는 곳에 활용될 수 있을 것이라 생각하며,
; d-exercise-type-time을 만들어야 한다. 또한 좀 더 많은 상황에 사용될 수 있도록
; 개량하여야 한다. 
;
; message를 내어주는 부분은 좀 더 인공지능적으로, 여러 상황에 맞게 답변하는 것이
; 필요하다.
;
; 함수를 만들면서 list에 대한 공부를 한것 같다.



(require 'd-library)
(require 'planner)

; 만약 variables file이 지워지면 어찌되는가. 대비책이 있어야 하겠다.

(defvar d-exercise-var-list nil
  "\(\(\"day\" . \"2007.06.28\"\) \(\"plan-page\" . \"exercise-arm\"\) \(\"num\" . 0\) \(\"num-today-purpose\" . 200\) \(\"num-total\" . 0\)\)\"
와 같은 모양을 가진다. d-exercise-read-var-list 로 변수를 읽는다.")


(defvar d-exercise-type-list
  '(("arm" d-exercise-type-number "오늘 팔굽혀펴기")
    ("free" d-exercise-type-time "오늘 운동"))
  "name function-name vaiable-name variable-name 은 name와 같이 하자.

변수는 name, function message 로 구성시켜두었다. list에 내용을 추가하여 사용하여도 될 것이다.

")



(defun d-exercise (name)
  "This is the main function."
  (interactive (list (if prefix-arg
			 (completing-read "종목은 머유?:  " d-exercise-type-list)
		       "arm")))
  (let ((func (car (cdr (assoc name d-exercise-type-list)))))
    (d-exercise-read-var-list name)
    (funcall func name)))



(defun d-exercise-type-number (name) ;name is to be 팔굽혀펴기 or ...
  "함수는 숫자를 입력받는다. 입력받은 숫자는 차곡차곡
더해진다. 함수는 오늘 더해진게 아니면 그 숫자를 plan page에
저장한다.

NAME은 d-exercise-type-list에서 각 list의 car 부분이다. 이것은
d-lib-variables 에서의 한 변수 이름과 같다.

 변수는 d-exercise-var-num을
따른다.
"
  (let* ((number (read-number "INPUT the number you did:  "))
	 (msg (nth 2 (assoc name d-exercise-type-list)))
	 (value-list d-exercise-var-num-list)
	 (day (cdr (assoc "day" value-list)))
	 (plan-page (cdr (assoc "plan-page" value-list)))
	 (num (cdr (assoc "num" value-list)))
	 num-today-remain
	 (num-total (cdr (assoc "num-total" value-list)))
	 (today (planner-today))
	 pre-num)
    (if (equal today day)
	; 오늘이면
	(progn
	  (setq num (+ num number))
	  (setq num-today-remain (- (cdr (assoc "num-today-purpose" value-list)) num))
	  (setcdr (assoc "num" value-list) num)
	  (d-lib-var-add name (prin1-to-string value-list))
	  (message (concat "Today your remain is " (number-to-string num-today-remain) " thanks")))

; todo message 를 좀 더 지능적으로 만들고 싶다.

	(planner-create-task (concat msg (number-to-string num) "번 했어요.") day nil plan-page "X")
					; problem planner-crate-task 에서는 한글을 읽지 못
					;"오늘 팔굽혀펴기 100개 했어요" 같은 식으로 완료된 일을 만든다. plan-page를 정해야 겠다.
	(setq num-total (+ num-total num))
	(setq num number)			
	(setq num-today-remain (- (cdr (assoc "num-today-purpose" value-list)) num))
	(setcdr (assoc "num-total" value-list) num-total)
	(setcdr (assoc "num" value-list) num)
	(setcdr (assoc "day" value-list) today)
	(d-lib-var-add name (prin1-to-string value-list))
	(message (concat "Today your remain is " (number-to-string num-today-remain) " thanks")))
    
					; list의 변수를 가져오는 데에는 assoc car cdr 을 사용하면 되고, 변수를 바꾸는데에는
					; assoc setcar setcdr 을 사용하면 된다.
      ))


(defun d-exercise-read-var-list (name)
  "list는 계속적으로 바뀐다. 그래서 d-exercise가 실행될 때마다 불러오도록 하였다."
  (setq d-exercise-var-list (read (d-lib-var-value name))))


(defun d-exercise-number-set-var (name value-list num)
  ""
  (setq value-list (setcdr (assoc "num" value-list) num))
  (d-lib-var-add name (prin1-to-string value-list))
  (message (concat "Your remain is " num " thanks")))
