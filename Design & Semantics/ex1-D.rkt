#lang racket

;;;    - Unary: sin, cos, exp, recip (1/x), log (natural log)
;;;    - Binary: +, *, / (x/y), expt (x^y)

(define d
  (λ (e)
    (cond ((number? e) 0)
	  ((equal? e 'x) 1)
	  (else
	   (let ((op (car e)) (args (cdr e)))
	     (apply (lookup op d-op-table) args))))))
    

(define d-op-table
  (list(list '+ (λ (u v) (list '+ (d u) (d v)))) ;Working
       
       (list '- (λ (u v) (list '- (d u) (d v)))) ;Working
       
       (list '* (λ (u v)
          (list '+ (list ' * u (d v)) (list ' * v (d u))))) ;Working
       
       (list '/ (λ (u v)
          (list '/ (list '- (list ' * v (d u)) (list ' * u (d v))) (list ' * v v)))) ;Working

       (list 'expt (λ (u v) (list 'expt (list '* v  u) (- v 1)))) ;Working
       
       (list 'sin (λ (u v) (list '* (d u) 'cos (list u)))) ;Working
       
       (list 'cos (λ (u v) (list '* list (d u) '* -1 'sin (list u)))) ;Working

))

(define lookup
  (λ (op table)
    (if (equal? op (caar table))
	(cadar table)
	(lookup op (cdr table)))))


#|
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define d1  ;;; calling the function, "d"
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
                   
                   ((equal? op '/) ;;; If op == "/"...
                    (list '/ ;;; ((du * v) - (dv * u) / (v^2)
                          (list '-
                          (list '* (d u) v)
                          (list '* (d v) u)) (* v v)))
                   
		   (else (error))))))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define d2
  (λ (e)
    (cond ((number? e) 0)
          ((equal? e 'x) 1)
          (else
           (let ((op (car e)) (u (cadr e)) (v (caddr e)))
             (apply (lookup1 op d-op-table1)
                    (map (λ (ee) (d1 ee v)) u v)))))))
(define d-op-table1
  (list (list '+ (λ (u1 v1) (+ (d u1) (d v1))))
        (list '* (λ (u1 v1) (* (d u1) (d v1))))))
        
(define lookup1
  (λ (op table)
    (if (equal? op (caar table))
	(cadar table)
	(lookup op (cdr table)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define d3
  (λ (e)
    (cond ((number? e) 0)
	  ((equal? e 'x) 1)
	  (else
	   ;; We handle only BINARY ops here, and only + and *
	   (let ((op (car e)) (args (cdr e)))
	     (apply (lookup op d-op-table) args))))))
    
(define d-op-table
  (list(list '+ (λ (u v) (+ (d3 u) (d3 v))))
       ;(list '* (λ (u v)
        ;  (list '+ (list '(* u (d3 v))) (list '(* v (d3 u))))))))
       (list '+ (λ (u1 v1)
             (list '(* u1 (d v1)))(list '(* (d u1) v1))))))
(define lookup
  (λ (op table)
    (if (equal? op (caar table))
	(cadar table)
	(lookup op (cdr table)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
|#