
;;; === Search with w3m
;;; ------------------------------------------------------------

;;; todo

;; - 1202170222 sound problem
;; - CANCEL make word search program with python.


;;; logs
;;
;; 0704181829 : added d-w3m-waiting and d-search-move-to-word
;;
;; "naverDic", "dict.org" searchs contains some lines from first line. The lines
;; are menu and logo. I don't need these lines. When I use "naverDic" on a small
;; frame, "naverDic" only shows me the logos and menus of naver. So I need to hold 'M-v'.
;;
;; A problem to solve that problem is the delay time of w3m-goto-url to completry
;; open url. The function d-w3m-waiting is my solution. If you need some
;; actions with a url, use the function d-w3m-waiting.
;;
;; You can add alist to d-search-url-alist. 3th element is one of nil, string,
;; number.  If nil, d-search does not any action. If string and number,
;; d-search calls d-search-move-to-word.
;;
;; 0805050041
;;  - added d-search-dic-sound for the sound of word.
;;
;; 1202170216
;;  - naver changes the url. It is fixed.
;;  - some change



(defvar d-search-dic-naver
  "http://eedic.naver.com/small.naver?where=keyword&query="
  "Used for d-search-dic-sound")

(defvar d-search-url-alist
  '(("naver" "http://search.naver.com/search.naver?where=nexearch&query=%s&frm=t1&sm=top_hty" "found")
    ("naverDic" "http://dic.naver.com/search.naver?where=dic&sm=tab_jum&query=%s" "지식백과 검색")
    ("dict.org" "http://www.dict.org/bin/Dict?Form=Dict2&Database=*&Query=%s" nil)
    ("googleDefine" "http://www.google.com/search?num=50&q=define:%s&btnG=Search")
    ("google" "http://www.google.com/search?num=50&q=%s&btnG=Search")
    ("googleGroup" "http://groups.google.com/groups?num=100&q=%s&btnG=Search")
    ("googleBlog" "http://blogsearch.google.com/blogsearch?num=100&q=%s&btnG=Search")
    ("del.icio.us" "http://del.icio.us/search/?fr=del_icio_us&p=%s&type=all")
    ("kodersPython" "http://www.koders.com/default.aspx?s=%s&btn=Search&la=Python")
    ("googlePythonGroup" "http://groups.google.com/group/comp.lang.python/search?group=comp.lang.python&q=%s&qt_g=Search+this+group&num=50&qt_s=Search+Groups")
    ("googleCodeSearch" "http://www.google.com/codesearch?q=%s&hl=en&btnG=Search+Code&num=100")
    ("php" "http://www.php.net/manual-lookup.php?pattern=%s")
    ; %3d is equal =.
    ("amazon" "http://www.amazon.com/s/ref=nb_ss?url=search-alias=stripbooks&field-keywords=%s&x=16&y=20")
    ("msdn" "http://social.msdn.microsoft.com/Search/en-us?query=%s")
    ("pinvoke" "http://pinvoke.net/search.aspx?search=%s&namespace=[All]")
    )
    "3th of list is one of that nil, string, number. It specify
    view point that is the top position of buffer.")

(defvar d-search-last-buffer nil)

(defun d-search (site)
  "Use this function with keybinding.el. We can use
d-search-url-alist as SITE."
  (interactive)
  (let* ((word (read-string (concat "Search word(" site "): "))) ; (current-word)))
	 (search-url (nth 1 (assoc site d-search-url-alist)))
	 (move-point (nth 2 (assoc site d-search-url-alist))))
    (setq d-search-last-buffer (current-window-configuration))
    (if (= (length (window-list)) 2)
	(progn
	  (other-window 1)

	  ;; The reason to check w3m buffer exists is that if the window
	  ;; of other frame have w3m buffer the function w3m-browse-url
	  ;; opens url to that frame so I need swith to that buffer.

	  ;; 0907260229 This problem is cleared. There is *w3m*<2>,
	  ;; *w3m*<3>. If we kill *w3m*<2>, then emacs change the buffer
	  ;; name of *w3m*<3> to *w3m*<2>. So we don't need
	  ;; d-search-check-w3m-exist any more.
	  (w3m-browse-url (format search-url word) t))
      (w3m-browse-url (format search-url word) t))
    (d-w3m-waiting)
    (if move-point
	(d-search-move-to-word move-point))
    ))

(defun d-search-check-w3m-exist ()
  "check w3m buffer exists. if buffer is exists then switch to
that buffer"
  (let* ((w3mp (member (or "*w3m*" "*w3m*<1>*")
		       (mapcar (function buffer-name) (buffer-list)))))
    (if w3mp
	(switch-to-buffer (car w3mp)))))

(defun d-search-move-to-word (move-point)
  "Move to the point I want to see. It is specified in
d-search-url-alist. MOVE-POINT can be integer or regexp."
  (if (integerp move-point)
      (goto-char move-point)
    (goto-char (re-search-forward move-point)))
  (recenter 1))

;; Fixme
(defun d-search-dic-sound (&optional word)
  "You can hear the english word. The function modified from
\[\[http://kldp.org/node/85648][Command-line English Dictionary (Naver)\]\]"
  (interactive)
  (save-window-excursion
    (let* ((url w3m-current-url)
	   (word-in-page (progn (string-match "query=\\([A-z]+\\)$" url) (match-string 1 url))))
      (shell-command
       (concat "w3m -dump_source \""
	       d-search-dic-naver
	       (if word-in-page
		   word-in-page
		 (read-string "word: "))
	       "\" | grep showproun | sed \"s/[^']*'\\([^']*\\)'.*$/\\1/\" | xargs mplayer") "aaaa"))))

(provide 'd-search)

