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
          (simp/ (simp- (simp* v (d u)) (simp* u (d v))) (simp* v v))))


       (list 'log (λ (u) (simp* (simp/ 1  u) (d u))))
       
       (list 'recip (λ (v)                      
          (simp/ (simp- 0 (simp* 1 (d v))) (simp* v v)))) 

       (list 'sin (λ (u) (simp* (d u) (simpcos u)))) 
       
       (list 'cos (λ (u) (simp* (d u) (simp* -1 (simpsin u)))))

       (list 'expt (λ (u v) (simpexpt (simp* v  u) (simp- v 1))))
       
       (list 'exp (λ(u) (simp* (d u) (simpexp u))))

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
        
        (list 'expt (λ (u v) (simpexpt u v))) 

        (list 'recip (λ (u) (simp/ 1 u)))
        
        (list 'log log)
        
	(list 'exp (λ (u) (exp u)))

        (list 'sin (λ (u) (simpsin u)))
        
	(list 'cos (λ (u) (simpsin u)))
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
          ((equal? x -1) '- y)
	  ((equal? y -1) '- x)
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
          ((equal? x 1) 1)
          ((equal? y 1) x)
	  (else (list 'expt x y)))))
(define simpexp (λ (y)
    (cond ((number? y)
	   (exp y))
	  (else (list 'exp y)))))
(define simpsin (λ (x)
    (cond ((number? x)
	   (sin x ))
          (else (list 'sin x)))))
(define simpcos (λ (x)
    (cond ((number? x)
	   (cos x ))
          (else (list 'cos x)))))

;;; test cases

'differentiation
(d '(- (- x 1) (- x -1))) ;0
(d '(* (+ x 1) (+ x -1))) ;'(+ (+ x 1) (+ x -1))
(d '(/ 5 (+ x -1))) ;'(/ -5 (* (+ x -1) (+ x -1)))
(d '(log x)) ;'(/ 1 x)
(d '(expt (* 2 x) 2 )) ;'(* 2 (* 2 x))
(d '(exp (* 2 x))) ;'(* 2 (exp (* 2 x)))
(d '(recip (* x x))) ;'(/ (- (* 2 x)) (* (* x x) (* x x)))
(d '(sin (* 7 x))) ;'(* 7 (cos (* 7 x)))
(d '(cos (* x 1))) ;'(sin (* x 1))
'ttms-eval
(ttms-eval '(+ 1 (* 7 x)) 4) ; 29
(ttms-eval '(- 1 (* 7 x)) 'x) ;'(- 1 (* 7 x))
(ttms-eval '(/ 1 x) 4) ;1/4
(ttms-eval '(log (* 4 x)) 4) ;2.772588722239781
(ttms-eval '(expt 15 (* 2 x)) 4) ;2562890625
(ttms-eval '(exp (* 9 x)) -4) ;2.3195228302435696e-16
(ttms-eval '(recip (* x x)) -7) ;1/49
(ttms-eval '(sin (* x x)) 2) ;-0.7568024953079282
(ttms-eval '(cos (* 1 x)) 3) ;0.1411200080598672
(ttms-eval '(+ (* 2 (/ 7 (+ 2 4))) (* 7 x)) 'x) ;'(+ 2 1/3 (* 7 x))

;; good simp example would be, none simp '(+ (* (* x x) (+ 0 1)) (* (+ 2 x) (+ ( * x 1) (* x 1))))
(d '(* (* x x) (+ 2 x))) ;'(+ (* x x) (* (+ 2 x) (* 2 x)))
