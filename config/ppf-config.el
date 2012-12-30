(defvar d-ppf/el-directory
  (if (d-not-windowp)
      "~/Desktop/Documents/ppf/tools"
    nil))

(when d-ppf/el-directory
  (add-to-list 'load-path d-ppf/el-directory)
  (require 'ppf)
  )
