;함수들의 구조는 remember를 모방하였다.
;
;;;설명
;창을 옴겨다니며 note하는 것이 귀찮아서 마련된 elisp이다.
;C-u M-x d-note를 통해서 필기될 buffer를 선택할 수가 있다.
;필기될 buffer가 윈도우상에 있을 때에는 window-configuration-to-register에 의해서
;필기된 후 커서의 위치가 저장되어서 처음 필기된 내용이 아래로 내려갈 것이다.
;
;C-c C-c, C-c C-s로 *NoteTo* buffer를 저장할 수가 있으며, C-c C-k로 취소할 수가 있다.


;;(require 'w3m)
;; why this is used?

(defvar d-note-buffer-name "*NoteTo*"
  "")


(defvar d-note-register ?R
  "")


(defvar d-note-mode-hook nil "")



(defun d-note ()
  "to create *NoteTo* buffer in which note your notes,
you can find variable d-wbuffer-name in citation.el
specify the writting buffer with prefix."
  (interactive)
  (window-configuration-to-register d-note-register)
  (let* ((buf (get-buffer-create d-note-buffer-name)))
    (if current-prefix-arg
	(setq d-wbuffer-name (read-buffer "writting buffer: ")))
    (switch-to-buffer-other-window buf)
    (d-note-mode)
    (message "Use C-c C-c to note the data.")))




(defun d-note-mode ()
  ""
  (interactive)
  (kill-all-local-variables)
  (indented-text-mode)
  (use-local-map d-note-mode-map)
  (setq major-mode 'd-note-mode-map
	mode-name "d-note")
  (run-hooks 'd-note-mode-hook))


(defun d-note-buffer ()
  "to note *NoteTo* buffer. use C-c C-c or C-c C-s on *NoteTo* buffer"
  (interactive)
  (let* ((contents (buffer-substring (point-min) (point-max))))
      (kill-buffer (current-buffer))
      (switch-to-buffer d-wbuffer-name)
      (insert contents)
      (jump-to-register d-note-register)))



(defun d-note-destroy ()
  ""
  (interactive)
  (when (equal d-note-buffer-name (buffer-name))
    (kill-buffer (current-buffer))
    (jump-to-register d-note-register)))




(defvar d-note-mode-map ()
  "keymap used in d-note mode")

(when (not d-note-mode-map)
  (setq d-note-mode-map (make-sparse-keymap))
  (define-key d-note-mode-map [?\C-c ?\C-c] 'd-note-buffer)
  (define-key d-note-mode-map [?\C-c ?\C-s] 'd-note-buffer)
  (define-key d-note-mode-map [?\C-c ?\C-k] 'd-note-destroy))

(provide 'd-note)


