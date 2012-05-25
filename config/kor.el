;;; for korean 이부분은 앞부분에 ;만을 더해주었으니 필요하면 ;를 빼주면 되겠다.
(when enable-multibyte-characters
  (set-language-environment "Korean")
;*  (setq-default file-name-coding-system 'utf-8)
  ;; comment out if you use 3 bulsik
;;;  (setq default-korean-keyboard "3")
;;;  (setq default-input-method "korean-hangul3")
;;;  (setq input-method-verbose-flag nil
;;;        input-method-highlight-flag nil)
  ;;; give highest priority to euc-kr

;;; prefer-coding-system
;; 설명은 문서참조.
;; 만약에 이 값이 주어지지 않는다면 한글 디렉토리를 만들거나 파일의 한글은
;; korean-iso-8bit-unix 으로 인코딩 된다. 값이 'utf-8 으로 주어지면, utf-8-unix
;; 으로 인코딩 된다. 문서내의 한글도 utf-8-unix 로 인코딩 된다. 파일명 또한
;; 그렇다. 이 것은 set-default-coding-systems 의 값이 주어지지 않아도
;; 같은효과(?)를 보여주었다.
;; 
  (prefer-coding-system 'utf-8) ;; PROBLEM with byus.net. block with korean shell output
  

;*  (set-default-coding-systems 'utf-8) ;; PROBLEM with py-shell(ipython)
  ; couldn't use hangle variable in py-shell interpreter. So It was off.

  (add-hook 'quail-inactivate-hook 'delete-quail-completions)
  (defun delete-quail-completions ()
    (when (get-buffer "*Quail Completions*")
      (kill-buffer "*Quail Completions*")))
  ;(set-selection-coding-system 'euc-kr)
  (set-selection-coding-system 'utf-8) ;; used for communicating with other X clients

  ;;(unless window-system
  ;;(menu-bar-mode -1)
  ;;(set-keyboard-coding-system 'nil)
  ;;(set-terminal-coding-system 'euc-kr))

  ;; Hangul Mail setting
  (setq-default sendmail-coding-system 'utf-8)

  ;; For use of `emacs -nw' in Korean terminal emulator
  (if (and (null window-system) (null noninteractive))
     (progn
       (set-keyboard-coding-system 'utf-8)
       (set-terminal-coding-system 'utf-8)))


  ;; hangul printing for ps-mule.el
  (setq-default ps-multibyte-buffer 'non-latin-printer)

  ;; turn off C-h during input
  ;;(eval-after-load "quail"
  ;;  '(progn
  ;;    (define-key quail-translation-keymap "\C-h"
  ;;      'quail-delete-last-char)
      ;;(define-key quail-translation-keymap "\C-?"
      ;;  'quail-translation-help)
  ;;    (define-key quail-translation-keymap "\C-?"
  ;;      'quail-delete-last-char)
  ;;    ))

  ;; The default coding system of the dired buffer is utf-8.
;*  (add-hook 'dired-before-readin-hook
;*            (lambda ()
;*              (set (make-local-variable 'coding-system-for-read) 'utf-8)))
)

(defun unicode-shell ()
  "Execute the shell buffer in UTF-8 encoding.
Note that you'll need to set the environment variable LANG and othersd
appropriately."
  (interactive)
  (let ((coding-system-for-read 'utf-8)
        (coding-system-for-write 'utf-8)
        (coding-system-require-warning t))
    (call-interactively 'shell))) 


;-------------------------------------------------------------
;이부분은 한글 printing을 부한부분이다.
;http://personal-pages.lvc.edu/~lyons/computer_howto/korean_emacs.txt에서 나온 것이며 /home/ptmono/.ote/emacs의 한글 printing을 참고하기 바란다.
;------------------------------------------------------------
;; for emacs typing and printing korean
;; Korean character typing and printing
(load "ps-print")
(load "ps-mule")
(load "ps-bdf")
;(load "/usr/local/share/emacs/22.0.50/leim/quail/hangul.elc")
(setq ps-multibyte-buffer 'bdf-font-except-latin)

;; unicode character insertion
;;  (needed for diacritical mark called "breve" used in
;;   McCune-Reischauer romanization)

(defun unicode-insert (char)
  "Read a unicode code point and insert said character.
Input uses `read-quoted-char-radix'.  If you want to copy
the values from the Unicode charts, you should set it to 16."
  (interactive (list (read-quoted-char "Char: ")))
  (ucs-insert char))
(setq read-quoted-char-radix 16)





;; C-x 5 2 으로 새창을 열면 d-face-N 이 적용이 안된다 적용을 위해서는 다음이
;; 필요하다. See more worknote.muse#0908201957
;(add-to-list 'default-frame-alist
;	     '(font . "-*-fixed-medium-*-*-*-14-*-*-*-*-*-fontset-h"))

;--------------------------------------------------
;; for face
;--------------------------------------------------
;
;

;(create-fontset-from-fontset-spec
; "-*-fixed-medium-r-*-*-14-*-*-*-*-*-fontset-t0,
;   korean-ksc5601:-*-gulimbdf-medium-*-*-*-12-*-*-*" t)
;

;(create-fontset-from-fontset-spec
; "-*-fixed-medium-r-*-*-20-*-*-*-*-*-fontset-t1,
;   korean-ksc5601:-*-gulimbdf-medium-*-*-*-18-*-*-*" t)
;
;
;
;(create-fontset-from-fontset-spec
; "-*-fixed-medium-r-*-*-20-*-*-*-*-*-fontset-t2,
;   korean-ksc5601:-baekmuk-gulimbdf-medium-*-*-*-18-*-*-*,
;korean-ksc5601:-baekmuk-gulimbdf-bold-*-*-*-18-*-*-*" t)
;

; for xft font
;(set-frame-font "Gulim-10")
;(set-frame-font "arial-12")


;; (create-fontset-from-fontset-spec
;;  "-*-fixed-medium-r-*-*-14-*-*-*-*-*-fontset-h,
;;    korean-ksc5601:-daewoo-gothic-*-*-*-*-*-*-*-*" t)

;; (create-fontset-from-fontset-spec
;;  "-*-fixed-medium-r-*-*-14-*-*-*-*-*-fontset-h,
;;    korean-ksc5601:-daewoo-gothic-*-*-*-*-*-*-*-*" t)

(when (not (d-windowp))
  (create-fontset-from-fontset-spec
   "-*-Fixed-medium-r-*-*-15-*-*-*-*-*-fontset-h,
   korean-ksc5601:-daewoo-gothic-*-*-*-*-*-*-*-*" t)

  (create-fontset-from-fontset-spec
   "-*-Fixed-medium-r-*-*-15-*-*-*-*-*-fontset-y,
   korean-ksc5601:-*-WenQuanYi Zen Hei-*-*-*-*-15-*-*-*" t)

  (create-fontset-from-fontset-spec
   "-misc-fixed-medium-r-*-*-15-*-*-*-*-*-fontset-z")
   ;; korean-ksc5601:-*-WenQuanYi Zen Hei-*-*-*-*-15-*-*-*-*-*-ksc5601" t)
  )

(defun do-font()
  (if (d-windowp)
      (progn
	;; (set-frame-font "MS Sans Serif-12") ;글자가 제대로 삭제되지 않는 증상이 있습니다.
	;; (set-frame-font "Gulim-10")
	;; (set-frame-font "MS Sans Serif-12") ;글자가 제대로 삭제되지 않는 증상이 있습니다.
	;; (set-frame-font "arial-12")
	;; (set-frame-font "Bitstream Vera Sans Mono-14")
	;; (set-frame-font "courier-10")
	(set-frame-font "DejaVu Sans Mono-12")
	(add-to-list 'default-frame-alist
		     '(font . "DejaVu Sans Mono-12")))
    (set-frame-font "fontset-z")
    (add-to-list 'default-frame-alist
		 ;'(font . "-*-Fixed-medium-*-*-*-15-*-*-*-*-*-fontset-y"))))
		 '(font . "fontset-z"))))

;; (defun d-face ()
;;   (interactive)
;;   (condition-case nil
;;       (create-fontset-from-fontset-spec
;;        "-*-fixed-medium-r-*-*-14-*-*-*-*-*-fontset-y,
;;    korean-ksc5601:-daewoo-gothic-*-*-*-*-*-*-*-*" t)
;;     (error ""))
;;   (if (d-windowp)
;;       (set-frame-font "arial-10")
;;     (set-frame-font "-*-fixed-medium-*-*-*-14-*-*-*-*-*-fontset-y")))

(defun d-font-dsm-10()
  (interactive)
  (set-frame-font "DejaVu Sans Mono-10")
  (add-to-list 'default-frame-alist
	       '(font . "DejaVu Sans Mono-10")))

(defun d-font-dsm-12()
  (interactive)
  (set-frame-font "DejaVu Sans Mono-12")
  (add-to-list 'default-frame-alist
	       '(font . "DejaVu Sans Mono-12")))

(defun d-font-courier-10()
  (interactive)
  (set-frame-font "courier-10")
  (add-to-list 'default-frame-alist
	       '(font . "courier-10")))


(defun d-face ()
  (interactive)
  (do-font))


(defun d-face-2 ()
  (interactive)
  (condition-case nil
      (create-fontset-from-fontset-spec
       "-*-fixed-medium-r-*-*-20-*-*-*-*-*-fontset-t,
   korean-ksc5601:-daewoo-gothic-*-*-*-*-*-*-*-*" t)
;   korean-ksc5601:-*-gulimbdf-medium-*-*-*-18-*-*-*" t) ;; This has a problem in 23.0.95
    (error ""))
  (set-frame-font "-*-fixed-medium-*-*-*-20-*-*-*-*-*-fontset-t")
  (add-to-list 'default-frame-alist
	       '(font . "-*-fixed-medium-*-*-*-20-*-*-*-*-*-fontset-t")))



(defun d-face-3 ()
  (interactive)
  (condition-case nil
      (create-fontset-from-fontset-spec
       "-*-fixed-medium-r-*-*-20-*-*-*-*-*-fontset-u,
   korean-ksc5601:-baekmuk-gulimbdf-medium-*-*-*-18-*-*-*,
korean-ksc5601:-baekmuk-gulimbdf-bold-*-*-*-18-*-*-*" t)
    (error ""))
  (set-frame-font "-*-fixed-medium-*-*-*-20-*-*-*-*-*-fontset-u"))


(defun d-face-5 ()
  (interactive)
  (condition-case nil
      (create-fontset-from-fontset-spec
       "-*-fixed-medium-r-*-*-20-*-*-*-*-*-fontset-v,
   korean-ksc5601:-*-gothic-*-*-*-*-*-*-*-*" t)
    (error ""))
  (set-frame-font "-*-fixed-medium-*-*-*-20-*-*-*-*-*-fontset-v"))


;; See end of init.el
; for C-x 5 2
;(unless (d-windowp)
;    (d-face)
;  ; for C-x 5 2
;  (add-to-list 'default-frame-alist
;	       '(font . "-*-fixed-medium-*-*-*-14-*-*-*-*-*-fontset-h"))
;
;  )

;(set-fontset-font "fontset-default" '(#x1100 . #xffdc) '("UnDotum" . "unicode-bmp"))
;(set-fontset-font "fontset-default" '(#xe0bc . #xf66e) '("UnDotum" . "unicode-bmp"))

(when (not (d-windowp))
  (set-fontset-font "fontset-default" '(#x1100 . #xffdc) '("WenQuanYi Zen Hei" . "unicode-bmp")))


(provide 'kor)
