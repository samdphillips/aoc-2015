#lang racket/base

(require racket/port
         rackunit)

(define (paper l w h)
  (define a (* l w))
  (define b (* l h))
  (define c (* w h))
  (define slack (min a b c))
  (+ (* 2 a) (* 2 b) (* 2 c) slack))

(check-equal? (paper 2 3 4) 58)
(check-equal? (paper 1 1 10) 43)

(define (parse-line line)
  (map string->number (regexp-split #px"x" line)))

(define ((solution f) in)
  (for/sum ([line (in-lines in)])
    (apply f (parse-line line))))

(check-equal? (call-with-input-string "2x3x4\n1x1x10"
                                      (solution paper))
              101)


(define (perimeter x y) (+ (* 2 x) (* 2 y)))

(define (ribbon l w h)
  (define d (min (perimeter l w)
                 (perimeter l h)
                 (perimeter w h)))
  (define slack (* l w h))
  (+ d slack))

(check-equal? (ribbon 2 3 4) 34)
(check-equal? (ribbon 1 1 10) 14)

(check-equal? (call-with-input-string "2x3x4\n1x1x10"
                                      (solution ribbon))
              48)