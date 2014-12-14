#lang racket

(require "c-interface.rkt")

(void (wiringPiSetup))

(void (pinMode 11 OUTPUT))

(define (cycle)
  (void (digitalWrite 11 HIGH))
  (sleep 60))

(define (loop f)
  (f)
  (loop f))

(loop cycle)
