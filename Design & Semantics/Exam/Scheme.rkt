#lang racket

; Jan 2019
;Define a Scheme function SCATTER-GATHER which takes two
;arguments, a list INDICES of indices and a list VALS of values,
;and returns a list of the same length as INDICES but with each
;value K replaced by the K-th element of VALS, or if that is out of
;range, by #f.

;(define (sg indices val)
;  (if (null? indices)
;      '()
;      (with-handlers ([exn:fail? (lambda (exn) #f)])
;      (cons (list-ref val (car ind)) (sg (cdr ind) val)))))


(define (scatterGather indices values)
  (cond ((null? indices)
         '())
        ((<(car indices)(length values)) 
        (cons (list-ref values (car indices))(scatterGather (cdr indices) values)))
        
        (else
         (cons '#f(scatterGather (cdr indices) values)))))
 

(scatterGather '(0 1 4 1 1 7 2) '(a b c d e))
;=> (a b e b b #f c)
#|
(define (scatterGather indices values)
  (if (null? ind)
      '()
      (with-handlers ([exn:fail? (lambda (exn) #f)])
      (cons (list-ref values (car indices)) (scatterGather (cdr indices) values)))))
|#
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
;Autumn 2019
(define (plusevens  lst)
  (if (> 3 (length lst)) ; length less than 3
            (car lst)                    
            (+ (car lst) ; add first element of new list           
               (plusevens (cddr lst))))) ; pass back the list with the top two elements taken off it
#| 

Example 
(plusevens '(1 20 300 4000 50000 600000)) => 50301

+ 1
lst => (300 4000 50000 600000)

+300
lst => (50000 600000)
(lentgth of lst < 3)
(car lst)
50000

add all together

NB: (car lst) == (+ (car lst)) why? why + optional and still works?
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Jan 2018
;Define a Scheme function tear which takes two arguments, a
;predicate p? and a list xs, and returns a list of two lists, the
;first of which is the elements of xs that pass p?, and the second
;of which is the elements of xs that fail it, both in order.

(define tear
  (λ (p? xs)
  (list (filter p? xs) (filter (λ (x)(not (p? x))) xs))))
;Filter returns a list with the elements of "xs" for which "(λ (x)(not (p? x)))" produces a true value.
;The "(λ (x)(not (p? x)))" procedure is applied to each element from first to last.
;List returns a newly allocated list.

;(tear number? '(a b c 1 2 3 d e f))
;=> ((1 2 3) (a b c d e f))
;(tear (lambda (x) (> x 5)) '(1 10 2 12 3 13))
;=> ((10 12 13) (1 2 3))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Aug 2018
;Define a Scheme function map-skip which takes a function and a
;list and returns the result of applying the given function to
;every other element of the given list, starting with the first
;element.

(define map-skip
  (λ (func l)
    (cond ((null? l)'());If l is empty/null, return an empty list
          (else
           (append (list (func (car l))(cadr l))(map-skip func(drop l 2)))))))
;"(func (car l))" applys the first element in l to x. i.e x=2, (+ x 1000) then adds them together
;"list" creates a new list with the new value and the remainder of the list
;"(map-skip func(drop l 2))" drops the first 2 elements of l.
;The process happens again until l is empty/null.
;"appeand" puts everything together at the end

;(map-skip (λ (x) (+ x 1000)) '(1 2 3 4 5 6))
;=> (1001 2 1003 4 1005 6)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
