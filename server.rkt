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
   [("set" (integer-arg) (string-arg)) set-hex-handler]
   [else (lambda (req) (response/xexpr "unknown command"))]))

(define ok-response (response/xexpr "ok"))
(define error-response (response/xexpr "error"))

;; semi-predicates for validation

(define (percent-values->rgb r g b)
  (if (and (and (>= r 0) (<= r 1))
	   (and (>= g 0) (<= g 1))
	   (and (>= b 0) (<= b 1)))
      (make-rgb r g b)
      #f))

(define (strip-id->strip id)
  (if (and (>= id 0) (< id (length strips)))
      (list-ref strips id)
      #f))

(define (hex-code->rgb code)
  (let ([hex->int (lambda (str start end)
		    (string->number (substring str start end) 16))]
	[mk-rgb (lambda (r g b max)
		  (make-rgb (/ r max) (/ g max) (/ b max)))])
    (cond [(regexp-match #px"^#[A-Fa-f0-9]{6}$" code)
	   (let ([r-int (hex->int code 1 3)]
		 [g-int (hex->int code 3 5)]
		 [b-int (hex->int code 5 7)])
	     (mk-rgb r-int g-int b-int 255))]
	  [(regexp-match #px"^#[A-Fa-f0-9]{3}$" code)
	   (let ([r-int (hex->int code 1 2)]
		 [g-int (hex->int code 2 3)]
		 [b-int (hex->int code 3 4)])
	     (mk-rgb r-int g-int b-int 15))]
	  [else #f])))

;; handlers

(define (set-perc-handler req strip-id r g b)
  (let ([strip (strip-id->strip strip-id)]
	[color (percent-values->rgb r g b)])
    (set/respond strip color)))

(define (set-hex-handler req strip-id hex-code)
  (let ([strip (strip-id->strip strip-id)]
	[color (hex-code->rgb hex-code)])
    (set/respond strip color)))

(define (set/respond strip color)
  (cond [(and strip color) (set-color strip color)
	 ok-response]
	 [else error-response]))

;; servlet

(serve/servlet my-dispatch
               #:launch-browser? #f
               #:quit? #f
               #:listen-ip #f
               #:port 80
               #:servlet-path ""
	       #:servlet-regexp #rx"")
