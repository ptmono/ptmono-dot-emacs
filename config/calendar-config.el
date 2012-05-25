(setq cal-tex-diary t)

;;; === How to change the color of today on calendar ?
;;; --------------------------------------------------------------
;; calendar-mark-today 함수는 그 값을 결정한다. 여기에 face를 setq하고 이를
;; today-visible-calendar-hook에 적용하여 주면 된다.
;; today-visible-calendar-hook 의 document 를 참조하기 바란다. 다음과 같이
;; 설정하여 주었다.

(setq calendar-today-visible-hook 'calendar-mark-today)

;FIXME: warning of byte-compile
(defface d-calendar-today-color
  '((t :background "green")) "")

(setq calendar-today-marker 'd-calendar-today-color)


;;; === Specify the file of .diary
;;; --------------------------------------------------------------
;; (setq diary-file "~/.diary")



