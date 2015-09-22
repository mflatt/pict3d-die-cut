#lang scribble/manual
@(require (for-label pict3d-die-cut
                     racket/base
                     racket/contract/base
                     racket/gui/base
                     pict3d))

@title{Text and Paths for Pict3D}

@defmodule[pict3d-die-cut]{The @racketmodname[pict3d-die-cut] library
creates 3-dimensional cut-outs as @racket[Pict3D]s, including cut-outs
for text or other drawing paths created with @racket[dc-path%].}

@defproc[(die-cut [dc-path dc-path%]
                  [#:depth depth real? 1.0]
                  [#:double-sided? double-sided? any/c #t]
                  [#:expected-scale expected-scale real? 1.0])
         pict3d?]{

Produces a @racket[Pict3D] version of @racket[dc-path] by creating a
solid face that matches the region bounded by the closed paths of
@racket[dc-path]. Since drawing coordinates and 3-D coordinates are
flipped, the resulting 3-D object extends in the negative y-direction
the same amount that the path extends in the positive y-direction. The
3-D object starts in the z-origin plane and extends in negative
z-direction by @racket[depth]. If @racket[double-sided?] is true, then
a solid face is also constructed for the back size of the region.

If @racket[dc-path] contains any curves, they will be approximated by
line segments. The @racket[expcted-scale] argument determines the
scale at which line segments replace curves.}

@defproc[(die-cut-text [text string?]
                       [#:font font (is-a/c font%) (make-font)]
                       [#:combine? combine? any/c #f]
                       [#:depth depth real? 1.0]
                       [#:double-sided? double-sided? any/c #t]
                       [#:expected-scale expected-scale real? 1.0])
         pict3d?]{

Uses @racket[die-cut] on a path constructed with @xmethod[dc-path%
text-outline] and then given @racket[font], @racket[text], and
@racket[combine?].}


@defproc[(die-cut-path-datum [datum (listof (listof vector?))]
                             [#:depth depth real? 1.0]
                             [#:double-sided? double-sided? any/c #t]
                             [#:expected-scale expected-scale real? 1.0])
         pict3d?]{

Like @racket[die-cut], but taking a @racket[datum] matching the format
of the first result produced by @xmethod[dc-path% get-datum].}
