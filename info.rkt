#lang info

(define collection "pict3d-die-cut")

(define scribblings '(("pict3d-die-cut.scrbl")))

(define deps '("base"
               ["draw-lib" #:version "1.8"]
               "gui-lib"
               "pict3d"
               "glu-tessellate"))

(define build-deps '("draw-doc"
                     "racket-doc"
                     "scribble-lib"))

(define version "1.1")
