;  0810110248
;;; purpose
;
; I decide to create a function d-w3m-ytn. YTN is a major news center. The
; function will has features.
;
; - list new news : d-w3m-ytn
; - directly open vod from list : d-w3m-ytn-vod-view
; - the next page of the list of news : d-w3m-ytn-next
;
; http://ytn.co.kr/news/news_quick.php provide the list of new news. There is
; vod and text in news. The line of vod includes an image icon.
;
; The link of news contains the information of address of vod. d-w3m-ytn-next
; build the address of vod of news.


;;; shortcut
;
; c-m will open the news. c-l will open next list of news.
; Use j, k to move the cursor.


;;; TODO
;
; - News has some category such as "정치", "사회", "경제". improve d-w3m-ytn to
;   list these category.
; - shortcut problem : clear 0810110348
;


;;; LOGS

;


(require 'd-library)

(defvar d-w3m-ytn-viewing-point-regexp "이시각"
  "If d-w3m-ytn opens ytn site, the screen shows from the line of
value re-searched")



(defvar d-w3m-ytn-mode-map
  (let ((map (make-sparse-keymap)))
    (set-keymap-parent map w3m-mode-map)
    (define-key map [?m] 'd-w3m-ytn-vod-view)
    (define-key map [?n] 'd-w3m-ytn-next)
    map)
  "Keymap used by d-w3m-ytn-mode")


(define-minor-mode d-w3m-ytn-minor-mode
  "To use d-w3m-ytn-mode-map"
  nil " Ytn-minor" d-w3m-ytn-mode-map
  :group 'ytn)


; the role of d-w3m-ytn is just to open ytn

(defun d-w3m-ytn ()
  "Open ytn-news"
  (interactive)
  (let* ((url "http://ytn.co.kr/news/news_quick.php?page=1")
	 (new-session (equal major-mode 'w3m-mode)))
    (d-window-separate)
    (other-window 1)
    (w3m-browse-url url new-session)
    (d-w3m-waiting)
    (re-search-forward d-w3m-ytn-viewing-point-regexp nil t)
    (recenter 1)

    (w3m-next-anchor)
    (d-w3m-ytn-minor-mode)))



(defun d-ytn ()
  (interactive)
  (d-w3m-ytn))


(defun d-w3m-ytn-vod-view ()
  (interactive)
  (let* ((link (w3m-anchor))
	 (line (thing-at-point 'line)))
    (if (string-match "ico_" line)

;; mplayer options
; -geometry 100%  places the window at the middle of the right edge of the screen
; -geometry 100%:100%  places the window at the bottom right corner of the screen
; -xy 2  For double size screen

; open mplayer opposite side
	(if (d-w3m-ytn-window-side-p)
	    (shell-command-to-string (concat "mplayer -xy 2 -geometry 100%:0% " (d-w3m-ytn-vod-url link)))
	  (shell-command-to-string (concat "mplayer -xy 2 -geometry 0%:0% " (d-w3m-ytn-vod-url link))))
      (w3m-view-this-url t t))))


(defun d-w3m-ytn-next ()
  (interactive)
  (let* ((base-url "http://ytn.co.kr/news/news_quick.php")
	 (page-url (if (equal major-mode 'w3m-mode)
		       w3m-current-url
		     nil))
	 (regexp "[0-9]+")
	 (cur-page-num (if (string-match regexp page-url)
			   (match-string 0 page-url)
			 0)))
    (if page-url
	(progn
	  (w3m-browse-url (concat base-url "?page=" (number-to-string (+ (string-to-number cur-page-num) 1))))
	  (d-w3m-waiting)
	  ;(re-search-forward d-w3m-ytn-viewing-point-regexp nil t)
	  (re-search-forward "^[^ ]" nil t)
	  (recenter 1))
      (error (message "d-w3m-ytn-next is used in w3m-mode")))))



(defun d-w3m-ytn-vod-url (link)
  "The url has the form
http://ytn.co.kr/_ln/0103_200810100124328815. The function will
parse 200810100124328815 and returns the link of vod
http://nvod2.ytn.co.kr/general/mov/2008/1010/200810100124328815_s.wmv

URL is the link of ytn.
"
  (let* ((base-url "http://nvod2.ytn.co.kr/general/mov/"))
    (if (string-match "_ln/\\([0-9]+\\)_\\(\\([0-9]\\{4\\}\\)\\([0-9]\\{4\\}\\)\\([0-9]+\\)\\)" link)
	(progn
	  (concat base-url (match-string 3 link) "/" (match-string 4 link) "/" (match-string 2 link) "_s.wmv"))
      (error "You has bad url."))))


(defun d-w3m-ytn-window-side-p ()
  "If current window is left-side window, then the function will
returns nil. Other is t"
  (let* ((cur-win (selected-window))
	 (left-win (if (listp (nth 0 (window-tree)))
		       (nth 2 (nth 0 (window-tree)))
		     nil)))
    (if (or (equal cur-win left-win) (equal nil left-win))
	t
      nil)))


(defun d-w3m-ytn/isVod ()
  )

