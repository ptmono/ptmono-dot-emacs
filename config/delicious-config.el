;; from REDAME
;;
;; The del.icio.us API does go through frequent changes; I've made an
;; effort here to structure the code so that these changes can be easily
;; accommodated.
;;
;; The specifications for the API are at <http://del.icio.us/doc/api>.

(require 'delicious)
(setq delicious-api-user "ptmono"
      delicious-api-password "securet")
(delicious-api-register-auth)

