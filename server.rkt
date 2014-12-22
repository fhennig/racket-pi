#lang racket

(require "led.rkt")
(require web-server/dispatch
	 web-server/servlet
	 web-server/servlet-env)
(provide/contract (my-dispatch (request? . -> . response?)))

;; mapping pins to strips
(define leds
  (list (led "oben rechts" 15 16 1)
	(led "unten rechts" 0 2 3)  
	(led "oben links" 8 9 7)  
	(led "unten links" 12 13 14)))

(define-values (my-dispatch my-url)
  (dispatch-rules
   [("set" (integer-arg) (number-arg) (number-arg) (number-arg)) set-perc-handler]
   [else (lambda (req) error-response)]))

(define ok-response (response/xexpr "ok"))
(define error-response (response/xexpr "error"))

;; semi-predicates for validation

(define (strip-id->strip-setter id)
  (cond [(and (>= id 0) (< id (length leds)))
	 (curry set-led-color! (list-ref leds id))]
	[(< id 0) (lambda (color)
		    (map (curryr set-led-color! color) leds))]
	[else #f]))

;; handlers

(define (set-perc-handler req strip-id r g b)
  (let ([strip-setter (strip-id->strip-setter strip-id)]
	[color (valid-color r g b)])
    (set/respond strip-setter color)))

(define (set/respond strip-setter color)
  (cond [(and strip-setter color) (strip-setter color)
	 ok-response]
	 [else error-response]))



;; Starting the application

(initialize leds)

(serve/servlet my-dispatch
               #:launch-browser? #f
               #:quit? #f
               #:listen-ip #f
               #:port 80
               #:servlet-path ""
	       #:servlet-regexp #rx"")
