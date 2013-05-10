;; See emacsModes.muse#1109151422

;; This was installed by package-install.el. This provides support for the
;; package system and interfacing with ELPA, the package archive. Move
;; this code earlier if you want to reference packages in your .emacs.

(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))


;; Fixme: Support Windows.
;; (unless (d-windowp)
;;   (when
;;       (load
;;        (expand-file-name "~/.emacs.d/elpa/package.el"))
;;     (package-initialize)

;;     )
;;   )
(package-initialize)

(provide 'package-config)

