#lang racket

;;;Differentiation
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
       
       (list 'exp (λ(u) (list '* (d u) (list 'exp u)))) ;Wokring

       (list 'log (λ (u) (list '* (list '/ 1  u) (d u)))) ;Working
       
       (list 'recip (λ (v)
          (list '/ (list '- 0 (list ' * 1 (d v))) (list ' * v v)))) ;Working
       
       (list 'sin (λ (u v) (list '* (d u) 'cos (list u)))) ;Working
       
       (list 'cos (λ (u v) (list '* list (d u) '* -1 'sin (list u)))))) ;Working


;;;TTMS-Eval
(define ttms-eval
  (λ (a z)
    (cond ((number? a) a)
	  ((equal? a 'x) z)
	  (else
	   (let ((op (car a))
		 (args (cdr a)))
	     (apply (lookup op ttml-op-table)
		    (map (λ (aa) (ttms-eval aa z)) args)))))))

(define ttml-op-table
  (list (list '+ (λ (x1 x2) (+ x1 x2))) ;Working
	(list '* (λ (x1 x2) (* x1 x2))) ;Working

        (list '- (λ (x1 x2) (- x1 x2))) ;Working
        (list '/ (λ (x1 x2) (/ x1 x2))) ;Working
        (list 'expt (λ (x1 x2) (expt x1 x2))) ;Working

        (list 'recip (λ (x1) (/ 1 x1))) ;Working
        (list 'log log); Working
        
	(list 'sin sin) ;Working
	(list 'cos cos) ;Working
	(list 'exp exp))) ;Working#


;;;Lookup Table
(define lookup (λ (x alist) (cadr (assoc x alist))))