#lang racket/base

(require racket/match
         rackunit)

(define (solution1 s)
  (for/fold ([x 0]) ([c s])
    (match c [#\( (add1 x)] [#\) (sub1 x)])))

(check-equal? (solution1 "()()") 0)
(check-equal? (solution1 "(())") 0)
(check-equal? (solution1 "(((") 3)
(check-equal? (solution1 "(()(()(") 3)
(check-equal? (solution1 "))(((((") 3)
(check-equal? (solution1 "())") -1)
(check-equal? (solution1 "))(") -1)
(check-equal? (solution1 ")))") -3)
(check-equal? (solution1 ")())())") -3)

#;
(solution1 (call-with-input-file "01-input.txt" read-line))

(define (solution2 s)
  (let/ec return
    (for/fold ([x 0]) ([c s] [i (in-naturals 1)])
      (let ([x (match c [#\( (add1 x)] [#\) (sub1 x)])])
        (when (< x 0) (return i))
        x))))

(check-equal? (solution2 ")") 1)
(check-equal? (solution2 "()())") 5)

(solution2 (call-with-input-file "01-input.txt" read-line))