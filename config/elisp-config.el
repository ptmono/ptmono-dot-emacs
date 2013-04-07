

(defvar d-elisp-section-bold-face 'd-elisp-section-bold-face)
(defface d-elisp-section-bold-face
  '((t (:foreground "#4eff4b" :bold t))) 
  ;'((t (:foreground "#3ABF38" :bold t))) 
  "Face for the python-mode ."
  :group 'font-lock-faces)


(defvar d-elisp-section-face 'd-elisp-section-face)
(defface d-elisp-section-face
  '((t (:foreground "#298727" :bold nil))) 
  "Face for the python-mode ."
  :group 'font-lock-faces)


(defvar d-elisp-subsection-face 'd-elisp-subsection-face)
(defface d-elisp-subsection-face
  '((t (:foreground "#3abf38" :bold nil))) 
  "Face for the python-mode ."
  :group 'font-lock-faces)



(defvar d-lisp/font-lock-keywords
  '(
    ("^;;; .*$" 0 d-elisp-section-face t)
    ("^;;; =+ \\(.*\\)$" 1 d-elisp-section-bold-face t)
    ("^;;; \\([^-=;]+\\)$" 1 d-elisp-subsection-face t)

    ))

(defun d-lisp-hook ()
  (font-lock-add-keywords nil d-lisp/font-lock-keywords)

)


(add-hook 'lisp-interaction-mode-hook 'd-lisp-hook)
(add-hook 'lisp-mode-hook 'd-lisp-hook)
(add-hook 'emacs-lisp-mode-hook 'd-lisp-hook)
	  
