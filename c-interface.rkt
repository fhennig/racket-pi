#lang racket

(require ffi/unsafe
         ffi/unsafe/define)

(provide (all-defined-out))

(define-ffi-definer define-wiringPi (ffi-lib "libwiringPi"))

(define-wiringPi wiringPiSetup (_fun -> _int))
(define-wiringPi wiringPiSetupGpio (_fun -> _int))
(define-wiringPi wiringPiSetupSys (_fun -> _int))

(define INPUT 0)
(define OUTPUT 1)

(define LOW 0)
(define HIGH 1)

(define-wiringPi pinMode (_fun _int _int -> _void))
(define-wiringPi digitalWrite (_fun _int _int -> _void))
(define-wiringPi digitalWriteByte (_fun _int -> _void))
(define-wiringPi pwmWrite (_fun _int -> _void))
(define-wiringPi digitalRead (_fun _int -> _int))
(define-wiringPi pullUpDnControl (_fun _int _int -> _void))

(define-wiringPi pwmSetMode (_fun _int -> _void))
(define-wiringPi pwmSetRange (_fun _uint -> _void))
(define-wiringPi pwmSetClock (_fun _int -> _void))

