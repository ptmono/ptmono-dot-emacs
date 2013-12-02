(add-to-list 'load-path "/media/local/adt-bundle-linux-x86_64-20130729/sdk/tools/lib/")
(require 'android)

(add-to-list 'load-path "~/.emacs.d/cvs/android-mode/")
(require 'android-mode)
(setq android-mode-sdk-dir "/media/local/adt-bundle-linux-x86_64-20130729/")
(add-hook 'gud-mode-hook
	  (lambda ()
            (add-to-list 'gud-jdb-classpath "/media/local/adt-bundle-linux-x86_64-20130729/sdk/platforms/android-8/android.jar")
            ))


(setenv "ANDROID_SDK" "/media/local/adt-bundle-linux-x86_64-20130729/sdk/")
(setenv "ANDROID_SDK" "/media/local/adt-bundle-linux-x86_64-20130729/sdk/platforms/android-18/android.jar")
