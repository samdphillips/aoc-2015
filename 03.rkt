#lang racket/base

(require racket/match
         racket/set)

(define (deliver1 next dir x y visited)
  (define-values (nx ny)
    (match dir
      [#\^ (values x (add1 y))]
      [#\< (values (sub1 x) y)]
      [#\> (values (add1 x) y)]
      [#\v (values x (sub1 y))]))
  (next nx ny (set-add visited (cons nx ny))))

(define (deliver* s)
  (define-values (x y visited)
    (for/fold ([x 0] [y 0] [visited (set (cons 0 0))]) ([c (in-string s)])
      (deliver1 values c x y visited)))
  visited)

(define (deliver s)
  (set-count (deliver* s)))

(deliver ">")
(deliver "^>v<")
(deliver "^v^v^v^v^v")

(deliver (call-with-input-file "03-input.txt" read-line))