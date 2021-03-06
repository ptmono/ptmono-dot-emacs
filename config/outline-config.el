
;; The outline-regexp of muse-mode is defined in muse-mode-hook. The value
;; is d-note-section-regexp


(eval-after-load "outline" '(require 'foldout))

(add-to-list 'find-file-hook 'outline-minor-mode)

(defvar d-outline-history)

(defvar d-outline-regexp-alist
  '(("java" "\\(?:\\([ \t]*.*\\(class\\|interface\\)[ \t]+[a-zA-Z0-9_]+[ \t\n]*\\({\\|extends\\|implements\\)\\)\\|[ \t]*\\(public\\|private\\|static\\|final\\|native\\|synchronized\\|transient\\|volatile\\|strictfp\\| \\|\t\\)*[ \t]+\\(\\([a-zA-Z0-9_]\\|\\( *\t*< *\t*\\)\\|\\( *\t*> *\t*\\)\\|\\( *\t*, *\t*\\)\\|\\( *\t*\\[ *\t*\\)\\|\\(]\\)\\)+\\)[ \t]+[a-zA-Z0-9_]+[ \t]*(\\(.*\\))[ \t]*\\(throws[ \t]+\\([a-zA-Z0-9_, \t\n]*\\)\\)?[ \t\n]*{\\)")
    ("shell" "^[\\[]\\$\\|^(")
    ("muse" "^\\.#+[A-z]?[0-9]+\\|^[*\f]+ \\|^[A-Z]+: \\|^[@\f]+ ")
    ("muse-heading" "^\\.#+[A-z]?[0-9]+\\|^[*\f]+ \\|^[@\f]+ ")
    ("ipython" "^In \\[")
    ("javascript" "^\\(var\\|function\\|\\$\\)\\|\t*function")
    ("semantic" d-keybinding/semantic-tag)
    ("outline" d-keybinding/outline)
    ("cpp" "^[A-z]\\|^//")
    ("autoit" "[ ]*Func .+")
    ("csharp" "\\(?:[ \t]*\\(public\\|private\\|static\\|final\\|native\\|synchronized\\|transient\\|volatile\\|strictfp\\| \\|\t\\)*[ \t]+\\(\\([a-zA-Z0-9_]\\|\\( *\t*< *\t*\\)\\|\\( *\t*> *\t*\\)\\|\\( *\t*, *\t*\\)\\|\\( *\t*\\[ *\t*\\)\\|\\(]\\)\\)+\\)[ \t]+[a-zA-Z0-9_]+[ \t]*(\\(.*\\))[ \t]*\\(throws[ \t]+\\([a-zA-Z0-9_, \t\n]*\\)\\)?[ \t\n]*\\)")

    ("cs" "\\([ \t]*\\(namespace\\|public\\|private\\|static\\|final\\|native\\|synchronized\\|transient\\|volatile\\|strictfp\\|internal\\|protected\\)\\)")
    ))


;;; === Heading search
;;; --------------------------------------------------------------

(defvar d-section-tag/infos-table nil) ;(start end title)
(defvar d-section-tag/words nil)
(defvar d-section-tag/section-regexp
  "^*+\\s-+\\(.+\\)\\|^\\.#+[A-z]?[0-9]+\\s-+\\(.+\\)\\|^[@\f]+\\s-+\\(.+\\)")
(defvar d-section-tag/cached-buffer-infos nil
  "This buffer is already cached.")	;(buffer-file-name point-max)

(defun strip-text-properties(txt)
  (set-text-properties 0 (length txt) nil txt)
  txt)

(defun d-section-tag/createTable ()
  (let* (title
	 table
	 start
	 end
	 set)
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward d-section-tag/section-regexp  nil t)
	(setq set nil)
	(setq title (strip-text-properties (match-string 1)))
	;; FIXME: why not just 1 ?
	(unless title
	  (setq title (strip-text-properties (match-string 2)))
	  (unless title
	    (setq title (strip-text-properties (match-string 3)))))

	(setq title (downcase title))
	(setq start (match-beginning 0))
	(setq end (match-end 0))
	(setq set (list start end title))
	(setq table (cons set table))
	)
      (setq d-section-tag/infos-table table))))

(defun d-section-tag/createWordList ()
  ;; If you want to speed up, merge with d-section-tag/createTable.
  (let* ((table d-section-tag/infos-table)
	 element
	 result
	 title)
    (while table
      (setq element (car table))
      (setq table (cdr table))

      (setq title (nth 2 element))
      (setq result (append result (split-string title))))
    (setq d-section-tag/words (delete-dups result))))

(defun d-section-tag/setCachedInfos ()
  (setq d-section-tag/cached-buffer-infos
	(list (buffer-file-name) (point-max))))

(defun d-section-tag/cache ()
  (d-section-tag/createTable)
  (d-section-tag/createWordList)
  (d-section-tag/setCachedInfos)
)

(defun d-section-tag/init ()
  (let* ((cached-buffer-file-name (if d-section-tag/cached-buffer-infos
				      (nth 0 d-section-tag/cached-buffer-infos)
				    nil))
	 (cached-point-max (if d-section-tag/cached-buffer-infos
			       (nth 1 d-section-tag/cached-buffer-infos)
			     nil)))
    (if (equal cached-point-max (point-max))
	(unless (equal cached-buffer-file-name (buffer-file-name))
	  (d-section-tag/cache))
      (d-section-tag/cache))))

(defun d-section-tag/find()
  (interactive)
  (d-section-tag/init)
  (setq outline-regexp d-section-tag/section-regexp)
  (let* ((str (completing-read "Search: " d-section-tag/words)))
    (d-section-tag/showOnly str)))

(defun d-section-tag/showOnly(str)
  (show-all)
  (hide-body)
  (let* ((table d-section-tag/infos-table)
	 element
	 title
	 start
	 end)
    (while table
      (setq element (car table))
      (setq table (cdr table))
      
      (setq title (nth 2 element))
      (unless (string-match-p str title)
	(setq start (nth 0 element))
	(setq end (nth 1 element))
	(outline-flag-region (- start 1) end t)
	))))
    

;;; === Keybinding and eassist way
;;; --------------------------------------------------------------

(require 'outline)
(defvar d-keybinding/initp nil)

(defun d-keybinding/outline ()
  (define-prefix-command 'cm-map nil "Outline-")
  ;; HIDE
  (define-key cm-map "q" 'hide-sublevels)    ; Hide everything but the top-level headings
  (define-key cm-map "t" 'hide-body)         ; Hide everything but headings (all body lines)
  (define-key cm-map "o" 'hide-other)        ; Hide other branches
  (define-key cm-map "c" 'hide-entry)        ; Hide this entry's body
  (define-key cm-map "l" 'hide-leaves)       ; Hide body lines in this entry and sub-entries
  (define-key cm-map "d" 'hide-subtree)      ; Hide everything in this entry and sub-entries
  ;; SHOW
  (define-key cm-map "a" 'show-all)          ; Show (expand) everything
  (define-key cm-map "e" 'show-entry)        ; Show this heading's body
  (define-key cm-map "i" 'show-children)     ; Show this heading's immediate child sub-headings
  (define-key cm-map "k" 'show-branches)     ; Show all sub-headings under this heading
  (define-key cm-map "s" 'show-subtree)      ; Show (expand) everything in this heading & below
  ;; MOVE
  (define-key cm-map "u" 'outline-up-heading)                ; Up
  (define-key cm-map "n" 'outline-next-visible-heading)      ; Next
  (define-key cm-map "p" 'outline-previous-visible-heading)  ; Previous
  (define-key cm-map "f" 'outline-forward-same-level)        ; Forward - same level
  (define-key cm-map "b" 'outline-backward-same-level)       ; Backward - same level
  ;; ETC
  (define-key cm-map "r" 'd-outline-change-regexp)           ; For regexp
  (require 'eassist)
  (define-key cm-map "m" 'eassist-list-methods)              ; List methods. It from cedet
  (define-key cm-map "j" 'semantic-ia-fast-jump)

  (define-key cm-map "w" 'd-section-tag/find)        ; Forward - same level
  ;; outline-regexp를 바꾸고 다시 원상복구하는 문제가 있는데요. 그건 다시 원래의
  ;; mode를 실행해주면 됩니다. lisp-mode 에서 바꾸었으면 M-x lisp-mode 해주면
  ;; 됩니다. 각 모드에서 outline-regexp 를 지정해주고 있습니다.

  ;; local-set-key overides global-set-key. So if only global-set-key,
  ;; then only semantic-tag-folding-mode-map local-set-key is applied when
  ;; push \M-o.
  (if d-keybinding/initp
      (local-set-key "\M-o" cm-map)
    (global-set-key "\M-o" cm-map)
    (setq d-keybinding/initp t))

  (if (d-not-windowp)
      (semantic-tag-folding-mode -1))
  (outline-minor-mode 1)
  )
;; Init outline
(d-keybinding/outline)

(defun d-keybinding/semantic-tag ()
  (define-prefix-command 'stf-map nil "Semantic-")
  ;; HIDE
  (define-key stf-map "q" 'semantic-tag-folding-fold-children)
  (define-key stf-map "t" 'semantic-tag-folding-fold-all)
  (define-key stf-map "c" 'semantic-tag-folding-fold-block)
  ;; SHOW
  (define-key stf-map "a" 'semantic-tag-folding-show-all)
  (define-key stf-map "i" 'semantic-tag-folding-show-children)
  (define-key stf-map "e" 'semantic-tag-folding-show-block)
  ;; ETC
  (define-key stf-map "r" 'd-outline-change-regexp)
  (require 'eassist)
  (define-key stf-map "m" 'eassist-list-methods)              ; List methods. It from cedet
  (define-key stf-map "j" 'semantic-ia-fast-jump)

  ;; Bind map
  (local-set-key "\M-o" stf-map)

  (outline-minor-mode -1)
  (semantic-tag-folding-mode 1)
  )

;; TODO: We need specified outline-regexpst. Use tab key to choose.
(defun d-outline-change-regexp()
  (interactive)
  (if current-prefix-arg
      (progn
	(make-local-variable 'outline-regexp)
	(setq outline-regexp (read-string "Regexp: " outline-regexp 'd-outline-history "^[*\f]+ ")))
    (let* ((key (completing-read "Regexp alist : " d-outline-regexp-alist))
	   (con (assoc key d-outline-regexp-alist))
	   (regexp (car (cdr con))))
      (if (symbolp regexp)
	  (funcall regexp)
	(setq outline-regexp regexp)))))


