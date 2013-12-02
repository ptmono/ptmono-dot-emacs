
;; C-h f ido-find-file for document

(require 'ido)
(ido-mode t)

(defcustom d-ido-gpicker-cmd (executable-find "gpicker")
  "Default font"
  :type 'file
  :group 'd-ido)

;; from http://stackoverflow.com/questions/7970537/emacs-find-file-in-project-on-a-big-project
(defun d-ido-gpicker-find-file (dir)
  (interactive
   (list
    (or (and current-prefix-arg (ido-read-directory-name "gpicker: " nil nil t))
        (and (boundp 'eproject-root) eproject-root)
        (and (not current-prefix-arg) (ido-read-directory-name "gpicker: " nil nil t))
        (if dired-directory (expand-file-name dired-directory) default-directory))))
  (when dir
    (with-temp-buffer
      (call-process d-gpicker-cmd nil (list (current-buffer) nil) nil
                    "-t" "guess" "-m" dir)
      (cd dir)
      (dolist (file (split-string (buffer-string) "\0"))
        (unless (string-equal file "")
          (find-file file))))))


(defun d-ido-erc-buffer()
  (interactive)
  (switch-to-buffer
   (ido-completing-read
    "Channel:" 
    (save-excursion
      (delq nil
	    (mapcar
	     (lambda (buf)
	       (when (buffer-live-p buf)
		 (with-current-buffer buf
		   (and (eq major-mode 'erc-mode)
			(buffer-name buf)))))
	     (buffer-list)))))))

(defun d-ido-for-mode(prompt the-mode)
  (switch-to-buffer
   (ido-completing-read 
    prompt
    (save-excursion
      (delq nil
	    (mapcar
	     (lambda (buf)
	       (when (buffer-live-p buf)
		 (with-current-buffer buf
		   (and (eq major-mode the-mode)
			(buffer-name buf)))))
	     (buffer-list)))))))

(defun d-ido-shell-buffer()
  (interactive)
  (d-ido-for-mode "Shell:" 'shell-mode))


(defun wg/ido-for-this-mode()
  (interactive)
  (let
      ((the-mode major-mode))
    (switch-to-buffer
     (ido-completing-read
      (format "Buffers of %s: " the-mode)
      (save-excursion
        (delq
         nil
         (mapcar
          (lambda
            (buf)
            (when
                (buffer-live-p buf)
              (with-current-buffer buf
                (and
                 (eq major-mode the-mode)
                 (buffer-name buf)))))
          (buffer-list))))))))


;;; === Study

;; [[http://www.emacswiki.org/emacs/InteractivelyDoThings][EmacsWiki: Interactively Do Things]]

;; ido-completing-read gives you a good solution
;; (setq mylist (list "red aa" "blue aa" "yellow bb aa" "clear cc" "i-dont-know cc"))
;; (ido-completing-read "What, ... is your favorite color? " mylist)


