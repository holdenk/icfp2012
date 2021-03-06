(declare (unit heuristictest))
(declare (uses parse-input dog))
(declare (uses simulate))
(declare (uses heuristic))
(use test)
;;(require-library parse-input dog simulate heuristic)
(define world-test-1
 (string->world
  "######
#. *R#
#  \\.#
#\\ * #
L  .\\#
######"))

(define world-test-2
 (string->world
  "######
#. * #
#  \\R#
#\\ * #
L  .\\#
######"))

(define world-test-3
 (string->world
  "######
#. * #
#  R #
#\\ * #
L  .\\#
######"))


(define heuristictestworld1
 (dry-world
  '#(#(wall rock earth empty wall)
     #(wall hug robot empty wall)
     #(wall wall wall wall wall))))

(define heuristictestworld2
 (dry-world
  '#(#(wall rock earth empty wall)
     #(wall robot hug empty wall)
     #(wall wall wall wall wall))))

(define heuristictestworld3
 (dry-world
  '#(#(wall rock earth empty robot)
     #(wall wall hug empty wall)
     #(wall wall wall wall wall))))

(define heuristictestworld4
 (dry-world
  '#(#(wall rock earth empty robot)
     #(wall wall wall empty wall)
     #(wall wall wall wall wall))))

(define heuristictestworld5
 (dry-world
  '#(#(hug rock earth empty robot)
     #(wall wall wall empty hug)
     #(wall wall wall wall wall))))

(define heuristictestworldDead
  (simulate (move-robot  
	     (dry-world
	      '#(#(wall rock earth hug wall)
		 #(wall empty empty rock wall)
		 #(wall empty robot empty wall)
		 #(wall wall wall wall wall)))
	     'left))
)
(define heuristictestworldNoHugsNotEscaped
  (dry-world
   '#(#(wall rock earth rock wall)
      #(wall empty empty rock wall)
      #(wall empty robot open-lift wall)
      #(wall wall wall wall wall)))
)
(define heuristictestworldNoHugsEscaped
  (dry-world
   '#(#(wall rock earth rock wall)
      #(wall empty empty rock wall)
      #(wall empty robot empty wall)
      #(wall wall wall wall wall)))
)



(test-group "find-the-robot"
	    ;;It is not Zoidbergs turn
	    (test (list 2 1) (find-robot heuristictestworld1))
	    (test (list 1 1) (find-robot heuristictestworld2))
)
(test-group "find-the-hug"
	    (test (list (list 1 1)) (find-hugs heuristictestworld1))
	    (test (list (list 2 1)) (find-hugs heuristictestworld2))
)
(test-group "dist-to-hug-tests"
	    (test 1 (manhattan-dist-to-hug heuristictestworld1))
	    (test 1 (manhattan-dist-to-hug heuristictestworld2))
	    (test 3 (manhattan-dist-to-hug heuristictestworld3))
	    (test 0 (manhattan-dist-to-hug heuristictestworld4))
	    (test 1 (manhattan-dist-to-hug heuristictestworld5))
	    (test 1 (manhattan-dist-to-hug world-test-2))
	    (test 2 (manhattan-dist-to-hug world-test-1))
)
(test-group "floyd-dist-to-hug-tests"
	    (test 1 (floyd-dist-to-hug (hobofloydwarshall (world-board heuristictestworld1)) heuristictestworld1))
	    (test 1.0 (floyd-dist-to-hug (hobofloydwarshall (world-board heuristictestworld2)) heuristictestworld2))
	    (test 3.0 (floyd-dist-to-hug (hobofloydwarshall (world-board heuristictestworld3)) heuristictestworld3))
	    (test 0.0 (floyd-dist-to-hug (hobofloydwarshall (world-board heuristictestworld4)) heuristictestworld4))
	    (test 1 (floyd-dist-to-hug (hobofloydwarshall (world-board heuristictestworld5)) heuristictestworld5))
	    (test 1.0 (floyd-dist-to-hug (hobofloydwarshall (world-board world-test-2)) world-test-2))
	    (test 2.0 (floyd-dist-to-hug (hobofloydwarshall (world-board world-test-1)) world-test-1))
)

(define simple-world-test-1
 (string->world
  "#. *R#
## \\.#
######"))
(define hfwswt1 (hobofloydwarshall (world-board simple-world-test-1)))
(test-group "floydwarshall"
	    (test 0 (path-cost 0 0 0 0 hfwswt1 (world-board simple-world-test-1)))
	    (test 0 (path-cost 1 1 1 1 hfwswt1 (world-board simple-world-test-1)))
	    (test 0 (path-cost 1 1 1 1 hfwswt1 (world-board simple-world-test-1)))
	    (test 1 (path-cost 0 0 1 0 hfwswt1 (world-board simple-world-test-1)))
	    (test 'empty (board-ref (world-board simple-world-test-1) 2 0))
	    (test #t (passable? (world-board simple-world-test-1) 2 0)) 
	    (test #t (passable? (world-board simple-world-test-1) 1 0)) 
	    (test #f (passable? (world-board simple-world-test-1) 3 0)) 
	    (test 1 (path-cost 1 0 2 0 hfwswt1 (world-board simple-world-test-1)))
	    (test +inf.0 (path-cost 2 0 3 0 hfwswt1 (world-board simple-world-test-1)))
	    (test +inf.0 (path-cost 1 0 3 0 hfwswt1 (world-board simple-world-test-1)))
	    (test 2.0 (path-cost 1 0 2 1 hfwswt1 (world-board simple-world-test-1)))
)
(test-group "score-world"
	    (test #t (number? (score-world 1 (list ) heuristictestworld1)))
	    (test 1 (- (score-world 1 (list ) heuristictestworld1)
		  (score-world 1 (list 'up) heuristictestworld1))
		  )
	    (test 1 (- (score-world 1 (list ) heuristictestworld1)
		  (score-world 1 (list 'left) heuristictestworld1))
		  )
	    (test +inf.0 (heuristic-world (score-world 1 (list ) heuristictestworldDead) 1 (list ) heuristictestworldDead))
	    (test 75 (score-world 1 (list ) heuristictestworldNoHugsEscaped))
	    (test 25 (score-world 1 (list ) heuristictestworldNoHugsNotEscaped))
	    (test 50 (score-world 1 (list 'abort) heuristictestworldNoHugsNotEscaped))
	    (test 0 (score-world 3 (list ) world-test-1))
	    (test -1 (score-world 3 (list 'up) world-test-2))
	    (test 24 (score-world 3 (list 'left) world-test-3))
	    (test 3 (manhattan-dist-to-hug world-test-3))
	    (test 2.2 (fairly-simple-heuristic-world
		       (score-world 3 (list ') world-test-1)
		       3 (list ) world-test-1))
	    (test 2.1 (fairly-simple-heuristic-world 
		       (score-world 3 (list 'up) world-test-2)
		       3 (list 'up) world-test-2))
	    (test -20.7 (fairly-simple-heuristic-world 
			 (score-world 3 (list 'left) world-test-3)
			 3 (list 'left) world-test-3))
	    (test 2 (very-simple-heuristic-world (score-world 3 (list ) world-test-1) 3 (list ) world-test-1))
	    (test 2 (very-simple-heuristic-world (score-world 3 (list 'up) world-test-2) 3 (list 'up) world-test-2))
	    (test -21 (very-simple-heuristic-world (score-world 3 (list 'left) world-test-3) 3 (list 'left) world-test-3))

)
