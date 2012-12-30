(add-to-list 'load-path "/usr/local/src/packages/android-sdk-linux_x86/tools/lib/")
(require 'android)

(add-to-list 'load-path "~/.emacs.d/cvs/android-mode/")
(require 'android-mode)
(setq android-mode-sdk-dir "/usr/local/src/packages/android-sdk-linux_x86/")
(add-hook 'gud-mode-hook
	  (lambda ()
            (add-to-list 'gud-jdb-classpath "/usr/local/src/packages/android-sdk-linux_x86/platforms/android-8/android.jar")
            ))


(setenv "ANDROID_SDK" "/usr/local/src/packages/android-sdk-linux_x86/")
(setenv "ANDROID_SDK" "/usr/local/src/packages/android-sdk-linux_x86/platforms/android-8/android.jar")
