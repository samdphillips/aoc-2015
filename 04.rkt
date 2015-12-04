#lang racket/base

(require racket/format
         racket/match
         racket/port
         rackunit
         openssl/md5)

(define (string->md5-bytes s)
  (call-with-input-string s md5-bytes))

(define (advent-hash1? b*)
  (and (zero? (bytes-ref b* 0))
       (zero? (bytes-ref b* 1))
       (zero? (bitwise-and #b11110000
                           (bytes-ref b* 2)))))

(define (advent-hash2? b*)
  (and (zero? (bytes-ref b* 0))
       (zero? (bytes-ref b* 1))
       (zero? (bytes-ref b* 2))))

(define (mine s pred?)
  (let/ec return
    (for ([i (in-naturals)])
      (when (pred? (string->md5-bytes (~a s i)))
        (return i)))))