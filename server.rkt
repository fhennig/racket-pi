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
   [("set" (integer-arg) (number-arg) (number-arg) (number-arg)) set-handler]
   [else error-handler]))

(define (strip-id-valid? s)
  (and (>= s 0) (< s (length strips))))

(define (color-arg-valid? a)
  (and (>= a 0) (<= a 1)))

(define (set-handler req strip-id r g b)
  (let ([strip-val? (lambda (s) (and (>= s 0) (< s (length strips))))]
	[color-val? (lambda (a) (and (>= a 0) (<= a 1)))])
    (cond [(and (strip-val? strip-id) (color-val? r)
		(color-val? g) (color-val? b))
	   (set-color (list-ref strips strip-id)
		      (make-rgb r g b))
	   (response/xexpr "ok")]
	  [else (error-handler 'nothing)])))

(define (error-handler req)
  (response/xexpr "error"))

(serve/servlet my-dispatch
               #:launch-browser? #f
               #:quit? #f
               #:listen-ip #f
               #:port 80
               #:servlet-path ""
	       #:servlet-regexp #rx"")
