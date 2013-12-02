;;; === Init
;;; --------------------------------------------------------------
(setq gnus-select-method
      '(nntp "news.kornet.net"))

(setq gnus-secondary-select-methods
      '((nnml "")
	;(nntp "binnews.kornet.net")
	))
(setq gnus-post-method "native")


(setq gnus-treat-display-smileys t)
(setq gnus-summary-line-format "%U%R: %d: %-5,5B: %-80,80s: %a\n")
;(setq gnus-summary-line-format " %O%U%R | %-50,50s | |%z%d| %B%20,20(%[%4L: %-22,22f%]%) \n")
;; ~/.newsrc.eld contains the group specified variable


(setq gnus-use-full-window nil)
(setq gnus-check-new-newsgroups nil)
(setq mail-sources '((file :path "/var/spool/mail/ptmono")))

;check new mails
(setq nnmbox-get-new-mail t)
(setq nnmh-get-new-mail t)
(setq nndraft-get-new-mail t)
(setq nnml-get-new-mail t)

(setq gnus-save-newsrc-file t)
(setq gnus-group-line-format "%5y %(%-70,70g%)\n")
(setq gnus-sum-thread-tree-single-indent "* ")
(setq gnus-sum-thread-tree-single-leaf "+-> ")


(setq gnus-extra-headers '(To Xyz))
(setq nnmmail-extra-headers gnus-extra-headers)
(add-hook 'gnus-group-mode-hook 'gnus-topic-mode)
(setq gnus-thread-sort-functions '(gnus-thread-sort-by-most-recent-date gnus-thread-sort-by-most-recent-number gnus-thread-sort-by-total-score))
(setq gnus-select-group-hook nil)


(setq gnus-treat-fill-long-lines t) ; Some the line of article over the line of
				    ; center. The effect of
				    ; gnus-treat-fill-long-lines seems like
				    ; auto-fill-mode.
(setq gnus-auto-select-next t)
(setq gnus-summary-check-current t)
(setq gnus-auto-center-summary t) ;! 
(setq gnus-thread-indent-level 1)
(add-hook 'gnus-summary-mode-hook 'gnus-summary-hide-all-threads)
(add-hook 'gnus-summary-mode-hook 'turn-on-gnus-mailing-list-mode)
(setq gnus-add-to-list t)
(setq gnus-topic-display-empty-topics t) ; defaultly we cannot see empty topic(?)


;;; === Group parameters
;;; --------------------------------------------------------------
(setq gnus-parameters
      '(("^nnrss.*"
	 (gnus-summary-line-format "%U%R: %d: %-5,5B: %-75,75s: %a\n")
	 )))


(defcustom gnus-visible-headers
  "^From:\\|^Newsgroups:\\|^Subject:\\|^Date:\\|^Followup-To:\\|^Reply-To:\\|^Organization:\\|^Summary:\\|^Keywords:\\|^To:\\|^[BGF]?Cc:\\|^Posted-To:\\|^Mail-Copies-To:\\|^Mail-Followup-To:\\|^Apparently-To:\\|^Gnus-Warning:\\|^Resent-From:\\|^X-RSS-URL:"
  "*All headers that do not match this regexp will be hidden.
This variable can also be a list of regexp of headers to remain visible.
If this variable is non-nil, `gnus-ignored-headers' will be ignored."
  :type '(choice
	  (repeat :value-to-internal (lambda (widget value)
				       (custom-split-regexp-maybe value))
		  :match (lambda (widget value)
			   (or (stringp value)
			       (widget-editable-list-match widget value)))
		  regexp)
	  (const :tag "Use gnus-ignored-headers" nil)
	  regexp)
  :group 'gnus-article-hiding)



;;; === BBDB
;;; --------------------------------------------------------------
;; TODO bbdb seems his functions are changed. Fix following functions.
(require 'bbdb-com) ;; so that bbdb-search will be defined for below

;; (defvar bbdb/gnus-folder-field 'gnus-folder
;;   "BBDB field that controls where Gnus splits its mail")

(defvar dal-gnus-nnrss-last-buffer nil)

;; (defun gnus-folder-per-bbdb ()
;;   "gnus fancy split function.
;;    If the sender is in bbdb, return folder from the bbdb attribute
;;    indicated by `bbdb/gnus-folder-field'"
;;   (let* ((who (bbdb-canonicalize-address
;;                (cadr (gnus-extract-address-components
;;                       (or (message-fetch-field "from")
;;                           (message-fetch-field "sender")
;;                           (message-fetch-field "reply-to"))))))
;;          (found (bbdb-search-simple nil who)))
;;     (and found (bbdb-record-getprop found bbdb/gnus-folder-field))))

;; (defun gnus-if-in-bbdb (target)
;;   "gnus fancy split function;
;;      if the senders address is in bbdb, return TARGET"
;;   (let ((who (bbdb-canonicalize-address
;;               (cadr (gnus-extract-address-components
;;                      (or (message-fetch-field "from")
;;                          (message-fetch-field "sender")
;;                          (message-fetch-field "reply-to")
;;                          "nobody@nowhere.nohow"))))))
;;     (when (bbdb-search-simple nil who)
;;       target)))


;;; === Inline images
;;; --------------------------------------------------------------
;; See worknote#0705052337

(setq mm-attachment-override-types '("image/.*"))

(setq mm-text-html-renderer 'w3m)
(setq mm-inline-text-html-with-images t) ; shows images inline in article buffer
;(setq mm-inline-text-html-with-w3m-keymap nil) ; if you don't need emacs-w3m key in article buffer,
(setq mm-w3m-safe-url-regexp nil)

; in summary buffer, you can toggle displaying of images


;(defun gnus-summary-w3m-safe-toggle-inline-images (&optional arg)
;  "Toggle displaying of all images in the article buffer.
;       If the prefix arg is given, all images are considered to be safe."
;  (interactive "P")
;  (save-excursion
;;    (set-buffer gnus-article-buffer)
;    (switch-to-buffer gnus-article-buffer)
;    (w3m-safe-toggle-inline-images arg)))
;(eval-after-load "gnus-sum"
;  '(define-key gnus-summary-mode-map
;     "\C-i" 'gnus-summary-w3m-safe-toggle-inline-images))
;

;====================================
;; don't like html or richtext
;(when (boundp 'mm-automatic-display)
;  (setq mm-discouraged-alternatives '("text/html" "text/richtext")
;	mm-automatic-display (remove "text/html" mm-automatic-display)))



;;(setq gnus-refer-article-method
;;      '(current (nnweb "refer" (nnweb-type google))))

;; 20030627: Changed kill mark to just -1
;; I find adaptive scoring very useful for keeping killed (boring)
;; threads out of sight. I do have some keyword scoring rules that
;; can bring some threads back up, though.

(setq gnus-use-adaptive-scoring t)
(setq gnus-default-adaptive-score-alist
      '((gnus-unread-mark)
	(gnus-ticked-mark (subject 5))
	(gnus-dormant-mark (subject 5))
	(gnus-del-mark (subject -1))
;	(gnus-read-mark (subject 1))
	(gnus-killed-mark (subject -1))
	(gnus-catchup-mark (subject -1))))
(setq gnus-gcc-mark-as-read t)	
(setq nnmail-cache-accepted-message-ids t)

(when (boundp 'message-syntax-checks)
  (add-to-list 'message-syntax-checks '(sender . disabled)))
;; Set split method to nnmail-split-fancy
(setq nnmail-split-methods 'nnmail-split-fancy)
(setq nnmail-crosspost nil)

;; To split non-ascii characters
;; See gnus.muse#1306210445
(setq nnmail-mail-splitting-decodes t)
(setq nnmail-mail-splitting-charset 'utf-8)

;; Notice match string is regular express.
(setq nnmail-split-fancy
      '(|
	;; (:spam-split)
	(:nnmail-split-fancy-with-parent)
	("Subject" "Cron <ptmono@localhost> /usr/bin/fetchmail -s" "nnfolder:expired")

	;; spams
	("from" "11st@ems.11st.co.kr" "mail.spam_regular")
	("from" "mail@netmarble.co.kr" "mail.spam_regular")


	;; Google Alert, which for google blog
	(any "googlealerts-noreply@google.com"
	     (| ("subject" "python-mode" "gAlert.pythonMode")
		("subject" "milw0rm" "gAlert.security")
		"etc"))
	;; (any "kss@kldp.org" "mail.kldp.reply") ;KLDP any more support mail reply
	(any "no-reply@diigo.com"
	     (| (any "Tools for web developers" "mail.webTools")
		(any "Blogging and Social-Media Group" "mail.social")
		"mail.diigo"))
	;; newsgroups
	(any "tex-live@tug.org" "list.texlive")
	(any "texlive@tug.org" "list.texlive") 
	(any "fedora-list@redhat.com" "list.fedora")
	(any "planner-el-discuss@gna.org" "list.emacs.planner")
	(any "muse-el-discuss@gna.org" "list.emacs.muse")
	(any "bug-bash@gnu.org" "list.bash.bug")
	(any "emacs-diffs@gnu.org" "list.emacs.diffs")
	(any "emacs-wiki-discuss" "list.emacs.wiki")
	(any "users-bounces@lists.fedoraproject.org" "list.fedora")
	(any "help-gnu-emacs@gnu.org" "list.emacs.help")
	(any "gnu-emacs-help@gnu.org" "list.emacs.help")
	(any "info-gnu-emacs@gnu.org" "list.emacs.digest")

	;; Job mailing
	("from" "alert@indeed.com" "job_mailling")
	("from" "webmaster@mailinfo.saramin.co.kr" "job_mailling")
	("from" "certificatematching@mailinfo.saramin.co.kr" "job_mailling")
	("from" "specialtymatching@mailinfo.saramin.co.kr" "job_mailling")
	("from" "personalmatching@mailinfo.saramin.co.kr" "job_mailling")
	("from" "openrecruitmatching@saramin.co.kr" "job_mailling")
	("from" "openrecruitmatching@mailinfo.saramin.co.kr" "job_mailling")

	;; Quora
	(any "noreply@quora.com"
	     (|
	      ("subject" ".*Algorithms.*" "mail.quora.algorithms")
	      ("subject" ".*Books.*" "mail.quora.books")
	      ("subject" ".*Artificial Intelligence.*" "mail.quora.ai")
	      ("subject" ".*Technology.*" "mail.quora.tech")
	      ("subject" ".*Cloud Computing.*" "mail.quora.cloud")
	      ("subject" ".*Fine Art.*" "mail.quora.fineart")
	      ("subject" ".*R (software).*" "mail.quora.r")
	      ("subject" ".*Science.*" "mail.quora.science")
	      ("subject" ".*Education.*" "mail.quora.education")
	      ("subject" ".*The Universe.*" "mail.quora.universe")
	      ("subject" ".*Classification.*" "mail.quora.classification")
	      ("subject" ".*Natural Language Processing.*" "mail.quora.nlp")
	      ("subject" ".*Data.*" "mail.quora.data")
	      ("subject" ".*Apache Hadoop.*" "mail.quora.data")
	      ("subject" ".*Book.*" "mail.quora.book")
	      ("subject" ".*Statistics.*" "mail.quora.statistics")
	      ("subject" ".*Physics.*" "mail.quora.physics")
	      ("subject" ".*Computer Vision.*" "mail.quora.vision")
	      ("subject" ".*Mathematics.*" "mail.quora.math")
	      "mail.quora.etc"))

	(any "topixalerts.com" "mail.topix")
	(any "nltk-users@googlegroups.com" "mail.googlegroups.nltk")
	
	
	(any "service@youtube.com" "mail.youtube")
	(any "noreply@youtube.com" "mail.youtube")
	(any "noreply@facebookmail.com" "mail.facebook")
	(any "redhat@myseminar.co.kr" "mail.advert")
	(any "movie@torrent.info" "mail.movie")
	(any "chickensoup@partner.beliefnet.com" "mail.english.chicken")
	(any "teachingenglish@lists.bbc.co.uk" "mail.english.bbc")
	(any "learningenglish@lists.bbc.co.uk" "mail.english.bbc")
	(any "englishlearner@yahoogroups.com" "mail.english.bbc")
	(any "learningenglish@bbcle.bsysmail.com" "mail.english.bbc")
	(any "teachingenglish@britishcouncil.org" "mail.english.bbubbu")

	(any "helpdesk@bmail.ebs.co.kr" "mail.english.ebs")
	(any "chanjai@gmail.com" "mail.english.ebs") ; 뿌와쨔쨔의 영어이야기

	(any "3Pf-RSxEKBhoDEH4FBO+5443FHENO6EE6B4.2ECFJCEDE6C08B.2EC@feedburner.bounces.google.com" "mail.english.bbubbu")


	(any "forum@linuxquestions.org" "list.linuxquestions")
	(any "push@work.go.kr" "job.work.go.kr")
	(any "push@keis.or.kr" "job.work.go.kr")

	(any "listserv@ugu.com" "mail.unixTip")
	(any "automailer@dyndns.com" "mail.dynDNS")
	(any "mailzine@dongascience.com" "mail.regularETC")
	(any "returnmail@kyobobook.co.kr" "mail.regularETC")
	(any "webmaster@lge.com" "mail.regularETC")
	(any "news@japantoday.com" "mail.regularETC")
	(any "how@dongascience.com" "mail.regularETC")
	;; lecture
	;; (any "admin@fedoraforum.org" "mail.fedora.howto")
	(any "fedoraforum.org@googlemail.com" "mail.fedora.howto")
	(any "spellcheck-ko@googlegroups.com" "mail.spellcheck-ko")
	(any "sysadminstudy@googlegroups.com" "mail.googlegroups.sysadminstudy")

	;; Fetch
	(any "YtnBreaking@torrent.info"
	     
	     (|
	      ;; issues
	      ("subject" ".*\\(icij\\|뉴스타파\\|국정원\\|안철수\\|공인인증\\|박람회\\|김학의\\).*" "news.issues")
	      ("subject" ".*\\(전두환\\|몰아주기\\|국정원\\|코스피\\|환율\\|원세훈\\|김영란\\).*" "news.issues")
	      ("subject" "사기" "news.issues")
	      ("subject" "취업" "news.issues")
	      ("subject" "민주당" "news.issues")
	      ("subject" "이정희" "news.issues")
	      ("subject" "스노든" "news.issues")
	      ("subject" "증시" "news.issues")

	      ;; minor_issues
	      ("subject" ".*\\(박근혜\\|NLL\\|아시아나\\|활주로\\|샌프란시스코\\|탑승객\\|777\\|김정은\\).*" "mail.news.ytnBreaking.minor")
	      ("subject" "한수원" "mail.news.ytnBreaking.minor_issues")
	      ("subject" "인도" "mail.news.ytnBreaking.minor_issues")
	      ("subject" ".*버냉키.*" "mail.news.ytnBreaking.minor_issues")

	      ;; minor
	      ("subject" "불황" "mail.news.ytnBreaking.minor")

	      ;; accident
	      ("subject" ".*\\(낙뢰\\).*" "mail.news.ytnBreaking.accident")

	      ;; Wether
	      ("subject" "날씨" "mail.news.ytnBreaking.weather")
	      ("subject" "\\(내일도\\|내일\\|오늘도\\)" "mail.news.ytnBreaking.weather")
	      ("subject" ".*\\(폭염\\|찜통더위\\|더워\\|무더위\\).*" "mail.news.ytnBreaking.weather")
	      ("subject" ".*\\(장맛\\|장마철\\|소나기\\|장마\\).*" "mail.news.ytnBreaking.weather")
	      ("subject" ".*\\(호후주의보\\|호후특보\\).*" "mail.news.ytnBreaking.weather")

	      ;; policy
	      ("subject" ".*\\(개성공단\\|외무부\\|김한길\\|민주당\\|새누리당\\).*" "mail.news.ytnBreaking.policy")

	      ;; entertainment
	      ("subject" ".*\\(송혜교\\|이병현\\|전지현\\).*" "mail.news.ytnBreaking.entertainment")
	      ("subject" ".*\\(박스오피스\\|이병현\\|전지현\\).*" "mail.news.ytnBreaking.entertainment")
	      ("subject" "공항패션" "mail.news.ytnBreaking.entertainment")

	      
	      ;; sports
	      ("subject" ".*\\(골프\\|윔블던\\|역전승\\|연승\\|우승\\|준우승\\).*" "mail.news.ytnBreaking.minor")
	      ("subject" "넥센" "mail.news.ytnBreaking.sports")
	      ("subject" "\\(호투\\|리그\\)" "mail.news.ytnBreaking.sports")
	      ("subject" ".*\\(추신수\\|이승엽\\|류현진\\|홍명보\\|박인비\\|박세리\\|손연재\\).*" "mail.news.ytnBreaking.sports")
	      ("subject" ".*\\(구자철\\|기성룡\\|축구연맹\\|LPGA\\).*" "mail.news.ytnBreaking.sports")
	      "mail.news.ytnBreaking"))
	
	(any "IutopiaMovie@torrent.info" "mail.movie")
	(any "NaverPopularNewsWorld@torrent.info" "mail.news.np_world")
	(any "NaverPopularNewsPolitics@torrent.info" "mail.news.np_politics")
	(any "ParkozImage@torrent.info" "mail.news.parkozImage")
	(any "TorrentRg@torrent.info" "mail.movie")

	(any "n-cgzbab=tznvy.pbz-66b60@postmaster.twitter.com" "mail.news.twitter")
	(any "active questions tagged python" "mail.stackoverflow.python")
	(any "active_questions_tagged_python" "mail.stackoverflow.python")
	(any "active_questions_tagged_niltk" "mail.stackoverflow.nltk")
	(any "active questions tagged nltk" "mail.stackoverflow.nltk")
	(any "Mathematics - Stack Exchange" "mail.stackexchange.math")
	(any "Mathematics_Stack_Exchange" "mail.stackexchange.math")
	(any "Mathematics Stack Exchange" "mail.stackexchange.math")
	(any "Physics Stack Exchange" "mail.stackexchange.physics")
	(any "Physics_Stack_Exchange" "mail.stackexchange.physics")
	(any "commandlinefu" "mail.commandlinefu")
	("from" "All commands" "mail.commandlinefu")

	(any "IT eBooks" "torrent.ebooks")

	;; Job
	(any "webmaster@saramin.co.kr" "job.saramin")
	(any "saramin@saramin.co.kr" "job.saramin")
	(any "48saramin@saramin.co.kr" "job.saramin")


	;; etc
	(any "gnome-kr@googlegroups.com" "mail.gnome-kr")
	(any "qdjango@googlegroups.com" "mail.googlegroups.qdjango")

	(any "biztalk@daou.co.kr" "mail.spam_regular")

	(any "askbot@python.kr" "mail.python.kr")
	(any "likelink" "mail.likelink")
	(any "hanitv" "mail.hanitv")

	;; For program error log
	(any "error_log@localhost" "mail.system.error")
	(any "ptmono@localhost"
	     (| ("from" "ohohoh@localhost" "mail.torrent")
		"etc"))

	;; advertisments
	(any "mail@global.netmarble.com" "mail.advertising")
	(any "noreturnmail@kyobobook.co.kr" "mail.advertising")
	(any "imnotice@imory.co.kr" "mail.advertising")
	(any "training-kr@redhat.com" "mail.advertising")
	(any "admin@11st.co.kr" "mail.advertising")

	(any "noreply-6ad87ed6@plus.google.com" "mail.googleplus")

	"etc"))


;; Lots of things I can twiddle depending on how much I feel
;; like pretending other people observe netiquette. =)
(setq gnus-treat-fill-article nil)
(setq gnus-treat-fill-long-lines nil)
(setq gnus-treat-capitalize-sentences nil)
(setq gnus-treat-date-local 'head)
(setq gnus-treat-hide-headers 'head)
(setq gnus-treat-hide-boring-headers 'head)
(setq gnus-treat-date-english t)

(setq gnus-boring-article-headers '(empty followup-to reply-to to-address date long-to many-to))

;; I browse by thread, so I tend to remember thread context; if I need
;; more info, I can just unhide cited text.
;; To see citation is more useful.0702121604
; (setq gnus-treat-hide-citation )

(add-hook 'nnmail-prepare-incoming-header-hook
          'nnmail-remove-list-identifiers)
(setq nnmail-list-identifiers '("[.*] "))
(setq gnus-list-identifiers '("\\[.*\\] "))

(setq nnslashdot-threshold 4)
(setq nnslashdot-threaded nil)

(setq gnus-always-read-dribble-file t)



(setq gnus-article-banner-alist
	'((yahoogroup . "^\\(_+\nDo You Yahoo\\|.*Yahoo\! Groups Sponsor\\)\\(.*\n\\)+")))


;; to open the url with w3m directry from the summary buffer, Use RET key.
(require 'gnus-dired) 
(add-hook 'dired-mode-hook 'turn-on-gnus-dired-mode)
(setq gnus-summary-display-while-building t)
(setq gnus-gcc-mark-as-read t)



(require 'nnrss)

(add-to-list 'nnmail-extra-headers nnrss-description-field)

(defvar d-gnus/browse-with-webkit-list
  '("nnml:mail.news.parkozImage"
    "nnml:mail.stackoverflow.python"
    "nnml:mail.movie"
    )
  "To browse the link with webkit. Add the name. You can get the
  name with the variable gnus-newsgroup-name in the summary
  buffer." )

(defcustom d-gnus-browser-headers
  '("X-RSS-URL"
    "X-Gnus-Url"
    )
  "If the article has these headers, then the value opened with
  webkit."
  :group 'd-gnus)


(defun browse-nnrss-url(arg)
  (interactive "p")
  (setq dal-gnus-nnrss-last-buffer (current-window-configuration))
  ;; (let ((url (assq nnrss-url-field
  ;;                  (mail-header-extra
  ;;                   (gnus-data-header
  ;;                    (assq (gnus-summary-article-number)
  ;;                          gnus-newsgroup-data))))))
  (let* ((url-headers d-gnus-browser-headers)
	 (article-headers (d-gnus-headers-get))
	 header value url)
    (while url-headers
      (setq header (car url-headers))
      (setq value (d-gnus-headers-get-value header article-headers))
      (if value
	  (progn (setq url value)
		 (setq url-headers nil)))
      (setq url-headers (cdr url-headers)))
		
    ;; to here get url
    (if url
	(let* ((cbuffer (selected-window))
	       (url-type (if (string-match-p "^mms" url)
			     "mms"
			   "http"))
	       cmd)
	  (gnus-summary-mark-as-read nil "R")
	  ;(forward-line 1)
	  ;; gnus-summary-mark-as-read function only mark function

	  (when (equal url-type "http")
	    (select-window (next-window))
	    (if (or current-prefix-arg
		    (member gnus-newsgroup-name d-gnus/browse-with-webkit-list))
		(progn
		  (select-window (previous-window))
		  (setq cmd (concat "python3.3 ~/works/11torrent_merge/tools/webkit.py \"" url "\""))
					;(shell-command cmd))))
		  (start-process-shell-command "webkit" nil cmd))

	      (progn
		;(delete-window)
		(select-window cbuffer)
		(browse-url url))))
	  
		;(w3m-browse-url (cdr url)))))

	  (when (equal url-type "mms")
	    (start-process "mplayer" "*mplayer*" "mplayer" "-xy" "2" url)
	    (d-libs/detect-end-process-and-kill-buffer "mplayer" "*mplayer*" 20)
	    )))))


(defun d-gnus-headers-get ()
  "In summary buffer, the function returns the article's header
data as alist."
  (let* ((filename (nnml-article-to-file (gnus-summary-article-number)))
	 header-alist header content)
    (with-temp-buffer
      (insert-file-contents filename)
      (goto-char (point-min))
      (while (re-search-forward "\\(^[A-z-]+\\): \\(.*\\)" nil t)
	(setq header (match-string 1))
	(setq content (match-string 2))
	(push (cons header content) header-alist)
	))
    header-alist
  ))

(defun d-gnus-headers-get-value (header headers)
  "Get current articles's value of HEADER in HEADERS."
  (let* ((content (assoc header headers))
	 result)
    (if content
	(cdr content)))
  )


(defun d-gnus-find-article ()
  "Find-file current article"
  (interactive)
  (let* ((filename (nnml-article-to-file (gnus-summary-article-number))))
    (find-file filename)))



;; (gnus-summary-scroll-up arg)))))


(eval-after-load "gnus"
  '(define-key gnus-summary-mode-map
     [return] 'browse-nnrss-url))

;(eval-after-load "gnus"
;  #'(define-key gnus-summary-mode-map
;      [kp-return] 'browse-nnrss-url))
;      (kbd "<RET>") 'browse-nnrss-url))
;fixme This has error. Why?
;This part has been added to keybinding.el
;keybinding.el을 참고하면, return이 아니라 kp-return 인 것 같다


(defvar nnrss-url-xrss 'X-RSS-URL)

(add-to-list 'nnmail-extra-headers nnrss-url-field)
(add-to-list 'nnmail-extra-headers nnrss-url-xrss)




; Set the default value of `mm-discouraged-alternatives'.
;mm-discouraged-alternatives를 설정함으로서, "text/html"의 경우 html tag source를 그대로
;보여주었다. 아래의 image는 그림 link를 보여주는듯 하였다.
;(eval-after-load "gnus-sum"
;  '(add-to-list
;    'gnus-newsgroup-variables
;    '(mm-discouraged-alternatives
;      . '("text/html" "image/.*"))))
;


;;;how can i delete mail forever? 매일 삭제 정책
; mail은 읽던 안 읽던 nnmail-expiry-wait-function에 지정된 날짜가 지나면
;"nnfolder:Expired"로 이동하게 된다. 이 이동에서는 nnmail-fancy-expiry-targets 가
;이용된다. 그리고 이 메일들은 2일 후 영원히 삭제된다.


;;; === mail deletion policy
;;; --------------------------------------------------------------


;;; === Gnus faces
;;; --------------------------------------------------------------
;     ;; Create three face types.
;     (setq gnus-face-1 'bold)
;     (setq gnus-face-3 'italic)
;
;     ;; We want the article count to be in
;     ;; a bold and green face.  So we create
;     ;; a new face called `my-green-bold'.
;     (copy-face 'bold 'my-green-bold)
;
;     ;; copy-face를 이용하여 기존의 bold face를 이용하여 my-green-bold라는
;        새로운 face를 만들었다.
;
;     ;; Set the color.
;     (set-face-foreground 'my-green-bold "ForestGreen")
;     (setq gnus-face-2 'my-green-bold)
;

;(copy-face 'dired-flagged 'my)

;(setq gnus-face-1 'my)
;왜 이게 설정이 안될까..? 윽 %{게 text인데 %(에 적용해 버렸다.


;;; === Gnus auto fetching
;;; --------------------------------------------------------------
(defun gnus-demon-scan-mail-or-news-and-update-2 ()
"Scan for new mail, updating the *Group* buffer."              
  (let ((win (current-window-configuration)))                  
    (unwind-protect                                            
        (save-window-excursion                                 
          (save-excursion                                      
            (when (gnus-alive-p)                               
              (save-excursion                                  
                ;; (set-buffer gnus-group-buffer)
		(switch-to-buffer gnus-group-buffer)
                (gnus-activate-all-groups 2)))))            
      (set-window-configuration win))))                        


(defun gnus-demon-scan-mail-or-news-and-update ()
"Scan for new mail, updating the *Group* buffer."              
  (let ((win (current-window-configuration)))                  
    (unwind-protect                                            
        (save-window-excursion                                 
          (save-excursion                                      
            (when (gnus-alive-p)                               
              (save-excursion
		(switch-to-buffer gnus-group-buffer)
                ;; (set-buffer gnus-group-buffer)
                (gnus-group-get-new-news 3)))))            
      (set-window-configuration win))))                        

(defun gnus-demon-scan-all-update ()
  ""
  (let ((wind (current-window-configuration)))
    (unwind-protect
	(save-window-excursion
	  (save-excursion
	    (when (gnus-alive-p)
	      (save-excursion
		;; (set-buffer gnus-group-buffer)
		(switch-to-buffer gnus-group-buffer)
		(gnus-activate-all-groups gnus-level-subscribed)))))
      (set-window-configuration wind))))

(defun gnus-demon-scan-movie-and-news ()
  (let ((win (current-window-configuration)))
    (unwind-protect
        (save-window-excursion                                 
          (save-excursion                                      
            (when (gnus-alive-p)                               
	      (save-excursion
		(start-process "newAndMovie" "*newAndMovie*"
			       "python"
			       "/home/ptmono/works/0service/dScrapper/main.py")
		(start-process "stackoverPython" nil
			       "/usr/local/src/packages/rss2email-2.71/rss2email.py"
			       "/usr/local/src/packages/rss2email-2.71/feeds.dat"
			       "run")
		(set-window-configuration win))))))))

(gnus-demon-add-handler 'gnus-demon-scan-movie-and-news 60 20)
;(gnus-demon-add-handler 'gnus-demon-scan-mail-or-news-and-update-2 30 3)
(gnus-demon-add-handler 'gnus-demon-scan-mail-or-news-and-update-2 180 20)
;(gnus-demon-add-handler 'gnus-demon-scan-mail-or-news-and-update 500 30)
(gnus-demon-add-handler 'gnus-demon-scan-mail-or-news-and-update 120 30)
(gnus-demon-add-handler 'gnus-demon-scan-all-update 800 30)
;(gnus-demon-add-handler 'd-newsgroup-nfo 600 nil)
(gnus-demon-init)

;(add-hook 'gnus-before-startup-hook 'd-newsgroup-nfo)


;;; === Topics
;;; --------------------------------------------------------------
;; (setq gnus-topic-line-format "%v%y_%-60=%i[ %(%{%n%}%) -- %A ]%v----")
(setq gnus-topic-display-empty-topics nil)


;;; === Level
;;; --------------------------------------------------------------
(setq gnus-group-default-list-level 3) ; group에서 기본적으로 list 할 레벨
(setq gnus-activate-foreign-newsgroups nil) ;시작시 rss를 읽지 않는 설정


(setq gnus-activate-level 3) ; 시작시 읽어들일 레벨 higher than
(setq gnus-level-killed 9)
(setq gnus-level-zombie 8)
(setq gnus-level-unsubscribed 7) ; less than or equal
(setq gnus-level-subscribed 5) ; less than or equal


;;; === Archive
;;; --------------------------------------------------------------
;; (setq gnus-message-archive-method '(nnml "archive"
;; 					 (nnml-directory "~/Mail/archive")
;; 					 (nnml-active-file "~/Mail/archive/active")))

(setq gnus-message-archive-method 
      '(nnfolder "archive"
		 (nnfolder-directory   "~/Mail/archive")
		 (nnfolder-active-file "~/Mail/archive/active")
		 (nnfolder-get-new-mail t)
		 (nnfolder-inhibit-expiry t)))

(setq gnus-message-archive-group
      '(
	;; ("^alt" "sent-to-alt")
	;; ("mail" "sent-to-mail")
	;; (".*" "sent-to-misc")
	(if (message-news-p)
	    "sent-to-news"
	  "sent-to-mail")))

;; send message archive를 위해서는 두가지 변수의 설정이 필요하다. 

;;  - gnus-message-archive-method
;;  - gnus-message-archive-group

;; 전자만 설정하고 후자를 설정하지 않는다면, 당신이 메세지를 보냈을때 gnus는
;; 보낸 메세지를 어디에 저장할 지를 모른다. 즉 저장하지 않았다. 후자를 설정하고
;; 나서야 gnus는 메세지를 보내고 설정된 곳으로 메세지를 저장하였다.


;;; === message
;;; --------------------------------------------------------------
;(setq user-mail-address "ptmono@gmail.com") ; moved to auth.el
(setq message-default-headers "Reply-To: dalsoo <ptmono@gmail.com>")


;(setq gnus-posting-styles
;      '((".*"
;         (name "Sacha Chua")
;	 (address "sacha@free.net.ph")
;	 (signature-file "~/.signature"))
;        ;; I used to send text messages from Gnus. I haven't figured
;        ;; out how to do that with my Microsoft Smartphone yet, but
;        ;; I'll leave this in here just in case
;	("mail.text"
;	 (signature nil)
;         (signature-file nil))
;        (".*compsat.*"
;         (signature "Sacha Chua\nGeekette, CompSAt¤\nCompSAt¤ www.compsat.org")
;         (organization "CompSAt")
;         (reply-to "sacha@compsat.org")
;         (address "sacha@compsat.org"))))
;


;;; === Smtp
;;; --------------------------------------------------------------
;; to send the mail with smtp.naver.com
;;
;; See auth.el



;;; kill-new the location gnus-summary-copy-article

;뉴스나 rss를 읽으면서 필요한 내용의 부분은 B C(gnus-summary-copy-article)을
;이용하여 nnml:NAME 으로 저장을 한다. 저장된 내용은 ~/Mail/NAME/NUMBER 로
;저장된다.
;
;이 때 이 문서를 muse-mode 혹은 planner-mode에 cite 하려면 nnml:NAME를 찾아서
;cite 해 주어야 한다. 이 부분을 간소화 하기 위하여 B C 를 실행시키면,
;~/Mail/NAME/NUMBER가 kill-new가 되게 끔 하려고 한다.
;
;B C의 핵심함수는 gnus-summary-move-article 이다. 문서의 헤더에 문서의 번호가
;주어진다. Xref: localhost list.emacs.muse:1233
;
;gnus-summary-move-article 에서 문서의 이동을 관장하는 부분은 "Copy the
;article"로 코멘트 돼어있다. gnus-request-article-this-buffer 를 이용하여 문서를
;임시 버퍼로 이동시킨다. 이 버퍼를 저장하는 역활을 하는 것이
;gnus-request-accept-article 로 보인다. 이 함수는 ("muse" . 28) 같은 값을
;리턴한다. 리턴값은 nnml:NAME 의 NAME 와 만들어진 문서의 번호이다.

;훅을 적용하면 어떨까 생각했었는데 주어진 훅(gnus-summary-article-move-hook)은
;일을 다 끝내고 나서 적용되어, 크게 효용이 없었다.

;gnus-request-accept-article에 함수를 추가하는 것으로 한다.
;

(defvar d-gnus-mail-dir "/home/ptmono/Mail/")

(defun gnus-request-accept-article (group &optional gnus-command-method last
					  no-encode)
  ;; Make sure there's a newline at the end of the article.
  (when (stringp gnus-command-method)
    (setq gnus-command-method (gnus-server-to-method gnus-command-method)))
  (when (and (not gnus-command-method)
	     (stringp group))
    (setq gnus-command-method (or (gnus-find-method-for-group group)
                                  (gnus-group-name-to-method group))))
  (goto-char (point-max))
  (unless (bolp)
    (insert "\n"))
  (unless no-encode
    (let ((message-options message-options))
      (message-options-set-recipient)
      (save-restriction
	(message-narrow-to-head)
	(let ((mail-parse-charset message-default-charset))
	  (mail-encode-encoded-word-buffer)))
      (message-encode-message-body)))
  (let ((gnus-command-method (or gnus-command-method
				 (gnus-find-method-for-group group)))
	(result
	 (funcall
	  (gnus-get-function gnus-command-method 'request-accept-article)
	  (if (stringp group) (gnus-group-real-name group) group)
	  (cadr gnus-command-method)
	  last)))
    ;;;; This line is added. by dal
    (kill-new (concat d-gnus-mail-dir (car result) "/" (number-to-string (cdr result))))
    (when (and gnus-agent (gnus-agent-method-p gnus-command-method))
      (gnus-agent-regenerate-group group (list (cdr result))))
    result
    ))




;; quit without confirm.
(defun d-gnus-group-exit ()
  "Quit reading news after updating .newsrc.eld and .newsrc.
The hook `gnus-exit-gnus-hook' is called before actually exiting."
  (interactive)
  (let* ((gnus-expert-user t))
    (when
	(or noninteractive		;For gnus-batch-kill
	    (not gnus-interactive-exit)	;Without confirmation
	    gnus-expert-user 
	    (gnus-y-or-n-p "Are you sure you want to quit reading news? "))
      (gnus-run-hooks 'gnus-exit-gnus-hook)
      ;; Offer to save data from non-quitted summary buffers.
      (gnus-offer-save-summaries)
      ;; Save the newsrc file(s).
      (gnus-save-newsrc-file)
      ;; Kill-em-all.
      (gnus-close-backends)
      ;; Reset everything.
      (gnus-clear-system)
      ;; Allow the user to do things after cleaning up.
      (gnus-run-hooks 'gnus-after-exiting-gnus-hook))))


;;; === Atom feeds
;;; --------------------------------------------------------------
;; from [[http://www.emacswiki.org/emacs/GnusRss][EmacsWiki: Gnus Rss]]

;; This wouldn't work for me. I cann't find the reason. I couldn't
;; understand why just execute xsltproc with atom2rss.xsl.

;; Instead this I consider rss2email to read RSS.

;; (require 'mm-url)
;; (defadvice mm-url-insert (after DE-convert-atom-to-rss () )
;;   "Converts atom to RSS by calling xsltproc."
;;   (when (re-search-forward "xmlns=\"http://www.w3.org/.*/Atom\"" 
;;                            nil t)
;;     (goto-char (point-min))
;;     (message "Converting Atom to RSS... ")
;;     (call-process-region (point-min) (point-max) 
;;                          "xsltproc" 
;;                          t t nil 
;;                          (expand-file-name "~/atom2rss.xsl") "-")
;;     (goto-char (point-min))
;;     (message "Converting Atom to RSS... done")))

;; (ad-activate 'mm-url-insert)

;;; rss2email
;; See [[worknote2.muse#1301042040]]
;; $ ./r2e email ptmono@localhost

;; # add feed
;; $ ./r2e add http://stackoverflow.com/feeds/tag?tagnames=python&sort=newest
;; $ ./r2e add http://newsrss.bbc.co.uk/rss/newsonline_world_edition/front_page/rss.xml

;; # Fetch. It is not daemon.
;; $ ./r2e run




;See auth.el
