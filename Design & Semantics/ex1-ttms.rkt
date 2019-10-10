#lang racket

;;;    - Unary: sin, cos, exp, recip (1/x), log (natural log)
;;;    - Binary: +, *, / (x/y), expt (x^y)


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
  (list (list '+ (λ (x1 x2) (+ x1 x2))) ;Working
	(list '* (λ (x1 x2) (* x1 x2))) ;Working

        (list '/ (λ (x1 x2) (/ x1 x2))) ;Working
        (list 'expt (λ (x1 x2) (expt x1 x2))) ;Working

        (list 'recip (λ (x1) (/ 1 x1))) ;Working
        (list 'log log); Working
        
	(list 'sin sin) ;Working
	(list 'cos cos) ;Working
	(list 'exp exp))) ;Working


(define lookup (λ (x alist) (cadr (assoc x alist))))

