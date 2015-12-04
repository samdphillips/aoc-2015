#lang racket/base

(require racket/generator
         racket/match
         racket/set

         rackunit)

(define (deliver-once next dir x y visited)
  (define-values (nx ny)
    (match dir
      [#\^ (values x (add1 y))]
      [#\< (values (sub1 x) y)]
      [#\> (values (add1 x) y)]
      [#\v (values x (sub1 y))]))
  (next nx ny (set-add visited (cons nx ny))))

(define (deliver* s)
  (define-values (x y visited)
    (for/fold ([x 0] [y 0] [visited (set (cons 0 0))]) ([c s])
      (deliver-once values c x y visited)))
  visited)

(define (deliver1 [s #f])
  (set-count
   (deliver* (if s s (call-with-input-file "03-input.txt" read-line)))))

(check-equal? (deliver1 ">") 2)
(check-equal? (deliver1 "^>v<") 4)
(check-equal? (deliver1 "^v^v^v^v^v") 2)


(define (even-odd-sequence s odd?)
  (in-generator
   (for ([c (in-string s)] [v (in-cycle (list odd? (not odd?)))])
     (when v (yield c)))))

(define (deliver2 [s #f])
  (define p (if s s (call-with-input-file "03-input.txt" read-line)))
  (set-count
   (set-union
    (deliver* (even-odd-sequence p #t))
    (deliver* (even-odd-sequence p #f)))))

(check-equal? (deliver2 "^v") 3)
(check-equal? (deliver2 "^>v<") 3)
(check-equal? (deliver2 "^v^v^v^v^v") 11)
