#lang racket/base
(require racket/class
         racket/draw
         pict3d
         glu-tessellate)

(provide die-cut
         die-cut-text
         die-cut-path-datum)

(define (die-cut-path-datum c
                            #:depth [depth 1.0]
                            #:double-sided? [double-sided? #f]
                            #:expected-scale [expected-scale 1.0])
  (define (flip y) (- y))
  
  (define tris (paths->triangles c #:expected-scale expected-scale))
  (define edgs (if (zero? depth)
                   null
                   (paths->edges c #:expected-scale expected-scale)))
  
  (apply combine
         (append
          ;; Top and maybe bottom:
          (for/list ([t (in-list tris)])
            (define p1 (vector-ref t 0))
            (define p2 (vector-ref t 1))
            (define p3 (vector-ref t 2))
            (define (mk front? z)
              (triangle (pos (car p1)
                             (flip (cdr p1))
                             z)
                        (pos (car p2)
                             (flip (cdr p2))
                             z)
                        (pos (car p3)
                             (flip (cdr p3))
                             z)
                        #:back? front?))
            (if double-sided?
                (combine (mk #t 0.0) (mk #f (- depth)))
                (mk #t 0.0)))
          ;; Edges of the path, if non-zero depth:
          (for/list ([e (in-list edgs)])
            (define p1 (vector-ref e 0))
            (define p2 (vector-ref e 1))
            (quad (pos (car p1)
                       (flip (cdr p1))
                       0.0)
                  (pos (car p2)
                       (flip (cdr p2))
                       0.0)
                  (pos (car p2)
                       (flip (cdr p2))
                       (- depth))
                  (pos (car p1)
                       (flip (cdr p1))
                       (- depth)))))))

(define (die-cut p
                 #:depth [depth 1.0]
                 #:double-sided? [double-sided? #f]
                 #:expected-scale [expected-scale 1.0])
  (define-values (c o) (send p get-datum))
  (die-cut-path-datum c
                      #:depth depth
                      #:double-sided? double-sided?
                      #:expected-scale expected-scale))
           
(define (die-cut-text str
                      #:font [font (make-font)]
                      #:combine? [combine? #f]
                      #:depth [depth 1.0]
                      #:double-sided? [double-sided? #f]
                      #:expected-scale [expected-scale 1.0])
  (define p (new dc-path%))
  (send p text-outline font str 0 0 combine?)
  (die-cut p
           #:depth depth
           #:double-sided? double-sided?
           #:expected-scale expected-scale))
