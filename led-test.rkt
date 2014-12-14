#lang racket

(require "c-interface.rkt")

(void (wiringPiSetup))

(void (pinMode 11 OUTPUT))

(define (cycle)
  (void (digitalWrite 11 HIGH))
  (sleep 0.5)
  (void (digitalWrite 11 LOW))
  (sleep 0.5))

(define (loop f)
  (f)
  (loop f))

(loop cycle)


