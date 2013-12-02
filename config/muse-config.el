;;; logs

; 0904260400 added d-muse-indent


;;; todo

; 0904260430 d-muse-indent has a problem. See worknote2.muse#0904260252


;; Use package.el

(require 'muse)
(require 'muse-mode)     ;load authoring mode
(require 'muse-html)     ;load publishing styles I use
(require 'muse-latex)
(require 'muse-texinfo)
(require 'muse-docbook)
(require 'muse-colors)
(require 'muse-journal)

;; 이부분은 notes#latex와 같이 notes라는 project의 latex page를 링크를
;; 가능하게 하기 위해서 필요한 부분이다. 0605171221 don't use.
;; 이 부분을 없앤다면 project의 link를 할수가 없었다.
(require 'muse-wiki)


(add-to-list 'load-path (concat d-dir-emacs "cvs/planner/"))
(load "planner")
(require 'planner)

(load "muse")
(load "muse-colors")
(require 'd-library)

(defvar d-muse-project-publish-buffer-list-before nil)
(defvar d-muse-tag-1 "\\(^[A-Z_]+\\>\\): "
  "This is a regexp for worknote. e.g)
MEMO:
or
DAIRY:
")




;;; === Init
;;; --------------------------------------------------------------
(defun d-muse-mode-init ()
  "Init with muse-mode. It is applied to muse-mode-hook."
  (auto-fill-mode)			; See [[plannerAndRemember]]
  (outline-minor-mode)
  (flyspell-mode)
  (footnote-mode)
  (make-local-variable 'outline-regexp)
  (make-local-variable 'outline-heading-end-regexp)
  (setq outline-regexp d-note-section-regexp) ;We define outline-regexp
  (setq outline-heading-end-regexp "\n")
  ;; (make-local-variable 'indent-line-function)
  ;; (setq indent-line-function 'd-muse-indent)
  ;; (setq outline-regexp "^\\.#[0-9]+\\|*+\\|***[a-Z]+")
  ;;   (hide-body)
  ;;   (while (re-search-forward "^* " nil t)
  ;;     (show-entry))
  ;;   (re-search-backward "^* Tasks" nil t)))
  )
(add-hook 'muse-mode-hook 'd-muse-mode-init)

;; For no extension
;; (setq muse-file-extension nil
;;       muse-mode-auto-p t
;;       )

;; TODO Clear "WelcomPage" error
(custom-set-variables
 '(planner-use-day-pages nil) 		; To avoid "WelcomePage" error in
					; Windows. But It is not cleared.

 '(muse-publish-contents-depth 3))


;;; === Indent
;;; --------------------------------------------------------------
;; muse에서는 indent function을 제공하고 있지 않고 있다.
;; indent function에 대한 설명은 worknote2.muse#0904260252 을 참조
;; 방법은 muse에서 local variable 'indent-line-function 을 지정해 주면 된다.(hook이라 생각하면 될듯)
;; 나는 d-muse-indent function을 만들어 적용시킬 것이다.

;; d-muse-mode-hook 을 사용하면 되것다.

;; 현재 문제가 있다. worknote2.muse#0904260252 참조


(defun d-muse-indent ()
  ""
  (interactive)
  ;(indent-relative)
  )

;;; image


;;; === search regexp
;;; --------------------------------------------------------------
; variable muse-grep-command has the command of shell. The doc of
; muse-grep-command recommands **glimpse** for large project. The command
; glimpseindex will index the texts and glimpse can used to search.

; I do not need the search results of '*,v' files
;(setq muse-grep-command "find %D -type f ! -name '*~' ! -name '*,v' | xargs -I {} echo \\\"{}\\\" | xargs egrep -n -e \"%W\"")

(setq muse-grep-command
;; "find %D -type f ! -name '*~' ! -name '*.html' ! -name '*.xhtml' ! -name '*.js' ! -name '*,v' ! -name '*ebook_list' ! -name '*#' ! -name '*.pdf' ! -name '*.rar' ! -name '*.zip' ! -name '*.css' ! -name '*.js' ! -name '*.xul' ! -name '*.rdf' ! -name '*.log' ! -name '*.xml' ! -name '*.dtd' | xargs -I {} echo \\\"{}\\\" | xargs egrep -n -e \"%W\"")
      " find %D -type f -name '*.muse' | xargs -I {} echo \\\"{}\\\" |xargs egrep -n -i -e \"%W\"")


;;; === publish
;;; --------------------------------------------------------------
;; See muse-publish-config.el


;;; === For tags
;;; --------------------------------------------------------------
(defvar d-w-tag-file-muse "/home/ptmono/works/ppf/test/cc.muse")

(defun d-w-tag-content-list (regexp)
  (let* ((end-point t)
	 (case-fold-search t)
	 content-list)
    (save-excursion
      (goto-char (point-min))
      (while end-point
	(let* ((beg (if (re-search-forward regexp nil t)
			(match-beginning 0)
		      nil))
	       (end (re-search-forward "\n\n\n" nil t)))
	  (if beg
	      (add-to-ordered-list 'content-list 
				   (d-libs-string-delete-whitespace (buffer-substring beg end)))
	    (setq end-point nil))))
      content-list)))

      
(defun d-w-tag-create-muse (regexp)
  "Create specific tags muse-file."
  (interactive (list (read-string "REGEXP: ")))
  (let* ((content-list (save-excursion
			 (d-w-tag-content-list regexp))))
    ;; find buffer
    (d-window-separate)
    (other-window 1)
    (find-file d-w-tag-file-muse)
    (erase-buffer)
    
    ;; Insert content
    (while content-list
      (insert (car content-list))
      (setq content-list (cdr content-list)))))


;;; === Colors
;;; --------------------------------------------------------------
;; color-theme for the muse-headers is not applied. I don't know the
;; reason. So I hook the colors

(defface d-muse-colors-underlined-2-face
  '((t (:background "#f5ff4f" :foreground "black")))
  ;'((t (:background "#005913" :foreground "white")))
  "Face for Muse cross-references."
  :group 'muse-colors)

(defface d-muse-colors-underlined-1-face
  '((t (:underline "red")))
  "Face for Muse cross-references."
  :group 'muse-colors)

(defface d-muse-colors-notes
  '((t (:foreground "#ff7575")))
  "Face for Muse cross-references."
  :group 'muse-colors)

(defface d-muse-colors-strike-through
  '((t (:strike-through "black")))
  "Face for Muse cross-references."
  :group 'muse-colors)

(defface muse-reference-face
  '((((class color) (background light))
     (:foreground "blue" :underline "blue" :bold t))
    (((class color) (background dark))
     (:foreground "cyan" :underline "cyan" :bold t))
    (t (:bold t)))
  "Face for Muse cross-references."
  :group 'muse-colors)

(defface d-muse-sub-sections
  '((((class color) (background light))
     (:foreground "blue" :bold t))
    (((class color) (background dark))
     (:foreground "cyan" :bold t))
    (t (:bold t)))
  "Face for Muse cross-references."
  :group 'muse-colors)

(defface muse-faq-face
  '((t (:background "#ff7575")))
  ""
  :group 'muse-colors)


;; to set muse-emphasis 1 2 3
(set-face-attribute 'muse-emphasis-1 nil
:foreground "#1143ff"
:underline nil)

(set-face-attribute 'muse-emphasis-3 nil
:foreground "red")

;; Change the face of headers
(defun d-muse-set-header-faces (&optional frame)
  "We modified the face of headers. The function muse-make-faces
defines the faces of headers. It is hooked to
after-make-frame-functions and window-setup-hook. Our modified
faces of headers will be disappered after M-x 5 2. So let's
replement the modified faces of headers."
  ;; This color only apply to d-color-theme-hober theme.
  (when d-color-theme-p
    (if (d-windowp)
	(set-face-attribute 'muse-header-1 nil
			    :inherit 'vaiable-pitch
			    :overline "yellow"
			    :foreground "white"
			    :weight 'bold
			    :height 1.4
			    :font "DejaVu Sans Mono-14")
	
      (set-face-attribute 'muse-header-1 nil
			  :inherit 'vaiable-pitch
			  :overline "yellow"
			  :foreground "white"
			  :weight 'bold
			  :height 1.4
			  ;; :font "-misc-fixed-medium-r-normal--20-140-100-100-c-100-iso8859-1")
			  :family "helv")
      )
    (set-face-attribute 'muse-header-2 nil
			:family "helv"
			:foreground "#968759"
			:weight 'bold
			)
    (set-face-attribute 'muse-header-3 nil
			:family "helv"
			:foreground "#6f6f6f"
			:weight 'bold
			)
			))
(add-hook 'muse-mode-hook 'd-muse-set-header-faces)

;; After M-x 5 2 d-muse-set-header-faces are disappered. Because muse-mode
;; hooks muse-make-faces to after-make-frame-functions and window-setup-hook.
;; Let's reimplement.
(add-hook 'window-setup-hook #'d-muse-set-header-faces t)
(when (boundp 'after-make-frame-functions)
  (add-hook 'after-make-frame-functions #'d-muse-set-header-faces t))


;; It is no more used. Muse changed the method.
;; (defvar d-muse-font-lock-keywords
;;   '(("reference" . muse-reference-face)
;;     ("^;!faq" . muse-faq-face)))
;; (dolist (rule d-muse-font-lock-keywords)
;;   (add-to-list 'muse-colors-markup
;; 	       (list (car rule) t (cdr rule))
;; 	       t))


(defun d-muse-highlighting (beg end &optional verbose)
  "muse highlighting method
0706102041 problem
planner에서만 잘 적용되는 것 같다.
"
  ;; (while (re-search-forward "^-----$" end t)
  ;;   (add-text-properties (match-beginning 0)
  ;; 			 (+ 5 (match-beginning 0))
  ;; 			 ;; '(display '((image . d-line-1)))))) ;Failed
  ;; 			 ;; '(display '((image . (:type jpeg :file "~/files/image162.jpg"))))))) ;Failed
  ;; 			 ;; '(display (and "aaa" '(image . (:type jpeg :file "~/files/image162.jpg"))))))) ;Failed
  ;; 			 ;; '(display '(image . d-line-1)))));Failed
  ;; 			 ;; '(display "[[../files/image162.jpg]]")))) ;Failed. String is displaied.
  ;; 			 ;; '(display "-------------------------------------------"))))
  ;; 			 ;; '(face '((t (:foreground "green")))))))
  ;; 			 ;; '(display '(image . (:type jpeg :file "~/files/image162.jpg"))
  ;; 			 '(display '(image . (:type jpeg :file "~/files/image162.jpg" :conversion laplace)))))

  ;; (while (re-search-forward "Dimanche" end t)
  ;;   (add-text-properties (match-beginning 0)
  ;;                        (+ 30 (match-beginning 0))
  ;;                        '(face dimanche-face))


  ;; (while (re-search-forward "^----$" end t)
  ;;   (add-text-properties (match-beginning 0)
  ;; 			 (+ 4 (match-beginning 0))
  ;; 			 '(display '(image . (:type jpeg :file "~/imgs/image162.jpg")))))

  (while (re-search-forward "^\\(#\\\)\\([0-9]\\{6\\}\\)\\([0-9]\\{4\\}\\)$" end t)
    (add-text-properties (match-beginning 0)
			 (match-end 0)
			 '(face muse-reference-face)))

  (while (re-search-forward "^\\([0-9]\\{6\\}\\)\\([0-9]\\{4\\}\\)$" end t)
    (add-text-properties (match-beginning 0)
			 (match-end 0)
			 '(face muse-reference-face)))

  ;; indent section in outline-mode
  ;; 잠시 보류
  ;; (while (re-search-forward "^[\\*]+ " end t)
  ;;   (add-text-properties (match-beginning 1)
  ;;   			 (match-end 1)
  ;;   			 '(display ("  ** "))) ; ok
  ;; 			 ;; the display property has a list, not quote
  ;; 			 ;; '(display (list (space . (:height :width 2)) (height 3)))) ;ok

  ;;   (add-text-properties (match-beginning 0)
  ;;   			 (match-end 0)
  ;;   			 ;; '(display '(space . (:height 5))))) ;ok


  ;;   			 ;; '(display '(space . (:height 5))))) ;ok

  ;;   			 ;; '(display (height 5))))  ; ok
  ;;   			 ;; '(display "   ** " '(height 5)))) ; not
  ;;   			 ;; '(display " ** " '((space . (:height 5)))))) ; not

  ;;   			 ;; '(display " ** " (:height 5)))) ; not
  ;;   			 ;; '(display " ** " '(space . (:height 5))))) ; not
  ;;   			 ;; '(display " ** " (space . (:height 5))))) ; not

  ;;   			 ;; '(display '((t "  ** "))))) ; not
  ;;   			 ;; '((display "  ** ")))) ; not
  ;;   			 ;; '((display '("  ** " '(display '(space . (:height 5)))))))) ; not
  ;;   			 ;; '(display '(:height 5)))) no
  ;;   			 '(display (:height 5))))

  ;; (while (re-search-forward "^\\([[:alnum:]- ]+\\) ::" end t)
  ;;   (add-text-properties (match-beginning 1)
  ;; 			 (match-end 1)
  ;; 			 '(face dictionary-button-face)))

  ;; (while (re-search-forward "^\\.##.+" end t)
  ;;   (add-text-properties (match-beginning 0)
  ;; 			 (match-end 0)
  ;; 			 '(face planner-note-headline-face)))

  ;; (while (re-search-forward "^\\.###.+" end t)
  ;;   (add-text-properties (match-beginning 0)
  ;; 			 (match-end 0)
  ;; 			 '(face planner-note-headline-face)))

  ;; (while (re-search-forward (concat"__[^" muse-regexp-blank "_\n(]") end t)
  ;;   (d-muse-colors-underlined-2))

  ;; (while (re-search-forward (concat "__[^" muse-regexp-blank "_\n(]") end t)
  ;;   (add-text-properties (+ (match-beginning 0) 3)
  ;; 			 (match-end 0)
  ;; 			 '(face d-muse-colors-underlined-2-face)))

  ;; (while (re-search-forward "^!!!note" end t)
  ;;   (add-text-properties (match-beginning 0)
  ;; 			 (match-end 0)
  ;; 			 '(face d-muse-colors-notes)))

  (while (re-search-forward "^\\(@+\\) \\(.+\\)$" end t)
    (add-text-properties (match-beginning 2)
			 (match-end 2)
			 '(face d-muse-sub-sections)))

  (while (re-search-forward "^\\(-+>\\)\\(.+\\)" end t)
    (add-text-properties (match-beginning 2)
			 (match-end 2)
			 '(face d-muse-sub-sections))
    (add-text-properties (match-beginning 1)
			 (match-end 1)
			 '(face muse-emphasis-3)))

  (while (re-search-forward "\\([a-z ]*\\)-+>\\([A-Z]*\\): \\(.+\\)" end t)
    (add-text-properties (match-beginning 1)
			 (match-end 1)
			 '(face bold))
    (add-text-properties (match-beginning 2)
			 (match-end 2)
			 '(face muse-emphasis-3))
    (add-text-properties (match-beginning 3)
			 (match-end 3)
			 '(face d-muse-sub-sections)))

  (while (re-search-forward d-muse-tag-1 end t)
    ;; (unless (thing-at-point 'word)
    ;;   (d-test))
    (add-text-properties (match-beginning 1)
			 (match-end 1)
			 '(face muse-emphasis-3)))

  (while (re-search-forward "\\(\\(^[A-z .?-_]+\\)-+>$\\)" end t)
    (add-text-properties (match-beginning 2)
			 (match-end 2)
			 '(face muse-emphasis-1)))


 ;; 위의 highlighting은 앞의 @@를 highlighting 하지 않는다.
 ;;  (while (re-search-forward "^\\(@+\\).+" end t)
 ;;    (let* ((string (match-string 1))
 ;; 	   (len (d-string-count string)))
 ;;      (add-text-properties (+ (match-beginning 0) len)
 ;; 			   (match-end 0)
 ;; 			   '(face d-muse-sub-sections))))
  )


(add-hook 'muse-mode-hook
            (lambda () (add-to-list 'muse-colors-buffer-hook
                  'd-muse-highlighting t)))

;; test1 --> failed
;; (add-hook 'muse-colors-buffer-hook 'd-muse-highlighting)


;; test2 --> failed
;;(add-to-list 'muse-colors-buffer-hook
;;	     'd-muse-highlighting t)



;;; === Change underline color
;;; --------------------------------------------------------------
;; Just redefine the face 'underline'.
;; Muse uses the function muse-colors-underlined.

(defun d-muse-colors-underlined-2 ()
  "Reimplementation of muse-colors-underlined"
  (let ((start (match-beginning 0))
        multiline)
    (unless (or (eq (get-text-property start 'invisible) 'muse)
                (get-text-property start 'muse-comment)
                (get-text-property start 'muse-directive))
      ;; beginning of line or space or symbol
      (when (or (= start (point-min))
                (eq (char-syntax (char-before start)) ?\ )
                (memq (char-before start)
                      '(?\- ?\[ ?\< ?\( ?\' ?\` ?\" ?\n)))
        (save-excursion
          (skip-chars-forward "^_<>\n" muse-colors-region-end)
          (when (eq (char-after) ?\n)
            (setq multiline t)
            (skip-chars-forward "^_<>" muse-colors-region-end))
          ;; Abort if space exists just before end
          ;; or no '_' at end
          ;; or word constituent follows
          (unless (or (eq (char-syntax (char-before (point))) ?\ )
                      (not (eq (char-after (point)) ?_))
                      (and (not (eobp))
                           (eq (char-syntax (char-after (1+ (point)))) ?w)))
            (add-text-properties start (1+ start) '(invisible muse))
            (add-text-properties (1+ start) (point) '(face d-muse-colors-underlined-2-face))
            (add-text-properties (point)
                                 (min (1+ (point)) (point-max))
                                 '(invisible muse))
            (when multiline
              (add-text-properties
               start (min (1+ (point)) (point-max))
               '(font-lock-multiline t)))))))))


(defun muse-colors-reference ()
  (add-text-properties (match-beginning 1) (match-end 0) '(face muse-reference-face)))

(defun muse-colors-faq ()
  (add-text-properties (match-beginning 1) (match-end 0) '(face muse-faq-face)))



;;; === Projects
;;; --------------------------------------------------------------
(require 'muse-project)

(setq planner-project "Plans")

(setq muse-project-alist
	  '(
	    ("Plans"
	     ;; Where your Planner pages are located
	     ("/home/ptmono/plans/"
	      ;; Use value of 'planner-default-page'
	      :default "TaskPool" 
	      :major-mode planner-mode 
	      :visit-link planner-visit-link)
	     ;; This next part is for specifying where Planner pages
	     ;; should be published and what Muse publishing style to
	     ;; use.  In this example, we will use the XHTML publishing
	     ;; style.
	     (:base "planner-xhtml" 
		    ;; The value of 'planner-publishing-directory
		    :path "/home/ptmono/public_html/plans/"))

	    ;; ("articles"
	    ;;  ("/home/ptmono/articles/" :default "index")
	    ;;  (:base "html" :path "/home/ptmono/public_html/articles/"))
	    
	    ;; ("works"
	    ;;  ("/home/ptmono/works/" :default "index")
	    ;;  (:base "html" :path "/home/ptmono/public_html/works/"))
	    
	    ;; ("notes"
	    ;;  ("/home/ptmono/notes/" :defaut "index")
	    ;;  (:base "html" :path "/home/ptmono/public_html/notes/"))
	    
	    ;; ("Emacs"
	    ;;  ("/home/ptmono/notes/emacs/" :defaut "index")
	    ;;  (:base "html" :path "/home/ptmono/public_html/emacs/"))


	    ;; ("publish"
	    ;;  ("/home/ptmono/notes/emacs/" :defaut "index")
	    ;;  (:base "html" :path "/home/ptmono/public_html/emacs/"))
      
	    ;; ("Faqs"
	    ;;  ("/home/ptmono/Desktop/Documents/faq/"
	    ;;   :major-mode muse-mode)
	    ;;  (:base "html" 
	    ;; 	     :path "/home/ptmono/public_html/faq/"))

	    ;; ("Note"
	    ;;  ("/home/ptmono/Desktop/Documents/notes/"
	    ;;   :major-mode muse-mode)
	    ;;  (:base "html" 
	    ;; 	     :path "/home/ptmono/public_html/notes/"))

	    ("Project"
	     ("/home/ptmono/Desktop/Documents/projects/"
	      :major-mode muse-mode)
	     (:base "html" 
		     :path "/home/ptmono/public_html/notes/"))

	    ;; IKMPa is for a system of reference

	    ("IKMPa"
	     ("/home/ptmono/Desktop/Documents/projects/IKMPa/")
	     (:base "html" 
		     :path "/home/ptmono/public_html/projects/IKMPworking/"))

	    ; create new homepage
	    ("IKMPd"
	     ("/home/ptmono/Desktop/Documents/projects/IKMPd/")
	     (:base "html" 
		     :path "/home/ptmono/public_html/projects/IKMPd/"))

	    ("linux-backup"
	     ("/home/ptmono/Desktop/Documents/projects/linux-backup/")
	     (:base "html" 
		     :path "/home/ptmono/public_html/projects/linux-backup/"))


	    ("life-loadmap"
	     ("/home/ptmono/Desktop/Documents/projects/life-loadmap/")
	     (:base "html" 
		     :path "/home/ptmono/public_html/projects/life-loadmap/"))


	    ("Poffice"
	     ("/home/ptmono/Desktop/Documents/projects/Poffice/")
	     (:base "html" 
		     :path "/home/ptmono/public_html/projects/Poffice/"))

	    ;; To include the work directory into the search path
	    ;; ("IKworks"
	    ;;  ("/home/ptmono/Desktop/Documents/works/")
	    ;;  (:base "html" 
	    ;; 	     :path "/home/ptmono/public_html/works/"))

	    ("IKnotes"
	     ("/home/ptmono/Desktop/Documents/notes/")
	     (:base "html" 
		     :path "/home/ptmono/public_html/works/"))

	    ("IKpublish"
	     ("/home/ptmono/Desktop/Documents/publish/")
	     (:base "html" 
		     :path "/home/ptmono/public_html/works/"))

	    ("IKworknotes"
	     ("/home/ptmono/Desktop/Documents/worknotes/")
	     (:base "html" 
		     :path "/home/ptmono/public_html/works/"))

	    ;; ("IKworks"
	    ;;  ("/home/ptmono/Desktop/Documents/works/")
	    ;;  (:base "html" 
	    ;; 	     :path "/home/ptmono/public_html/works/"))
	    
	    

	    ))

	    ;; ("Worknotes"
	    ;;  ("/home/ptmono/Desktop/Documents/worknotes/"
	    ;;   :major-mode muse-mode)
	    ;;  (:base "html" 
	    ;; 	    :path "/home/ptmono/public_html/worknotes/"))))


;; To update image by muse-project-publish (2006.09.14#4) #0612051244
(defadvice muse-project-publish (before d-muse-project-publish-befor-hook)
  "to copy image by muse-project-publish"
  (setq d-muse-project-publish-buffer-list-before (buffer-list))
  (shell-command-to-string "cp -u /home/ptmono/plans/*.jpg /home/ptmono/public_html/plans/")
  (shell-command-to-string "cp -u ~/Desktop/Documents/files/* ~/public_html/files/")
  (shell-command-to-string "cp -u ~/Desktop/Documents/imgs/* ~/public_html/imgs/")
  (shell-command-to-string "cp -u /home/ptmono/plans/*.css /home/ptmono/public_html/plans/")
  (shell-command-to-string "cp -u /home/ptmono/plans/*.el /home/ptmono/public_html/plans/")
  (muse-publish-file "/home/ptmono/projects/main.muse" "html" "/home/ptmono/public_html/projects/"))
  ;; (muse-project-publish "Note")
  ;; (muse-project-publish "Faq")
  ;; (muse-project-publish "Worknotes"))
  ;;(shell-command-to-string "find /home/ptmono/plans/ ! -regex '.*\.muse.*' ! -regex '.*~$' -type f ! -regex '.*DataSpace.*' ! -regex '.*\$.*\|^..#.*' -exec cp -u '{}' /home/ptmono/public_html/plans/ \;"))


(defadvice muse-project-publish (after d-muse-project-publish-after-hook)
  "
 *fix note
 #0612181918
 (planner-goto-today) saves all currenta buffer. This is the cause
 why muse-publish publishs agagin the files previously published files.
 Without the function 'planner-goto-today the function 'kill-buffer asks
 the confirmation. So it needs Function: set-buffer-modified-p flag"
  (save-window-excursion
    (let* ((current (buffer-list))
	   (currenta current))
      (dolist (pre d-muse-project-publish-buffer-list-before currenta)
	(setq currenta (delq pre currenta)))
      ;; (planner-goto-today)
      ;; (set-buffer-modified-p nil) ;set changed buffer to unchanged buffer
      ;; (save-buffer)
      (dolist (del currenta)
	(switch-to-buffer del)
	(set-buffer-modified-p nil)
	(kill-buffer del)))))
(ad-activate 'muse-project-publish)


;;; === Etc
;;; --------------------------------------------------------------
;; To use w3m-browse-url as default in muse
;; Moved to config-custom.el. See that.
;; (setq browse-url-browser-function 'w3m-browse-url)


;; To use S-return to open an http link on other window
(defun d-open-link-other-window ()
  "To open http links to other window. it supports 2, 3 windows
on screen only http link, otherwise executed by
'muse-follow-name-at-point-other-window' that is original muse
<S-return> function"
  (interactive)
  (let* ((link (muse-link-at-point)))
    (if (string-match "http:" link)
	(progn (when (eq 2 (length (window-list)))
		 (save-selected-window
		   (progn (select-window (next-window))
			  (w3m-browse-url link t))))
			  ;; why I used w3m-view-this-url to open url?
			  ;; (w3m-view-this-url-1 link t t))))
	       (when (eq 3 (length (window-list)))
		 (save-selected-window
		   (progn (other-window 2)
			  (w3m-browse-url link t)))))
			  ;; (w3m-view-this-url-1 link t t )))))
      (muse-follow-name-at-point-other-window))))

(defadvice muse-browse-result (after d-muse-browse-result)
"To open php file with emacs-w3m for muse-browse-result"
(let* ((name (buffer-file-name)))
  (when (and (string-match ".*php$" name) (string-match "\\(/home/ptmono/public_html/\\)\\(.*\\)" name))
    (let ((file-name (match-string 2 name))
	  (url-name "http://localhost/~ptmono/"))
      (kill-buffer (current-buffer))
      (w3m-browse-url (concat url-name file-name) t)))))
(ad-activate 'muse-browse-result)


(defun d-muse-gimp-current-line()
  "To edit image in muse-mode."
  (interactive)
  (let* (filename)
    (setq filename (concat d-home "/imgs/"
			   (replace-regexp-in-string "]]\n"
						     ""
						     (file-name-nondirectory (thing-at-point 'line))
						     )))
    ;; DONE: to be asynchronous.
    (start-process "gimp" "*gimp*" "gimp" filename)))


(defun d-muse-gimp-resize()
  "To resize image in muse-mode."
  (interactive)
  (let* ((size (read-string "Size: " "500"))
	 filename)
    (setq filename 
	  (concat d-home "/imgs/"
		  (replace-regexp-in-string "]]\n"
					    ""
					    (file-name-nondirectory (thing-at-point 'line))
					    )))
    (start-process "cp" "*convert*" "cp" filename d-muse-gimp-backup-filename)
    (start-process "convert" "*convert*" "convert" filename "-resize" size filename)
))

(defun d-muse-gimp-restore()
  "To restore the resized image in muse-mode."
  (interactive)
  (let* (filename)
    (setq filename 
	  (concat d-home "/imgs/"
		  (replace-regexp-in-string "]]\n"
					    ""
					    (file-name-nondirectory (thing-at-point 'line))
					    )))
    (start-process "cp" "*convert*" "cp" d-muse-gimp-backup-filename filename)
))



;;; === Problems
;;; --------------------------------------------------------------

;;; Conflict with color-theme.
;; See worknote#0706012141
(defun muse-replace-regexp-in-string (regexp replacement text &optional fixedcase literal)
  "Replace REGEXP with REPLACEMENT in TEXT.

Return a new string containing the replacements.

If fourth arg FIXEDCASE is non-nil, do not alter case of replacement text.
If fifth arg LITERAL is non-nil, insert REPLACEMENT literally."
  (cond
   ;; ((fboundp 'replace-in-string)
   ;;  (replace-in-string text regexp replacement literal))
   ((fboundp 'replace-regexp-in-string)
    (replace-regexp-in-string regexp replacement text fixedcase literal))
   (t (let ((repl-len (length replacement))
            start)
        (unless (string= regexp "")
          (save-match-data
            (while (setq start (string-match regexp text start))
              (setq start (+ start repl-len)
                    text (replace-match replacement fixedcase literal
                                        text))))))
      text)))


;;; In muse C-c tab has problem with hangle
(defun muse-insert-thing ()
  "Prompt for something to insert into the current buffer."
  (interactive)
  (let* (methodp)
    (when current-input-method
      (toggle-korean-input-method)
      (setq methodp t))
    (message "Insert:\nl  link\nt  Muse tag\nu  URL")
    (let (key cmd)
      (let ((overriding-local-map muse-insert-map))
	(setq key (read-key-sequence nil)))
      (if (commandp (setq cmd (lookup-key muse-insert-map key)))
	  (progn (message "")
		 (call-interactively cmd))
	(message "Not inserting anything")))
    (when methodp
      (toggle-korean-input-method))))


