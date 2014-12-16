#lang racket

(require "wiringPi-wrapper.rkt")
(provide (all-defined-out))

(define CYCLE-LENGTH 100)

; an rgb-color. 0 <= value <= 1
(define-struct rgb (r g b))

(define-struct strip (r-pin g-pin b-pin))

(define (make-strip/init r-pin g-pin b-pin)
  (softPwmCreate r-pin 0 CYCLE-LENGTH)
  (softPwmCreate g-pin 0 CYCLE-LENGTH)
  (softPwmCreate b-pin 0 CYCLE-LENGTH)
  (make-strip r-pin g-pin b-pin))

(define (set-color strip rgb)
  (let ([int-val (lambda (frac)
		   (inexact->exact (floor (* frac CYCLE-LENGTH))))])
    (softPwmWrite (strip-r-pin strip) (int-val (rgb-r rgb)))
    (softPwmWrite (strip-g-pin strip) (int-val (rgb-g rgb)))
    (softPwmWrite (strip-b-pin strip) (int-val (rgb-b rgb)))))

(void (wiringPiSetup))
