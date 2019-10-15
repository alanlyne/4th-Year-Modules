#lang racket
    
(define d
  (λ (e)
    (cond ((number? e) 0)
	  ((equal? e 'x) 1)
	  (else
	   (let ((op (car e)) (args (cdr e)))
	     (apply (lookup op d-op-table) args))))))


(define lookup
  (λ (op table)
    (if (equal? op (caar table))
	(cadar table)
	(lookup op (cdr table)))))

(define d-op-table
  (list(list '+ (λ (u v) (simp+ (d u) (d v)))) 
       
       (list '- (λ (u v) (simp- (d u) (d v)))) 
       
       (list '* (λ (u v)
          (simp+ (simp* u (d v)) (simp* v (d u))))) 
       
       (list '/ (λ (u v)
          (simp/ (simp- (simp* v (d u)) (simp* u (d v))) (simp* v v)))) ;Working


       (list 'log (λ (u) (simp* (simp/ 1  u) (d u))))
       
       (list 'recip (λ (v)                      
          (list '/ (simp- 0 (simp* 1 (d v))) (simp* v v)))) 

       (list 'sin (λ (u v) (list '* (d u) 'cos (list u)))) 
       
       (list 'cos (λ (u v) (list '* (d u) '* -1 'sin (list u))))

       (list 'expt (λ (u v) (simpexpt (simp* v  u) (simp- v 1))))
       
       (list 'exp (λ(u) (simp* (d u) (list 'exp u))))

))



(define ttms-eval
  (λ (e v)
    (cond ((number? e) e)
	  ((equal? e 'x) v)
	  (else
	   (let ((op (car e))
		 (args (cdr e)))
	     (apply (ttml-lookup op ttml-op-table)
		    (map (λ (ee) (ttms-eval ee v)) args)))))))

(define ttml-op-table
  (list (list '+ (λ (u v) (simp+ u v)))

        (list '- (λ (u v) (simp- u v)))
        
	(list '* (λ (u v) (simp* u v)))

        (list '/ (λ (u v) (simp/ u v)))
        
        (list 'expt (λ (u v) (expt u v))) 

        (list 'recip (λ (u) (/ 1 u)))
        
        (list 'log log)
        
	(list 'exp exp)

        (list 'sin sin)
        
	(list 'cos cos)
        ))

(define ttml-lookup (λ (x alist) (cadr (assoc x alist))))

(define simp+ (λ (x y)
    (cond ((and (number? x) (number? y))
	   (+ x y))
	  ((equal? x 0) y)
	  ((equal? y 0) x)
          ((equal? y x) (simp* 2 x))
	  (else (list '+ x y)))))
(define simp- (λ (x y)
    (cond ((and (number? x) (number? y))
	   (- x y))
	  ((equal? x 0) (list '- y))
	  ((equal? y 0) x)
          ((equal? y x) 0)
	  (else (list '- x y)))))
(define simp* (λ (x y)
    (cond ((and (number? x) (number? y))
	   (* x y))
	  ((equal? x 0) 0)
	  ((equal? y 0) 0)
          ((equal? x 1) y)
	  ((equal? y 1) x)
	  (else (list '* x y)))))
(define simp/ (λ (x y)
    (cond ((and (number? x) (number? y))
	   (/ x y))
	  ((equal? x 0) 0)
	  (else (list '/ x y)))))
(define simpexpt (λ (x y)
    (cond ((and (number? x) (number? y))
	   (expt x y))
          ((equal? y 0) 1)
	  ((equal? x 0) 0)
          ((equal? y 1) x)
          ((equal? x 1) 1)
	  (else (list 'expt x y)))))
(define simpexp (λ (x y)
    (cond ((and (number? x) (number? y))
	   (/ x y))
	  ((equal? x 0) 0)
	  (else (list '/ x y)))))

;;; test cases

'differentiation
(d '(- (- x 1) (- x -1)))
(d '(* (+ x 1) (+ x -1)))
(d '(/ 5 (+ x -1)))
(d '(log x))
(d '(expt (* 2 x) 2 ))
(d '(exp x))
(d '(recip (* x x)))
(d '(sin (* 7 x)2))
(d '(cos (* 2 1)2))
'ttms-eval
(ttms-eval '(+ 1 (* 7 x)) 4)
(ttms-eval '(- 1 (* 7 x)) 4)
(ttms-eval '(/ 1 x) 2)
(ttms-eval '(log (* 4 x)) 4)
(ttms-eval '(expt 15 (* 2 x)) 4)
(ttms-eval '(exp (* 9 x)) -4)
(ttms-eval '(recip (* x x)) -7)
(ttms-eval '(sin (* x x)) 2)
(ttms-eval '(cos (* 1 x)) 4)
