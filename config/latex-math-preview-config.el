
;; http://www.emacswiki.org/emacs/LaTeXMathPreview
;; worknote3.muse#1306072200

;; M-x latex-math-preview-expression
(require 'latex-math-preview)

;;; Set image color
(setq latex-math-preview-dvipng-color-option nil)
(setq latex-math-preview-image-foreground-color nil)
(setq latex-math-preview-image-background-color "#FFFFFF")

;;; To add extra symbol data
(require 'latex-math-preview-extra-data)
(add-to-list 'latex-math-preview-text-symbol-datasets
	     latex-math-preview-textcomp-symbol-data)
(add-to-list 'latex-math-preview-text-symbol-datasets
	     latex-math-preview-pifont-zapf-dingbats-symbol-data)
(add-to-list 'latex-math-preview-text-symbol-datasets
	     latex-math-preview-pifont-symbol-fonts-symbol-data)


(defvar latex-math-preview-latex-template-header
  "\\documentclass[12pt]{article}\n\\pagestyle{empty}\n\\usepackage{amsmath, amssymb, amsthm}"
  "Insert string to beginning of temporary latex file to make image.")


(defvar latex-math-preview-match-expression
  '(
    ;; \[...\]
    (1 . "[^\\\\]\\(\\\\\\[\\(.\\|\n\\)*?\\\\]\\)")

    ;; \(...\)
    (0 . "\\\\(\\(.\\|\n\\)*?\\\\)")

    (0 . "<math>\\(\\(.\\|\n\\)*?\\)<\\\\math>")

    ;; \begin{math}...\end{math}
    (0 . "\\\\begin{math}\\(\\(.\\|\n\\)*?\\)\\\\end{math}")

    ;; \begin{displaymath}...\end{displaymath}
    (0 . "\\\\begin{displaymath}\\(\\(.\\|\n\\)*?\\)\\\\end{displaymath}")

    ;; \begin{equation}...\end{equation}
    (0 . "\\\\begin{equation\\(\\|\\*\\)}\\(\\(.\\|\n\\)*?\\)\\\\end{equation\\(\\|\\*\\)}")

    ;; \begin{gather}...\end{gather}
    (0 . "\\\\begin{gather\\(\\|\\*\\)}\\(\\(.\\|\n\\)*?\\)\\\\end{gather\\(\\|\\*\\)}")

    ;; \begin{align}...\end{align}
    (0 . "\\\\begin{align\\(\\|\\*\\)}\\(\\(.\\|\n\\)*?\\)\\\\end{align\\(\\|\\*\\)}")

    ;; \begin{alignat}...\end{alignat}
    (0 . "\\\\begin{alignat\\(\\|\\*\\)}\\(\\(.\\|\n\\)*?\\)\\\\end{alignat\\(\\|\\*\\)}")

    )
  "We use these expressions when extracting a LaTeX mathematical expression.
The elements of this list is the form which is a list of \(integer regular-expression\).
The regular-expression matchs a string including LaTeX mathematical expressions.
The integer is the number to access needed string from regular-expressin.")




;;; Help function for worknote

(defun d-latex-math-preview-save-image ()
  ""
  (interactive)
  (let* ((img-name (concat (d-citation-image/get-new-image-name-without-extension) ".png"))
	 content)
    (unless (get-buffer latex-math-preview-expression-buffer-name)
      (error "No latex-math-preview buffer"))
    (save-window-excursion
      (switch-to-buffer latex-math-preview-expression-buffer-name)
      (setq content (buffer-substring (point-min) (point-max)))
      )
    (with-temp-file img-name
      (insert content))
    (message (concat "Created: " img-name))
  ))

(defun d-latex-math-preview-insert-image ()
  (interactive)
  (d-latex-math-preview-save-image)
  (d-insert-last-image))
