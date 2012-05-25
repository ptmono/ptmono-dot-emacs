;------------------------------------------------------------
;; 이부분은 fixed familly에서 굵은 글씨가 설정되지 않아서 bold를 위한 설정이다.
;------------------------------------------------------------

;(custom-set-faces
  ;; custom-set-faces was added by Custom -- don't edit or cut/paste it!
  ;; Your init file should contain only one such instance.
; '(muse-emphasis-1 ((t (:inherit italic :slant italic))))
; '(muse-emphasis-2 ((t (:inherit variable-pitch :weight bold))))
; '(muse-emphasis-3 ((t (:inherit variable-pitch :slant italic :weight bold))))
; '(muse-header-2 ((t (:inherit variable-pitch :weight bold :height 1.3))))
; '(muse-header-5 ((t (:inherit variable-pitch :weight bold :height 1.1)))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["ligth-gray" "red" "green" "yellow" "blue" "magenta" "cyan" "white"])
 '(appt-audible t)
 '(appt-delete-window-function (quote appt-delete-window))
 '(appt-disp-window-function (quote d-appt-disp-window))
 '(appt-display-duration 15)
 '(appt-display-format (quote window))
 '(appt-display-interval 5)
 '(appt-issue-message t)
 '(auto-hscroll-mode t)
 '(blink-cursor-delay 0.5)
 '(blink-cursor-interval 0.5)
 '(blink-cursor-mode nil)
 '(canlock-password "02c0553afbfc512dac72bdfcf89d90efdc7f1298")
 '(case-fold-search t)
 '(d-etags-directory-list (quote ("/home/ptmono/.emacs.d/" "/usr/share/emacs/" "/usr/src/packages/remember/" "/usr/src/cvs/mmm-mode/" "/usr/src/cvs/planner/" "/usr/src/cvs/muse/lisp/" "/usr/src/cvs/gnus/lisp/" "/usr/src/cvs/emacs-w3m/")) t)
 '(dired-listing-switches "-ahl")
 '(display-hourglass t)
 '(erc-hide-list (quote ("JOIN" "NICK" "PART" "QUIT" "MODE")))
 '(find-file-hook (quote (d-file-open global-font-lock-mode-check-buffers vc-find-file-hook)))
 '(find-ls-option (quote ("-exec ls -lhd {} \\;" . "-lhd")))
 '(gnus-group-mode-hook (quote (gnus-agent-mode gnus-topic-mode highlight-current-line-minor-mode)))
 '(gnus-load-hook nil)
 '(gnus-summary-exit-hook (quote (gnus-summary-bubble-group)))
 '(gnus-summary-mode-hook (quote (gnus-agent-mode turn-on-gnus-mailing-list-mode gnus-summary-hide-all-threads highlight-current-line-minor-mode)))
 '(gnus-topic-indent-level 4)
 '(gnus-topic-line-format "%v%y_%-55=%i[ %(%{%n%}%) -- %A ]%l%v----
")
 '(grep-command "grep -nHE -e ")
 '(grep-find-command "find . -path '*/.svn' -prune -o -path '*/CVS' -prune -o -path '*/.git' -prune -o ! -name '*~' -type f -print0 | xargs -0 -e grep -nHE -e ")
 '(grep-find-template "find . <X> -type f <F> -print0 | xargs -0 -e grep <C> -nHE -e <R>")
 '(grep-template "grep <C> -nHE -e <R> <F>")
 '(mm-inline-text-html-with-w3m-keymap t)
 '(mm-w3m-safe-url-regexp nil)
 '(planner-renumber-tasks-automatically nil)
 '(planner-use-day-pages nil)
 '(ps-font-size (quote (7 . 10)))
 '(ps-paper-type (quote a4))
 '(ps-print-footer-frame nil)
 '(ps-print-header-frame nil)
 '(remember-mode-hook nil)
 '(safe-local-variable-values (quote ((Mode . C) (sgml-omittag) (sgml-shorttag . t) (sgml-general-insert-case . lower))))
 '(w3m-antenna-sites (quote (("http://www.python.org/ftp/python/doc/2.5/" "Index of /ftp/python/doc/2.5" nil) ("http://www.emacswiki.org/cgi-bin/wiki/DeliciousEl" "EmacsWiki: DeliciousEl" nil))))
 '(w3m-content-type-alist (quote (("application/x-bittorrent" "\\.torrent\\'" nil "text/plain") ("text/plain" "\\.\\(?:txt\\|tex\\|el\\)\\'" nil nil) ("text/html" "\\.s?html?\\'" browse-url-default-browser nil) ("text/sgml" "\\.sgml?\\'" nil "text/plain") ("text/xml" "\\.xml\\'" nil "text/plain") ("image/jpeg" "\\.jpe?g\\'" ("/usr/bin/display" file) nil) ("image/png" "\\.png\\'" ("/usr/bin/display" file) nil) ("image/gif" "\\.gif\\'" ("/usr/bin/display" file) nil) ("image/tiff" "\\.tif?f\\'" ("/usr/bin/display" file) nil) ("image/x-xwd" "\\.xwd\\'" ("/usr/bin/display" file) nil) ("image/x-xbm" "\\.xbm\\'" ("/usr/bin/display" file) nil) ("image/x-xpm" "\\.xpm\\'" ("/usr/bin/display" file) nil) ("image/x-bmp" "\\.bmp\\'" ("/usr/bin/display" file) nil) ("video/mpeg" "\\.mpe?g\\'" nil nil) ("video/quicktime" "\\.mov\\'" nil nil) ("application/dvi" "\\.dvi\\'" ("xdvi" file) nil) ("application/postscript" "\\.e?ps\\'" ("gv" file) nil) ("application/pdf" "\\.pdf\\'" ("xpdf" file) nil) ("application/xml" "\\.xml\\'" nil w3m-detect-xml-type) ("application/rdf+xml" "\\.rdf\\'" nil "text/plain") ("application/rss+xml" "\\.rss\\'" nil "text/plain") ("application/xhtml+xml" nil nil "text/html"))))
 '(w3m-default-coding-system (quote utf-8)))



(setq scroll-step 1) ; see http://kldp.org/node/86954
; (setq muse-publish-contents-depth 3)
(setq auto-hscroll-mode t) ; auto horizontal scrolling to cursor
(toggle-menu-bar-mode-from-frame)
; (toggle-tool-bar-mode-from-frame)  ;for tool bar

;;; for two space end
(setq sentence-end-double-space nil)

(global-font-lock-mode t)

;(setq default-case-fold-search t)
;is an obsolete variable; use case-fold-search
(setq case-fold-search t)

;(setq sentence-end-double-space nil)

;(setq debug-on-error t)
(setq default-fill-column 74) ;I like 80
;is an obsolete variable(as of Emacs 23.2); use 'fill-column insted. But it
;fails to set fill-column
(setq fill-column 74)


(setq undo-limit 50000)

;; You can use the browser to open url. The valiable
;; browse-url-browser-function has the list of browsers which used in
;; browse-url.el.
;; Muse also use the value.
(setq browse-url-browser-function 'w3m-browse-url)


(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)

;;; === For info file
;;; --------------------------------------------------------------
;; note that the name contains default. If you use Info-directory-list, it
;; has problem that Info-directory-list replace
;; Info-default-derectory-list.

(add-to-list 'Info-default-directory-list "~/.emacs.d/info/")
(setq Info-directory-list (append Info-default-directory-list Info-directory-list))


;;; === For colorful ls in the shell-mode
;;; --------------------------------------------------------------
(ansi-color-for-comint-mode-on)


;;; === calendar
;;; --------------------------------------------------------------
(setq calendar-date-display-form
      '(year "-" month "-" day (if dayname (concat ", " dayname))))
;(setq mark-holidays-in-calendar t)
;is an obsolete variable(as of Emacs 23.1); use 'calendar-mark-holidays-flag' instead
(setq calendar-mark-holidays-flag t)
;(setq mark-diary-entries-in-calendar t)
;is an obsolete variable (as of Eamcs 23.1); use 'calendar-mark-diary-entries-flag' instead
(setq calendar-mark-diary-entries-flag t)
(add-hook 'diary-display-hook 'fancy-diary-display)

;(setq general-holidays
;is an obsolete variable (as of Eamcs 23.1); use 'holiday-general-holidays' instead
(setq holiday-general-holidays
      '((holiday-fixed 1 1 "설날")
        (holiday-fixed 3 1 "삼일절")
        (holiday-fixed 4 5 "식목일")
        (holiday-fixed 5 5 "어린이날")
        ;;(holiday-fixed 5 8 "어버이날")
        ;;(holiday-fixed 5 15 "스승의날")
        (holiday-fixed 6 6 "현충일")
        (holiday-fixed 7 17 "제헌절")
        (holiday-fixed 8 15 "광복절")
        ;;(holiday-fixed 10 1 "국군의 날")
        (holiday-fixed 10 3 "개천절")
        ;;(holiday-fixed 10 9 "한글날")
        (holiday-fixed 12 25 "성탄절")))


;;; === For pasting from other app to emacs
;;; --------------------------------------------------------------
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))


;;; === No emacs start-up message
;;; --------------------------------------------------------------
(setq inhibit-startup-message t) 


;;; === For /home/ptmono/.TAGS
;;; --------------------------------------------------------------
(add-hook 'emacs-lisp-mode-hook 
          '(lambda ()
             (let ((tagfile "/home/ptmono/TAGS"))
               (and (file-readable-p tagfile)
                    (visit-tags-table "/home/ptmono/TAGS")))))


(setq max-lisp-eval-depth 1000)
(setq max-specpdl-size 1000)


;;; === For the position of help buffer
;;; --------------------------------------------------------------
;; The default value is 80. The value is changed in version 23.1 of emacs.
;; 라인수가 변수값 보다 클 때에 도움말 페이지를 밑을 잘라 연다.

(setq split-height-threshold 100)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;;; === For double-space to one-space between sentences
;;; --------------------------------------------------------------
;(setq sentence-end-double-space nil)

;load el or ecl folder

;; to use outline mode, section scrolling
;(global-outline-minor-mode t) ;;이건 안되네..
;(setq-default outline-mode t)
;(autoload 'outline-mode' "outline-mode" "outline-mode" t)
;; to use highlighting by matching
;(global-hi-lock-mode t) ;;이것도 안돼네
;(setq-default hi-lock-mode t)


;(require 'cl)

(transient-mark-mode 1)
(defalias 'yes-or-no-p 'y-or-n-p)
(put 'set-goal-column 'disabled nil)
(put 'narrow-to-region 'disabled nil)
