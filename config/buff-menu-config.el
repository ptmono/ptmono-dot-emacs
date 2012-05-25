(require 'buff-menu+)

;; Sort for mode
(setq Buffer-menu-sort-column 5)


;; Change the colors
(set-face-attribute 'buffer-menu-star-buffer nil
		    :foreground "DimGrey")

(set-face-attribute 'Buffer-menu-buffer nil
		    :foreground "grey")

(set-face-attribute 'buffer-menu-file-name nil
		    :foreground "grey")

;; (set-face-attribute 'buffer-menu-directory-buffer nil
;; 		    :foreground "white"
;; 		    :background "black"
;; 		    :bold t)
