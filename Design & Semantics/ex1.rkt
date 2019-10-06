#lang racket
(require (planet dyoo/simply-scheme:2:2))


(define d  ;;; calling the function, "d"
  (λ (e)  ;;; input "e"
    (cond ((number? e) 0) ;;; If "e" is a number, output 0
	  ((equal? e 'x) 1)  ;;; If "e" equals "x", output 1 
	  (else
	   (let ((op (car e)) (u (cadr e)) (v (caddr e))) ;;; op is the 1st item in "e", "u" is the 2nd, "v" the 3rd
	     (cond ((equal? op '+) ;;; If op == "+", add the "d" of u and "d" of v (Recursion)to the list
		    (list '+ (d u) (d v))) ;;;
		   ((equal? op '*) ;;; If op == "*"...
		    (list '+
			  (list '* u (d v)) ;;; multiply "u" by the "d" of "v" (Recursion) and...
			  (list '* (d u) v))) ;;; multiply the "d" of "u"(Recursion) by "v".
                                              ;;; Then add both together and put in the list
		   (else (error))))))))

