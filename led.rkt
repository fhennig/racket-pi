#lang racket

(require "wiringPi-wrapper.rkt")
(provide (struct-out led)
	 (struct-out color)
	 valid-color
	 set-led-color!
	 led-color
	 initialize)



(define CYCLE-LENGTH 100)

; an rgb-color. 0 <= value <= 1
(struct color (r g b))

(define (valid-color r g b)
  (if (and (and (>= r 0) (<= r 1))
	   (and (>= g 0) (<= g 1))
	   (and (>= b 0) (<= b 1)))
      (color r g b)
      #f))


(struct led (name r-pin g-pin b-pin))

(define (init led [color (color 0 0 0)])
  (softPwmCreate (led-r-pin led) (color-r color) CYCLE-LENGTH)
  (softPwmCreate (led-g-pin led) (color-g color) CYCLE-LENGTH)
  (softPwmCreate (led-b-pin led) (color-b color) CYCLE-LENGTH)
  (hash-set! color-dict led color))

(define (initialize leds)
  (wiringPiSetup)
  (map init leds)
  (void))

(define color-dict (make-hash))

(define (led-color led)
  (hash-ref color-dict led))

(define (set-led-color! led color)
  (set-color (led-r-pin led)
	     (led-g-pin led)
	     (led-b-pin led) color)
  (hash-set! color-dict led color))

; sets color on the pins r g b
(define (set-color r g b color)
  (let ([int-val (lambda (frac)
		   (inexact->exact (floor (* frac CYCLE-LENGTH))))])
    (softPwmWrite r (int-val (color-r color)))
    (softPwmWrite g (int-val (color-g color)))
    (softPwmWrite b (int-val (color-b color)))))

;; Debug functions

(define (led->string led)
  (string-append "LED " (led-name led)))

(define (color->string c)
  (string-append "COLOR R=" (number->string (color-r c))
		 " G=" (number->string (color-g c))
		 " B=" (number->string (color-b c))))

(define led1 (led "LED1" 1 2 3))
(define led2 (led "LED2" 4 5 6))

(initialize (list led1 led2))

(set-led-color! led1 (color 1 1 1))
