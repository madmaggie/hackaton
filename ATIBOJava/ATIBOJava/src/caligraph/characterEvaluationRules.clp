(deftemplate CharacterEvaluation (declare (from-class CharacterEvaluation)))


; 2 - foarte bine
; 1 - bine
; 0 - insuficient
(deftemplate evaluation
	(slot up (type INTEGER) (allowed-integers 0 1 2) (default 0))
	(slot down (type INTEGER) (allowed-integers 0 1 2) (default 0))
	(slot left (type INTEGER) (allowed-integers 0 1 2) (default 0))
	(slot right (type INTEGER) (allowed-integers 0 1 2) (default 0))
	(slot wide (type INTEGER) (allowed-integers 0 1 2) (default 0))
	(slot narrow (type INTEGER) (allowed-integers 0 1 2) (default 0))
	(slot tall (type INTEGER) (allowed-integers 0 1 2) (default 0))
	(slot short (type INTEGER) (allowed-integers 0 1 2) (default 0))
	(slot tilt (type INTEGER) (allowed-integers 0 1 2) (default 0))
	(slot shape (type INTEGER) (allowed-integers 0 1 2) (default 0))
	(slot mark (type STRING) (allowed-strings "insuficient" "bine" "foarte-bine") (default "foarte-bine"))
)

(deftemplate answer
	(slot dimension (type INTEGER) (allowed-integers -2 -1 0 1 2) (default 0))
	(slot xDisplacement (type INTEGER) (allowed-integers -2 -1 0 1 2) (default 0))
	(slot yDisplacement (type INTEGER) (allowed-integers -2 -1 0 1 2) (default 0))	
	(slot shape (type INTEGER) (allowed-integers 0 1 2) (default 0))
	(slot mark (type STRING) (allowed-strings "insuficient" "bine" "foarte-bine") (default "foarte-bine"))
)

(deffacts crtEvaluation (evaluation))

(deffacts crtAnswer (answer))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; rules ;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;; size of letter ;;;;;;;;;;;;;;;;;;;;;

(defrule too-high
	(character (height ?h) (heightModel ?hm))
	(test (> (/ ?h ?hm) 1.2))
	(test (< (/ ?h ?hm) 1.5))
	?f <- (evaluation (tall 0))
=>
	(modify ?f (tall 1))
)

(defrule much-too-high
	(character (height ?h) (heightModel ?hm))
	(test (>= (/ ?h ?hm) 1.5))
	?f <- (evaluation (tall 0))
=>
	(modify ?f (tall 2))
)

(defrule too-short
	(character (height ?h) (heightModel ?hm))
	(test (< (/ ?h ?hm) 0.8))
	(test (> (/ ?h ?hm) 0.5))
	?f <- (evaluation (short 0))
=>
	(modify ?f (short 1))
)

(defrule much-too-short
	(character (height ?h) (heightModel ?hm))
	(test (<= (/ ?h ?hm) 0.5))
	?f <- (evaluation (short 0))
=>
	(modify ?f (short 2))
)

(defrule too-wide
	(character (width ?w) (widthModel ?wm))
	(test (> (/ ?w ?wm) 1.2))
	(test (< (/ ?w ?wm) 1.5))
	?f <- (evaluation (wide 0))
=>
	(modify ?f (wide 1))
)

(defrule much-too-wide
	(character (width ?w) (widthModel ?wm))
	(test (> (/ ?w ?wm) 1.5))
	?f <- (evaluation (wide 0))
=>
	(modify ?f (wide 2))
)

(defrule too-narrow
	(character (width ?w) (widthModel ?wm))
	(test (< (/ ?w ?wm) 0.9))
	(test (> (/ ?w ?wm) 0.5))
	?f <- (evaluation (narrow 0))
=>
	(modify ?f (narrow 1))
)

(defrule much-too-narrow
	(character (width ?w) (widthModel ?wm))
	(test (<= (/ ?w ?wm) 0.5))
	?f <- (evaluation (narrow 0))
=>
	(modify ?f (narrow 2))
)

;;;;;;;;;;;;;;;;;;; displacement of letter ;;;;;;;;;;;;;;;;;;;;;;;;

(defrule too-up
	(character (centruMasa ?cmx ?cmy) (centruMasaModel ?cmmx ?cmmy))
	(test (> (- ?cmmy ?cmy) 0.2))
	(test (<= (- ?cmmy ?cmy) 0.5))
	?f <- (evaluation (up 0))
=>
	(modify ?f (up 1))
)

(defrule much-too-up
	(character (centruMasa ?cmx ?cmy) (centruMasaModel ?cmmx ?cmmy))
	(test (> (- ?cmmy ?cmy)) 0.5))
	?f <- (evaluation (up 0))
=>
	(modify ?f (up 2))
)

(defrule too-down
	(character (centruMasa ?cmx ?cmy) (centruMasaModel ?cmmx ?cmmy))
	(test (> (- ?cmy ?cmmy) 0.2))
	(test (<= (- ?cmy ?cmmy)) 0.5))
	?f <- (evaluation (down 0))
=>
	(modify ?f (down 1))
)

(defrule much-too-down
	(character (centruMasa ?cmx ?cmy) (centruMasaModel ?cmmx ?cmmy))
	(test (> (- ?cmy ?cmmy) 0.5))
	?f <- (evaluation (down 0))
=>
	(modify ?f (down 2))
)


(defrule too-left
	(character (centruMasa ?cmx ?cmy) (centruMasaModel ?cmmx ?cmmy))
	(test (> (- ?cmmx ?cmx) 0.1))
	(test (<= (- ?cmmx ?cmx) 0.25))
	?f <- (evaluation (left 0))
=>
	(modify ?f (left 1))
)

(defrule much-too-up
	(character (centruMasa ?cmx ?cmy) (centruMasaModel ?cmmx ?cmmy))
	(test (> (- ?cmmx ?cmx)) 0.25))
	?f <- (evaluation (left 0))
=>
	(modify ?f (left 2))
)

(defrule too-right
	(character (centruMasa ?cmx ?cmy) (centruMasaModel ?cmmx ?cmmy))
	(test (> (- ?cmx ?cmmx) 0.1))
	(test (<= (- ?cmx ?cmmx)) 0.25))
	?f <- (evaluation (right 0))
	=>
	(modify ?f (right 1))
)

(defrule much-too-right
	(character (centruMasa ?cmx ?cmy) (centruMasaModel ?cmmx ?cmmy))
	(test (> (- ?cmx ?cmmx) 0.25))
	?f <- (evaluation (right 0))
	=>
	(modify ?f (right 2))
)

;;;;;;;;;;;;;;;;;;;;;;; mark ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;; 1 mistake => "bine"

(defrule mark-bine-up
	?f <- (evaluation (mark "foarte-bine") (up 1))
=>
	(modify ?f (mark "bine"))
)

(defrule mark-bine-down
	?f <- (evaluation (mark "foarte-bine") (down 1))
=>
	(modify ?f (mark "bine"))
)

(defrule mark-bine-left
	?f <- (evaluation (mark "foarte-bine") (left 1))
=>
	(modify ?f (mark "bine"))
)

(defrule mark-bine-right
	?f <- (evaluation (mark "foarte-bine") (right 1))
=>
	(modify ?f (mark "bine"))
)

(defrule mark-bine-wide
	?f <- (evaluation (mark "foarte-bine") (wide 1))
=>
	(modify ?f (mark "bine"))
)

(defrule mark-bine-narrow
	?f <- (evaluation (mark "foarte-bine") (narrow 1))
=>
	(modify ?f (mark "bine"))
)

(defrule mark-bine-tall
	?f <- (evaluation (mark "foarte-bine") (tall 1))
=>
	(modify ?f (mark "bine"))
)

(defrule mark-bine-short
	?f <- (evaluation (mark "foarte-bine") (short 1))
=>
	(modify ?f (mark "bine"))
)

(defrule mark-bine-tilt
	?f <- (evaluation (mark "foarte-bine") (tilt 1))
=>
	(modify ?f (mark "bine"))
)

(defrule mark-bine-shape
	?f <- (evaluation (mark "foarte-bine") (shape 1))
=>
	(modify ?f (mark "bine"))
)




;;;;; 2 mistakes => insuficient

;; up

(defrule mark-insuficient-up-left
	?f <- (evaluation (mark "foarte-bine") (up 1) (left 1))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-up-right
	?f <- (evaluation (mark "foarte-bine") (up 1) (right 1))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-up-wide
	?f <- (evaluation (mark "foarte-bine") (up 1) (wide 1))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-up-narrow
	?f <- (evaluation (mark "foarte-bine") (up 1) (narrow 1))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-up-tall
	?f <- (evaluation (mark "foarte-bine") (up 1) (tall 1))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-up-short
	?f <- (evaluation (mark "foarte-bine") (up 1) (short 1))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-up-tilt
	?f <- (evaluation (mark "foarte-bine") (up 1) (tilt 1))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-up-shape
	?f <- (evaluation (mark "foarte-bine") (up 1) (shape 1))
=>
	(modify ?f (mark "insuficient"))
)

;; down

(defrule mark-insuficient-down-left
	?f <- (evaluation (mark "foarte-bine") (down 1) (left 1))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-down-right
	?f <- (evaluation (mark "foarte-bine") (down 1) (right 1))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-down-wide
	?f <- (evaluation (mark "foarte-bine") (down 1) (wide 1))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-down-narrow
	?f <- (evaluation (mark "foarte-bine") (down 1) (narrow 1))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-down-tall
	?f <- (evaluation (mark "foarte-bine") (down 1) (tall 1))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-down-short
	?f <- (evaluation (mark "foarte-bine") (down 1) (short 1))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-down-tilt
	?f <- (evaluation (mark "foarte-bine") (down 1) (tilt 1))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-down-shape
	?f <- (evaluation (mark "foarte-bine") (down 1) (shape 1))
=>
	(modify ?f (mark "insuficient"))
)

;; left

(defrule mark-insuficient-left-wide
	?f <- (evaluation (mark "foarte-bine") (left 1) (wide 1))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-left-narrow
	?f <- (evaluation (mark "foarte-bine") (left 1) (narrow 1))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-left-tall
	?f <- (evaluation (mark "foarte-bine") (left 1) (tall 1))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-left-short
	?f <- (evaluation (mark "foarte-bine") (left 1) (short 1))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-left-tilt
	?f <- (evaluation (mark "foarte-bine") (left 1) (tilt 1))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-left-shape
	?f <- (evaluation (mark "foarte-bine") (left 1) (shape 1))
=>
	(modify ?f (mark "insuficient"))
)

;; right

(defrule mark-insuficient-right-wide
	?f <- (evaluation (mark "foarte-bine") (right 1) (wide 1))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-right-narrow
	?f <- (evaluation (mark "foarte-bine") (right 1) (narrow 1))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-right-tall
	?f <- (evaluation (mark "foarte-bine") (right 1) (tall 1))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-right-short
	?f <- (evaluation (mark "foarte-bine") (right 1) (short 1))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-right-tilt
	?f <- (evaluation (mark "foarte-bine") (right 1) (tilt 1))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-right-shape
	?f <- (evaluation (mark "foarte-bine") (right 1) (shape 1))
=>
	(modify ?f (mark "insuficient"))
)

;; wide

(defrule mark-insuficient-wide-tall
	?f <- (evaluation (mark "foarte-bine") (wide 1) (tall 1))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-wide-short
	?f <- (evaluation (mark "foarte-bine") (wide 1) (short 1))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-wide-tilt
	?f <- (evaluation (mark "foarte-bine") (wide 1) (tilt 1))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-wide-shape
	?f <- (evaluation (mark "foarte-bine") (wide 1) (shape 1))
=>
	(modify ?f (mark "insuficient"))
)

;; narrow

(defrule mark-insuficient-narrow-tall
	?f <- (evaluation (mark "foarte-bine") (narrow 1) (tall 1))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-narrow-short
	?f <- (evaluation (mark "foarte-bine") (narrow 1) (short 1))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-narrow-tilt
	?f <- (evaluation (mark "foarte-bine") (narrow 1) (tilt 1))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-narrow-shape
	?f <- (evaluation (mark "foarte-bine") (narrow 1) (shape 1))
=>
	(modify ?f (mark "insuficient"))
)

;; tall

(defrule mark-insuficient-tall-tilt
	?f <- (evaluation (mark "foarte-bine") (tall 1) (tilt 1))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-tall-shape
	?f <- (evaluation (mark "foarte-bine") (tall 1) (shape 1))
=>
	(modify ?f (mark "insuficient"))
)

;; short

(defrule mark-insuficient-short-tilt
	?f <- (evaluation (mark "foarte-bine") (short 1) (tilt 1))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-short-shape
	?f <- (evaluation (mark "foarte-bine") (short 1) (shape 1))
=>
	(modify ?f (mark "insuficient"))
)

;; tilt

(defrule mark-insuficient-tilt-shape
	?f <- (evaluation (mark "foarte-bine") (tilt 1) (shape 1))
=>
	(modify ?f (mark "insuficient"))
)

;;; 1 big mistake => insuficient

(defrule mark-insuficient-up
	?f <- (evaluation (mark "foarte-bine") (up 2))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-down
	?f <- (evaluation (mark "foarte-bine") (down 2))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-left
	?f <- (evaluation (mark "foarte-bine") (left 2))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-right
	?f <- (evaluation (mark "foarte-bine") (right 2))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-wide
	?f <- (evaluation (mark "foarte-bine") (wide 2))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-narrow
	?f <- (evaluation (mark "foarte-bine") (narrow 2))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-tall
	?f <- (evaluation (mark "foarte-bine") (tall 2))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-short
	?f <- (evaluation (mark "foarte-bine") (short 2))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-tilt
	?f <- (evaluation (mark "foarte-bine") (tilt 2))
=>
	(modify ?f (mark "insuficient"))
)

(defrule mark-insuficient-shape
	?f <- (evaluation (mark "foarte-bine") (shape 2))
=>
	(modify ?f (mark "insuficient"))
)