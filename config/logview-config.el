(require 'log-view)


;======================================================================
;;; Colors                                                          ;;;
;======================================================================
;; log-view-mode 에서는 다음과 같은 과정으로 font-lock을 생성하고 있습니다.
;; - Create face
;; - Create face variable
;; - Call define-obsolete
;; - add-to-list to log-view-font-lock-keywords
;; 최종적으로 log-view-font-lock-keywords에 list 됩니다. 다음과 같습니다.
;; ;; Create face
;; (defface d-log-view-tag '((((class color) (background light))
;;      (:background "yellow" :weight bold))
;;     (t (:weight bold)))
;;   "Face for the file header line in `log-view-mode'."
;;   :group 'log-view)
;; ;; Create face variable
;; (defvar d-log-view-tag-face 'd-log-view-tag)
;; ;; Call define-obsolete
;; (define-obsolete-face-alias 'd-log-view-tag-face 'd-log-view-tag "22.1")
;; ;; set-face-attribute. Some case we have to.
;; (set-face-attribute 'd-log-view-tag-face nil
;; :foreground "red")
;; ;; Add
;; (add-to-list 'log-view-font-lock-keywords
;; 	     '(eval . `(,d-muse-tag-1 . d-log-view-tag-face)))

;; 우리가 추가하는 방법은 face에 대한 변수를 설정해주고 이를
;; log-view-font-lock-keywords 에 (eval . `(,REGEXP . FACE-VARIABLE)로
;; 추가해주면 됩니다. eval 때문에 face 명을 바로 사용하지 못하고 변수명으로
;; 사용하는 것 같습니다.(정확히 몰르겠습니다. #1012271855 원래 그렇게 하는
;; 겁니다.)

;; TAGS
(defvar d-log-view-tag-face 'muse-emphasis-3)
(add-to-list 'log-view-font-lock-keywords
	     '(eval . `(,d-muse-tag-1 . d-log-view-tag-face)))


;; In color-theme, we need to change foreground
(set-face-attribute 'log-view-message-face nil
		    :foreground "white"
		    :background "#5a5a5a"
		    :weight 'bold)
(set-face-attribute 'log-view-file-face nil
		    :foreground "white"
		    :background "#bdbdbd"
		    :weight 'ultra-bold)

