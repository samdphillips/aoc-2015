#lang racket/base

(require racket/match
         racket/set
         rackunit)

;; check ::
;;  proc   : check Char -> (Option check)
;;  result : Boolean
(struct check [proc result] #:transparent)

;; checker : check ... -> String -> Boolean
(define ((checker . p*) s)
  (let/ec return
    (define checks
      (for/fold ([p* p*]) ([c (in-string s)])
        (for/list ([p (in-list p*)])
          (or (check-char p c) (return #f)))))
    (for/and ([p (in-list checks)]) (check-result p))))

;; check-char : check Char -> (Option check)
(define (check-char ch c)
  ((check-proc ch) ch c))

(define (check-double ch c1)
  (define (check-double2 ch c2)
    (if (char=? c1 c2)
        (check (lambda (ch c) ch) #t)
        (check-double ch c2)))
  (check check-double2 #f))


(define test-double (checker (check check-double #f)))
(check-false (test-double "test"))
(check-true (test-double "testt"))
(check-true (test-double "teestt"))
(check-true (test-double "teest"))
(check-false (test-double "x"))
(check-false (test-double "xy"))
(check-true (test-double "xx"))
(check-true (test-double "abcdde"))
(check-true (test-double "aabbccdd"))
(check-true (test-double "ugknbfddgicrmopn"))
(check-false (test-double "jchzalrnumimnmhp"))


(define vowels (set #\a #\e #\i #\o #\u))
(define (char-vowel? c)
  (set-member? vowels c))

(define ((check-vowel-count count) ch c)
  (define (next-checker)
    (define n (add1 count))
    (if (= n 3)
        (check (lambda (ch c) ch) #t)
        (check (check-vowel-count n) #f)))        
  (if (char-vowel? c)
      (next-checker)
      ch))


(define test-vowels (checker (check (check-vowel-count 0) #f)))
(check-true (test-vowels "aei"))
(check-true (test-vowels "xazegov"))
(check-true (test-vowels "aeiouaeiouaeiou"))
(check-true (test-vowels "ugknbfddgicrmopn"))
(check-false (test-vowels "dvszwmarrgswjxmb"))


(define (check-digraph cc1 cc2)
  (define (check1 ch c1)
    (define (check2 ch c2)
      (if (and (char=? cc1 c1) (char=? cc2 c2))
          #f
          (check1 ch c2)))
    (check check2 #t))
  check1)

(define test-ab (checker (check (check-digraph #\a #\b) #t)))
(check-true (test-ab "ac"))
(check-true (test-ab "a"))
(check-false (test-ab "ab"))


(define nice-string1?
  (checker (check (check-vowel-count 0) #f)
           (check check-double #f)
           (check (check-digraph #\a #\b) #t)
           (check (check-digraph #\c #\d) #t)
           (check (check-digraph #\p #\q) #t)
           (check (check-digraph #\x #\y) #t)))


(check-true (nice-string1? "ugknbfddgicrmopn"))
(check-true (nice-string1? "aaa"))
(check-false (nice-string1? "jchzalrnumimnmhp"))
(check-false (nice-string1? "haegwjzuvuyypxyu"))
(check-false (nice-string1? "haegwjzuvuyypabu"))
(check-false (nice-string1? "haegwjzuvuyypqu"))
(check-false (nice-string1? "haegwjzuvuyypcdu"))
(check-false (nice-string1? "dvszwmarrgswjxmb"))

(define (solution1)
  (call-with-input-file "05-input.txt"
    (lambda (inp)
      (for/fold ([c 0]) ([s (in-lines inp)])
        ((if (nice-string1? s) add1 values) c)))))


(struct state [table last-char counter] #:transparent)

(define (no-overlap? s v)
  (for/or ([i (in-set s)])
    (< i (sub1 v))))

(define (update-state s c)
  (match-define (state ht last-char i) s)
  (define dg (string last-char c))
  (define v (hash-ref ht dg set))
  (or (no-overlap? v i)
      (state (hash-set ht dg (set-add v i)) c (add1 i))))

(check-true
 (update-state (update-state (update-state (state (hash) #\a 0) #\a) #\a) #\a))
(check-true
 (update-state
  (update-state
   (update-state
    (update-state (state (hash) #\a 0) #\a) #\b) #\a) #\a))
(check-true
 (state?
  (update-state (state (hash) #\a 0) #\a)))

(define (check-digraph2 ch c)
  (define s (state (hash) c 0))
  (define (follow-check s)
    (lambda (ch c)
      (define s2 (update-state s c))
      (if (eq? #t s2)
          (check (lambda (ch c) ch) #t)
          (check (follow-check s2) #f))))
  (check (follow-check s) #f))

(check-false ((checker (check check-digraph2 #f)) "aaa"))
(check-true ((checker (check check-digraph2 #f)) "aaaa"))
(check-true ((checker (check check-digraph2 #f)) "abcabc"))

