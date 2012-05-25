(require 'bbdb)
(bbdb-initialize)

(add-hook 'gnus-startup-hook 'bbdb-insinuate-gnus)

(add-to-list 'Info-default-directory-list "/usr/src/cvs/bbdb/texinfo/")
