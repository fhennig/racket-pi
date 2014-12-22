#lang racket

(require "led.rkt")
(require web-server/dispatch
	 web-server/servlet
	 web-server/servlet-env)
(provide/contract (my-dispatch (request? . -> . response?)))

;; mapping pins to strips
(define strips
  (list 
   (make-strip/init 15 16 1) ; 0
   (make-strip/init 0 2 3)   ; 1
   (make-strip/init 8 9 7)   ; 2
   (make-strip/init 12 13 14)))

(define-values (my-dispatch my-url)
  (dispatch-rules
   [("set" (integer-arg) (number-arg) (number-arg) (number-arg)) set-perc-handler]
   [else (lambda (req) error-response)]))

(define ok-response (response/xexpr "ok"))
(define error-response (response/xexpr "error"))

;; semi-predicates for validation

(define (percent-values->rgb r g b)
  (if (and (and (>= r 0) (<= r 1))
	   (and (>= g 0) (<= g 1))
	   (and (>= b 0) (<= b 1)))
      (make-rgb r g b)
      #f))

(define (strip-id->strip-setter id)
  (cond [(and (>= id 0) (< id (length strips)))
	 (curry set-color (list-ref strips id))]
	[(< id 0) (lambda (color)
		    (map (curryr set-color color) strips))]
	[else #f]))

;; handlers

(define (set-perc-handler req strip-id r g b)
  (let ([strip-setter (strip-id->strip-setter strip-id)]
	[color (percent-values->rgb r g b)])
    (set/respond strip-setter color)))

(define (set/respond strip-setter color)
  (cond [(and strip color) (strip-setter color)
	 ok-response]
	 [else error-response]))

(serve/servlet my-dispatch
               #:launch-browser? #f
               #:quit? #f
               #:listen-ip #f
               #:port 80
               #:servlet-path ""
	       #:servlet-regexp #rx"")
