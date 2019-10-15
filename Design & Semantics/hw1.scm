#lang racket

;;; Alan Lyne 15468498

;;;Differentiation
(define d
  (λ (e)
    (cond ((number? e) 0)
	  ((equal? e 'x) 1)
	  (else
	   (let ((op (car e)) (args (cdr e)))
	     (apply (lookup op d-op-table) args))))))


(define d-op-table
  (list(list '+ (λ (u v) (ttms+ (d u) (d v)))) 
       
       (list '- (λ (u v) (ttms- (d u) (d v)))) 
       
       (list '* (λ (u v)
          (ttms+ (ttms* u (d v)) (ttms* v (d u))))) 
       
       (list '/ (λ (u v)
          (ttms/ (ttms- (ttms* v (d u)) (ttms* u (d v))) (ttms* v v))))

       (list 'exp (λ(u) (ttms* (d u) (ttmsexp u))))

       (list 'expt (λ (u v) (ttmsexpt (ttms* v  u) (ttms- v 1))))

       (list 'log (λ (u) (ttms* (ttms/ 1  u) (d u))))
       
       (list 'recip (λ (v)                      
          (ttms/ (ttms- 0 (ttms* 1 (d v))) (ttms* v v)))) 

       (list 'sin (λ (u) (ttms* (d u) (ttmscos u)))) 
       
       (list 'cos (λ (u) (ttms* (d u) (ttms* -1 (ttmssin u)))))))


(define ttms-eval
  (λ (e v)
    (cond ((number? e) e)
	  ((equal? e 'x) v)
	  (else
	   (let ((op (car e))
		 (args (cdr e)))
	     (apply (lookup op ttml-op-table)
		    (map (λ (ee) (ttms-eval ee v)) args)))))))


(define ttml-op-table
  (list (list '+ (λ (u v) (ttms+ u v)))

        (list '- (λ (u v) (ttms- u v)))
        
	(list '* (λ (u v) (ttms* u v)))

        (list '/ (λ (u v) (ttms/ u v)))
        
        (list 'expt (λ (u v) (ttmsexpt u v))) 

        (list 'recip (λ (u) (ttms/ 1 u)))
        
        (list 'log log)
        
	(list 'exp (λ (u) (exp u)))

        (list 'sin (λ (u) (ttmssin u)))
        
	(list 'cos (λ (u) (ttmscos u)))))


;Simplify Addition
(define ttms+ (λ (x y)
    (cond ((and (number? x) (number? y))
	   (+ x y))
	  ((equal? x 0) y)
	  ((equal? y 0) x)
          ((equal? y x) (ttms* 2 x))
	  (else (list '+ x y)))))

;Simplify Subtraction
(define ttms- (λ (x y)
    (cond ((and (number? x) (number? y))
	   (- x y))
	  ((equal? x 0) (list '- y))
	  ((equal? y 0) x)
          ((equal? y x) 0)
	  (else (list '- x y)))))

;Simplify Multiplication
(define ttms* (λ (x y)
    (cond ((and (number? x) (number? y))
	   (* x y))
	  ((equal? x 0) 0)
	  ((equal? y 0) 0)
          ((equal? x 1) y)
	  ((equal? y 1) x)
          ((equal? x -1) '- y)
	  ((equal? y -1) '- x)
	  (else (list '* x y)))))

;Simplify Division
(define ttms/ (λ (x y)
    (cond ((and (number? x) (number? y))
	   (/ x y))
	  ((equal? x 0) 0)
	  (else (list '/ x y)))))

;Simplify Exponential
(define ttmsexp (λ (y)
    (cond ((number? y)
	   (exp y))
	  (else (list 'exp y)))))

;Simplify Expt (x^y)
(define ttmsexpt (λ (x y)
    (cond ((and (number? x) (number? y))
	   (expt x y))
          ((equal? y 0) 1)
	  ((equal? x 0) 0)
          ((equal? x 1) 1)
          ((equal? y 1) x)
	  (else (list 'expt x y)))))

;Simplify sin
(define ttmssin (λ (x)
    (cond ((number? x)
	   (sin x ))
          (else (list 'sin x)))))

;Simplify cos
(define ttmscos (λ (x)
    (cond ((number? x)
	   (cos x ))
          (else (list 'cos x)))))


;;;Lookup Table
(define lookup (λ (x alist) (cadr (assoc x alist))))

;;;Test Cases

'Differentiation
(d '(* (+ x 1) (+ x -1)))
(d '(/ (+ x 1) (+ x -1)))
(d '(log (+ x 1) ))
(d '(expt (* x 1) 2 ))
(d '(exp (* x 1)))
(d '(recip (* x 1)))
(d '(sin (* x 1)))
(d '(cos (* x 1)))
'TTMS-EVAL
(ttms-eval '(+ 1 (* x 2)) 7)
(ttms-eval '(/ 1 (* x 2)) 7)
(ttms-eval '(log (* x 2)) 7)
(ttms-eval '(expt 15 (* x 2)) 7)
(ttms-eval '(exp (* x 2)) 7)
(ttms-eval '(recip (* x 2)) 7)
(ttms-eval '(sin (* x 2)) 7)
(ttms-eval '(cos (* x 2)) 7)






