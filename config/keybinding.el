; See more /home/ptmono/plans/emacsKeybinding.muse

;;; === Globals
;;; --------------------------------------------------------------
;(global-set-key (kbd "<f9> a") 'planner-create-task-from-buffer)
(global-set-key [f9] nil) ;기본으로 한자를 사용하는 quail-hangul-switch-hanja이 이키를 사용하고 있어서
(global-set-key [f8 ?1] 'planner-create-task)
(global-set-key [f8 ?2] 'planner-create-task-from-buffer)
(global-set-key [f8 ?3] 'planner-create-task-from-note)
(global-set-key [f8 ?4] 'planner-create-note-from-task)
(global-set-key [f8 ?5] 'planner-create-note)
;(global-set-key [f8 ?5] 'planner-create-high-priority-task-from-buffer)
;(global-set-key [f8 ?6] 'planner-create-medium-priority-task-from-buffer)
;(global-set-key [f8 ?7] 'planner-create-low-priority-task-from-buffer)
(global-set-key [f8 ?8] 'planner-update-note)
(global-set-key [f8 ?9] 'd-remember)
(global-set-key [f8 ?0] 'planner-update-task)
;(global-set-key [f8 ?0] 'planner-update-note
;;planner-create-high-priority-task-from-buffer
;;planner-create-low-priority-task-from-buffer
;;planner-create-medium-priority-task-from-buffer
;;planner-create-note		   planner-create-note-from-task
;;planner-create-task		   planner-create-task-from-buffer
;;planner-create-task-from-note

;(global-set-key (kbd "<f8> a SPC") 'remember)
(global-set-key [?\C-\S-y] 'clipboard-yank)

(global-set-key [f7 ?1] 'd-insert-time)
(global-set-key [f7 ?2] 'd-note)
(global-set-key [f10] 'd-citation)
(global-set-key [f5] 'planner-search-notes)
;(global-set-key [(shift f5)] 'planner-goto)
(global-set-key [f6] 'planner-goto)

(global-set-key [?\M-n] 'forward-paragraph)
(global-set-key [?\M-p] (lambda () (interactive) (forward-paragraph -1)))

;; I need no (suspend-frame) with C-z.
(global-set-key [?\C-z] (lambda () (interactive) (message "OOpssss")))

;; Cursor control
(global-set-key [?\C-c ?d ?h] (lambda () (interactive) (bury-buffer)))

;(global-set-key [f11] 'nil)
(global-set-key [f11] 'd-worknote-current)
;(global-set-key [(shift f11)] 'd-worknote-open-frame) ; 이 함수는 거의 쓰지를 않는다.
(global-set-key [(shift f11)] 'd-worknote-worknote)

;;; window selection
(global-set-key [?\C-x ?O] (lambda () (interactive) (other-window -1)))

;; (global-set-key [?\C-m] 'd-worknote-newline-heading)
(global-set-key [?\C-c ?d ?w] 'd-worknote-current)
(global-set-key [?\C-c ?d ?\M-f] 'd-worknote-set-frame-with-firefox)
(global-set-key [?\C-c ?d ?\M-c] 'd-worknote-set-frame-with-chromium)
(global-set-key [?\C-c ?d ?c] 'd-citation)

(global-set-key [?\C-c ?d ?1] (lambda () (interactive) (d-worknote-window-selecter 1)))
(global-set-key [?\C-c ?d ?2] (lambda () (interactive) (d-worknote-window-selecter 2)))
(global-set-key [?\C-c ?d ?3] (lambda () (interactive) (d-worknote-window-selecter 3)))
(global-set-key [?\C-c ?d ?4] (lambda () (interactive) (d-worknote-window-selecter 4)))
(global-set-key [?\C-c ?d ?5] (lambda () (interactive) (d-worknote-window-selecter 5)))
(global-set-key [?\C-c ?d ?6] (lambda () (interactive) (d-worknote-window-selecter 6)))
(global-set-key [?\C-c ?d ?7] (lambda () (interactive) (d-worknote-window-selecter 7)))
(global-set-key [?\C-c ?d ?8] (lambda () (interactive) (d-worknote-window-selecter 8)))
;; Fixme: Change the keybinding of d-worknote-create-tag. We use the key
;; with d-nosetest/set.
;(global-set-key [?\C-c ?d ?r] 'd-worknote-create-tag)

;;; etc
(global-set-key [?\C-c ?d ?t] 'd-find-file-tag)
(global-set-key [?\C-c ?d ?e] 'd-test)
(global-set-key [?\C-c ?d ?r] 'd-test-restore)
(global-set-key [?\C-c ?d ?v] 'view-mode)


;;; === Inserting
;;; --------------------------------------------------------------
; specified with C-c d i

(global-set-key [?\C-c ?d ?i ?t] 'd-insert-time)
(global-set-key [?\C-c ?d ?i ?h ?2] (lambda () (interactive) (d-worknote-newline-insert "-")))
(global-set-key [?\C-c ?d ?i ?h ?1] (lambda () (interactive) (d-worknote-newline-insert "=")))
(global-set-key [?\C-c ?d ?i ?h ?3] (lambda ()
				      (interactive)
				      (newline)
				      (insert (make-string fill-column ?-))
				      (newline)))
				      
				      
(global-set-key [?\C-c ?d ?i ?r] (lambda ()
				   (interactive)
				   (d-worknote-tag-ref-number "REF")))
(global-set-key [?\C-c ?d ?i ?f] 'd-worknote-firefox-get-url)


;;; === Searching
;;; --------------------------------------------------------------
(global-set-key [?\C-c ?1] (lambda () (interactive) (d-search "naverDic")))
;(global-set-key [?\C-c ?d ?s] (lambda () (interactive) (d-search "naverDic")))
;(global-set-key [?\C-c ?d ?s] (lambda () (interactive) (d-search "php")))
(global-set-key [?\C-c ?d ?s] (lambda () (interactive) (d-search "naverDic")))
;(global-set-key [?\C-c ?2] (lambda () (interactive) (d-search "dict.org")))
;(global-set-key [?\C-c ?2] (lambda () (interactive) (d-search "googleDefine")))
(global-set-key [?\C-c ?2] (lambda () (interactive) (d-search "pinvoke")))
(global-set-key [?\C-c ?3] (lambda () (interactive) (d-search "msdn")))
;(global-set-key [?\C-c ?3] (lambda () (interactive) (d-search "googlePythonGroup")))
(global-set-key [?\C-c ?4] (lambda () (interactive) (d-search "google")))
(global-set-key [?\C-c ?5] (lambda () (interactive) (d-search "googleGroup")))
(global-set-key [?\C-c ?6] (lambda () (interactive) (d-search "googleBlog")))
(global-set-key [?\C-c ?7] (lambda () (interactive) (d-search "del.icio.us")))
(global-set-key [?\C-c ?8] (lambda () (interactive) (d-search "naver")))
(global-set-key [?\C-c ?9] (lambda () (interactive) (d-search "kodersPython")))
(global-set-key [?\C-c ?0] (lambda () (interactive) (d-search "googleCodeSearch")))

(global-set-key [?\C-c ?s ?1] (lambda () (interactive) (d-search "naverDic")))
(global-set-key [?\C-c ?s ?2] (lambda () (interactive) (d-search "dict.org")))
(global-set-key [?\C-c ?s ?3] (lambda () (interactive) (d-search "googlePythonGroup")))
(global-set-key [?\C-c ?s ?4] (lambda () (interactive) (d-search "google")))
(global-set-key [?\C-c ?s ?5] (lambda () (interactive) (d-search "googleGroup")))
(global-set-key [?\C-c ?s ?6] (lambda () (interactive) (d-search "googleBlog")))
(global-set-key [?\C-c ?s ?7] (lambda () (interactive) (d-search "del.icio.us")))
(global-set-key [?\C-c ?s ?8] (lambda () (interactive) (d-search "naver")))
(global-set-key [?\C-c ?s ?9] (lambda () (interactive) (d-search "kodersPython")))
(global-set-key [?\C-c ?s ?0] (lambda () (interactive) (d-search "googleCodeSearch")))

(global-set-key [?\C-c ?s ?a] (lambda () (interactive) (d-search "amazon")))
(global-set-key [?\C-c ?s ?g] (lambda () (interactive) (d-search "google")))
(global-set-key [?\C-c ?s ?p] (lambda () (interactive) (d-search "googlePythonGroup")))


;;; === W3m
;;; --------------------------------------------------------------
(require 'w3m)
(unless (d-windowp)
  (define-key w3m-mode-map [mouse-8] 'w3m-view-previous-page)
  (define-key w3m-mode-map [drag-mouse-8] 'w3m-view-previous-page)
  (define-key w3m-mode-map [mouse-7] 'w3m-view-next-page)
  (define-key w3m-mode-map [drag-mouse-7] 'w3m-view-next-page)
  (define-key w3m-mode-map [?q] 'd-w3m-close-window)
;; some problem occure. when C-m emacs-w3m open new-session
;; (define-key w3m-mode-map [mouse-2] 'w3m-mouse-view-this-url-new-session)

  (define-key w3m-mode-map [?n] (lambda () (interactive) (scroll-up 24)))
  (define-key w3m-mode-map [?p] (lambda () (interactive) (scroll-up -24)))
  (define-key w3m-mode-map [?\C-c ?m ?o] 'd-open-with-browse)
  (define-key w3m-mode-map [?\C-c ?m ?d] 'd-demonoid-down)
  (define-key w3m-mode-map [?\C-c ?m ?f] 'find-dired-ebooks)
)


;;; === lisp
;;; --------------------------------------------------------------
(define-key lisp-interaction-mode-map [tab] 'lisp-complete-symbol)
(define-key lisp-interaction-mode-map [M-tab] 'ac-complete)
(define-key lisp-mode-map [tab] 'lisp-complete-symbol)
(define-key emacs-lisp-mode-map [tab] 'lisp-complete-symbol)
;; [?\C-c ?r] is mapped by erefactor-map


;;; === .gnus
;;; --------------------------------------------------------------
;; some example
;; (eval-after-load "gnus"
;;   #'(define-key gnus-summary-mode-map
;;       [return] 'browse-nnrss-url))
;;       (kbd "<RET>") 'browse-nnrss-url))


;; (eval-after-load "gnus"
;;   #'(define-key gnus-summary-mode-map
;;       [mouse-2] 'browse-nnrss-url))
;; notice kp key kp_enter, KP-Enter 같은 키는 먹히지 않는다. 대문자와 _를 조심하자.

(define-key gnus-summary-mode-map [kp-enter] 'browse-nnrss-url)
(define-key gnus-summary-mode-map [kp-delete] 'gnus-summary-next-page)

(unless (d-windowp)
  (define-key w3m-mode-map [kp-insert] 'd-gnus-back-summary-buffer)
  )
(define-key gnus-group-mode-map [?\C-c?\M-g] (lambda () (interactive) (gnus-activate-all-groups gnus-level-subscribed)))



(defun d-gnus-back-summary-buffer ()
  ""
  (interactive)
  (switch-to-buffer nil))

;; (global-set-key [(f1)] (lambda ()
;; 			 (interactive)
;; 			 (manual-entry
;; 			  (current-word))))


;;; === Minibuffer
;;; --------------------------------------------------------------
;; using tab-completion in M-!
(define-key minibuffer-local-map [C-tab] 'comint-dynamic-complete)
;; TODO: It is same mean both "#'" and "'" ?
(define-key read-expression-map (kbd "TAB") #'lisp-complete-symbol)


;;; === C/C++
;;; --------------------------------------------------------------
(define-key c-mode-base-map [?\C-c ?b] 'ff-find-other-file)
(define-key c-mode-base-map [?\C-c ?e ?n] 'flymake-goto-next-error)
(define-key c-mode-base-map [?\C-c ?e ?p] 'flymake-goto-prev-error)
(define-key c-mode-base-map  [tab] 'auto-complete)
;; It is used to list method for object.
(define-key c-mode-base-map [M-tab] 'semantic-ia-complete-symbol-menu)


;;; === Auto-complete
;;; --------------------------------------------------------------
;(define-key ac-mode-map  [tab] 'auto-complete)
(define-key ac-mode-map [?\C-c ?j ?j] 'semantic-ia-fast-jump)
;; (define-key ac-mode-map [?\C-c ?j
;; (define-key ac-mode-map [?\C-c ?j
;; (define-key ac-mode-map [?\C-c ?j
;; (define-key ac-mode-map [?\C-c ?j


;;; === doxymacs
;;; --------------------------------------------------------------
;; It is removed in doxymacs.el to modify key.

(defvar doxymacs-mode-map (make-sparse-keymap)
  "Keymap for doxymacs minor mode.")

(define-key doxymacs-mode-map "\C-cdi?" 'doxymacs-lookup)
(define-key doxymacs-mode-map "\C-cdir" 'doxymacs-rescan-tags)

(define-key doxymacs-mode-map "\C-cdi\r" 'doxymacs-insert-command)
(define-key doxymacs-mode-map "\C-cdif" 'doxymacs-insert-function-comment)
(define-key doxymacs-mode-map "\C-cdii" 'doxymacs-insert-file-comment)
(define-key doxymacs-mode-map "\C-cdim" 'doxymacs-insert-blank-multiline-comment)
(define-key doxymacs-mode-map "\C-cdis" 'doxymacs-insert-blank-singleline-comment)
(define-key doxymacs-mode-map "\C-cdi;" 'doxymacs-insert-member-comment)
(define-key doxymacs-mode-map "\C-cdi@" 'doxymacs-insert-grouping-comments)

;;;###autoload
(or (assoc 'doxymacs-mode minor-mode-alist)
    (setq minor-mode-alist
	  (cons '(doxymacs-mode " doxy") minor-mode-alist)))

(or (assoc 'doxymacs-mode minor-mode-map-alist)
    (setq minor-mode-map-alist
	  (cons (cons 'doxymacs-mode doxymacs-mode-map)
		minor-mode-map-alist)))


;;; === Python
;;; --------------------------------------------------------------
(require 'python-mode)
;(define-key python-mode-map [tab] 'python-complete-symbol)

;(define-key python-mode-map [tab] 'symbol-complete) ; changed in version 23.0.60.1
;symbol-complete gone in 23.1.90.1
;There is python-completion-at-point but it has bug.
;(define-key python-mode-map [tab] 'python-completion-at-point)
;so I use currently pycomplete in python-mode directory
;python-config.el contains the configuration
;(define-key python-mode-map [tab] 'py-complete)
;(define-key python-mode-map [tab] 'completion-at-point)

;; We use following completion
;; [tab] --> auto-complete
;; [?\M-tab] --> completion-at-point
(define-key python-mode-map [?\C-c ?\C-h] 'pylookup-lookup)

;(define-key py-mode-map [tab] 'anything-ipython-complete)
;(define-key py-mode-map [tab] 'anything-ipython-complete)
;(define-key inferior-python-mode-map [?\C-i] 'indent-for-tab-command)
;(define-key inferior-python-mode-map [tab] 'comint-dynamic-complete)

;;; ipython
(define-key py-shell-map [?\C-c ?\C-f] 'python-describe-symbol)

(define-key python-mode-map [?\C-c ?e ?n] 'flymake-goto-next-error)
(define-key python-mode-map [?\C-c ?e ?p] 'flymake-goto-prev-error)

(define-key python-mode-map [?\C-c ?i]  'd-python/insert)
(define-key python-mode-map [tab]  'py-complete)
(define-key python-mode-map [C-backspace]  'backward-kill-word)
(define-key python-mode-map [?\C-c ?\C-f] 'py-documentation) ;Original is py-sort-imports

;;; ropemacs
; ropemacs-mode define C-c d as rope-show-doc. It comflict my configurations.
;; (unless (d-windowp)
;;   (define-key ropemacs-local-keymap [?\C-c ?d] nil)
;;   )
; and ropemacs-mode use C-x p, C-c r prefix in python-mode
;; ropemacs keys are disabled. Redefine
(define-key python-mode-map [?\C-c ?r ?d]  'rope-show-doc)
(define-key python-mode-map [?\C-c ?r ?f]  'rope-find-occurrences)
(define-key python-mode-map [?\C-c ?r ?g]  'rope-goto-definition)
(define-key python-mode-map [?\C-c ?r ?f]  'rope-find-occurrences)
(define-key python-mode-map [?\C-c ?r ?p]  'rope-pop-mark)
(define-key python-mode-map [?\C-c ?r ?d]  'rope-introduce-factory)
(define-key python-mode-map [?\C-c ?r ?i]  'rope-inline)
(define-key python-mode-map [?\C-c ?r ?l]  'rope-extract-variable)
(define-key python-mode-map [?\C-c ?r ?m]  'rope-extract-method)
(define-key python-mode-map [?\C-c ?r ?o]  'rope-organize-imports)
(define-key python-mode-map [?\C-c ?r ?r]  'rope-rename)
(define-key python-mode-map [?\C-c ?r ?s]  'rope-change-signature)
(define-key python-mode-map [?\C-c ?r ?u]  'rope-use-function)
(define-key python-mode-map [?\C-c ?r ?v]  'rope-move)
(define-key python-mode-map [?\C-c ?r ?x]  'rope-restructure)
(define-key python-mode-map [?\C-c ?r ?1 ?p]  'rope-module-to-package)
(define-key python-mode-map [?\C-c ?r ?1 ?r]  'rope-rename-current-module)
(define-key python-mode-map [?\C-c ?r ?1 ?v]  'rope-move-current-module)

(define-key python-mode-map [?\C-c ?r ?n ?c]  'rope-generate-class)
(define-key python-mode-map [?\C-c ?r ?n ?f]  'rope-generate-function)
(define-key python-mode-map [?\C-c ?r ?n ?m]  'rope-generate-module)
(define-key python-mode-map [?\C-c ?r ?n ?p]  'rope-generate-package)
(define-key python-mode-map [?\C-c ?r ?n ?v]  'rope-generate-variable)
(define-key python-mode-map [?\C-c ?r ?a ?/]  'rope-code-assist)
(define-key python-mode-map [?\C-c ?r ?a ??]  'rope-lucky-assist)
(define-key python-mode-map [?\C-c ?r ?a ?c]  'rope-show-calltip)
(define-key python-mode-map [?\C-c ?r ?a ?d]  'rope-show-doc)
(define-key python-mode-map [?\C-c ?r ?a ?f]  'rope-find-occurrences)
(define-key python-mode-map [?\C-c ?r ?a ?g]  'rope-goto-definition)
(define-key python-mode-map [?\C-c ?r ?a ?i]  'rope-find-implementations)
(define-key python-mode-map [?\C-c ?r ?a ?j]  'rope-jump-to-global)


;;; === Info
;;; --------------------------------------------------------------
(define-key Info-mode-map [mouse-8] 'Info-history-back)
(define-key Info-mode-map [drag-mouse-8] 'Info-history-back)

(define-key Info-mode-map [mouse-7] 'Info-up)
(define-key Info-mode-map [drag-mouse-7] 'Info-up)


;;; === Shell
;;; --------------------------------------------------------------
(define-key shell-mode-map [?\C-i] 'indent-for-tab-command)
(define-key shell-mode-map [tab] 'comint-dynamic-complete)


;;; === Window selection
;;; --------------------------------------------------------------
;      (define-key map [(shift iso-lefttab)] 'muse-previous-reference)
;      (define-key map [(shift control ?i)] 'muse-previous-reference))
;
;    (define-key map [(control ?c) (control ?f)] 'muse-project-find-file)
;    (define-key map [(control ?c) (control ?p)] 'muse-project-publish)
;
;    (define-key map [(control ?c) tab] 'muse-insert-thing)
;
;    ;; Searching functions
;    (define-key map [(control ?c) (control ?b)] 'muse-find-backlinks)
;    (define-key map [(control ?c) (control ?s)] 'muse-search)
;
;    ;; Enhanced list functions
;    (define-key map [(meta return)] 'muse-insert-list-item)
;    (define-key map [(control ?>)] 'muse-increase-list-item-indentation)
;    (define-key map [(control ?<)] 'muse-decrease-list-item-indentation)
;
;    (when (featurep 'pcomplete)
;      (define-key map [(meta tab)] 'pcomplete)
;      (define-key map [(meta control ?i)] 'pcomplete))
;


;(global-set-key [?\C-\S-v] (lambda () (interactive) (scroll-up 10)))

;(define-key muse-mode-map [?\C-c?\C-c] (lambda () (interactive) (planner-copy-or-move-task nil)))


;;; === Etc
;;; --------------------------------------------------------------


;;; === Muse and Planner
;;; --------------------------------------------------------------
;; specified with C-c d p
(global-set-key [?\C-c ?d ?p ?r] 'd-remember) 
(define-key planner-mode-map [?\M-n] 'forward-paragraph)
(define-key planner-mode-map [?\M-p] (lambda () (interactive) (forward-paragraph -1)))

(define-key muse-mode-local-map [(shift return)] 'd-open-link-other-window)
(define-key muse-mode-map [?\C-i] 'indent-relative)
(define-key muse-mode-map [?\M-n] 'forward-paragraph)
(define-key muse-mode-map [?\M-p] (lambda () (interactive) (forward-paragraph -1)))


(define-key muse-mode-map [?\C-c ?i] 'd-worknote/insert)
;;; === Outline-mode
;;; --------------------------------------------------------------
;; Outline-minor-mode key mape

;; See outline-config.el


;;; === Dired
;;; --------------------------------------------------------------
(define-key dired-mode-map [??] 'd-worknote-file-info)


;;; === Gcal
;;; --------------------------------------------------------------
;; See gcal-config.el



;;; === Auctex
;;; --------------------------------------------------------------
(add-hook 'latex-mode-hook (lambda ()
			     (define-key TeX-mode-map [tab] 'TeX-complete-symbol)))


;;; === yasnippet
;;; --------------------------------------------------------------
;;; disable tab binding
(define-key yas/minor-mode-map [(tab)] nil)
(define-key yas/minor-mode-map(kbd "TAB") nil)
