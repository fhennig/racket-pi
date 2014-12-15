#lang racket

(require "c-interface.rkt")

(define CYCLE-LENGTH 100)

(define-struct rgb (r g b))

(define WHITE (make-rgb 1 1 1))
(define BLACK (make-rgb 0 0 0))
(define RED (make-rgb 1 0 0))
(define YELLOW (make-rgb 1 1 0))
(define GREEN (make-rgb 0 1 0))
(define BLUE (make-rgb 0 0 1))
(define PURPLE (make-rgb 1 0 1))

(define-struct strip (r-pin g-pin b-pin))

(define (make-strip/init r-pin g-pin b-pin)
  (softPwmCreate r-pin 0 CYCLE-LENGTH)
  (softPwmCreate g-pin 0 CYCLE-LENGTH)
  (softPwmCreate b-pin 0 CYCLE-LENGTH)
  (make-strip r-pin g-pin b-pin))

(define s1 (make-strip/init 6 10 11))
(define s2 (make-strip/init 0 2 3))
(define s3 (make-strip/init 8 9 7))
(define s4 (make-strip/init 12 13 14))

(define (set-color strip rgb)
  (let ([int-val (lambda (frac)
		   (inexact->exact (floor (* frac CYCLE-LENGTH))))])
    (softPwmWrite (strip-r-pin strip) (int-val (rgb-r rgb)))
    (softPwmWrite (strip-g-pin strip) (int-val (rgb-g rgb)))
    (softPwmWrite (strip-b-pin strip) (int-val (rgb-b rgb)))))

(void (wiringPiSetup))

(set-color s1 WHITE)
(set-color s2 WHITE)
(set-color s3 WHITE)
(set-color s4 WHITE)
