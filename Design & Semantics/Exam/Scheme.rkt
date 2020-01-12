#lang racket

;Jan 2019
;Define a Scheme function SCATTER-GATHER which takes two
;arguments, a list INDICES of indices and a list VALS of values,
;and returns a list of the same length as INDICES but with each
;value K replaced by the K-th element of VALS, or if that is out of
;range, by #f.

(define (scatterGather indices values)
  (cond ((null? indices) '())
        ((<(car indices)(length values)) 
        (cons (list-ref values (car indices))(scatterGather (cdr indices) values)))
        (else (cons '#f(scatterGather (cdr indices) values)))))
 

;(scatterGather '(0 1 4 1 1 7 2) '(a b c d e))
;=> (a b e b b #f c)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Autumn 2019
;Define a Scheme function PLUSEVENS which takes a list of number and 
;returns the sum of those that occur in even positions in the list.

(define (plusevens list)
  (cond ((<(length list)3)
         (car list))
        (else(+ (car list)(plusevens (cddr list))))))

;(plusevens '(1 20 300 4000 50000 600000)) 
;=> 50301

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Jan 2018
;Define a Scheme function tear which takes two arguments, a
;predicate p? and a list xs, and returns a list of two lists, the
;first of which is the elements of xs that pass p?, and the second
;of which is the elements of xs that fail it, both in order.

(define (tear p xs)
  (list (filter p xs)(filter (lambda (notNum)(not (p notNum))) xs)))

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

;(define map-skip
;  (λ (func l)
;    (cond ((null? l)'());If l is empty/null, return an empty list
;          (else
;           (append (list (func (car l))(cadr l))(map-skip func(drop l 2)))))))

(define (map-skip func list)
  (cond ((null? list)
         '())
        ((=(length list)1)
         (cons(func (car list)) '()))
        (else
         (cons (func (car list)) (cons (cadr list) (map-skip func(cddr list)))))))
  

;(map-skip (λ (x) (+ x 1000)) '(1 2 3 4 5 6))
;=> (1001 2 1003 4 1005 6)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Jan 2017
;Define a Scheme function foo which finds all atoms inside an sexpression which pass a given predicate.

(define (foo func list)
   (cond ((null? list)
         '())
         ((list? (car list))
          (foo func (flatten list))) ;Flatten turns several lists into one list (a (2 (c 3) 4))) -> (a 2 c 3 4)
         ((eq? (func (car list)) #t) ;Checks if the 1st element in list is (e.g) a number
          (cons (car list) (foo func (cdr list))))
         (else (foo func (cdr list)))))

;(foo number? '(a (2 (c 3) 4)))
;=> (2 3 4)
;(foo symbol? '(a (2 (c 3) 4)))
;=> (a c)
;(foo symbol? 'a)
;=> (a)
;(foo number? 'a)
;=> ()

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Aug 2017 NOT FULLY WORKING
;Define a Scheme function foo that takes two lists and yields a list combining all the
;elements in the two input lists, taking 1 from the first list, 2 from the second list, 3 from
;the first list, 4 from the second list, etc, until both are exhausted.

(define (foO l1 l2)
    (poof l1 l2 1))

(define (poof l1 l2 x)
    (cond
      ((and (null? l1) (null? l2))'())
      ((>= x (length l1)) l2)
      ((>= x (length l2)) l1)
      (else
       (append (append (take l1 x) (poof l2 (drop l1 x) (+ x 1)))))))

;(foo '(a b c d e f g) '(aa bb cc dd ee ff gg))
;=> (a aa bb b c d cc dd ee ff e f g gg)
;(foo '(a b c d e f g) '())
;=> (a b c d e f g)
;(foo '() '(aa bb cc dd ee ff gg))
;=> (aa bb cc dd ee ff gg)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Jan 2016
;Define a Scheme function reverse-with-count which takes two
;lists, the second of which is a list of non-negative integers the
;same length as the first list, and returns a list of elements from
;the first list, in reverse order, each repeated a number of times
;as specified by the corresponding element of the second list.

(define (revCount list1 list2)
  (cond ((null? list2) '())
        (else (flatten (cons (make-list (car (reverse list2)) (car (reverse list1))) (revCount (reverse (cdr (reverse list1))) (reverse (cdr (reverse list2)))))))))

;"Make a list" with the 1st value of the reversed 2nd list, with the number of iterations given by the 1st value of the reversed 1st list

;(revCount '(a b c) '(1 2 3))
;=> (c c c b b a)
;(revCount '(d c b a) '(3 0 0 1))
;=> (a d d d)


