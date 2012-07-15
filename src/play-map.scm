(declare (uses parse-input))
(declare (uses search))
(declare (uses heuristic))
(declare (uses simulate))
(use list-utils sequences vector-lib)
(let* ((w (file->world (car (command-line-arguments))))
       (board (world-board w))
       (initialhugs (count-hugs w))
       (wheight (board-height board))
       (wwidth  (board-width board))
       (themoves (reverse (vector-ref (fuckerquest-test  w (+ 250 (* 3 (*  wwidth))) 3) 2))))
  (display w)
  (foldl (lambda (s m)
	   ;;ouput the list of murh costs
	   (map (lambda (possible-move)
		  (let* ((post-move (move-robot s possible-move))
			 (newworld (if (eq? #f post-move)
				       #f
				       (simulate (move-robot s possible-move)))))
		    (display possible-move) 
		    (display ":")
		    ;;Hack doesn't look @ path so far right now but whatever
		    (if (eq? #f newworld)
			(display "not valid")
			(display (heuristic-world initialhugs (list ) newworld)))
		    (display "\n")))
		moves)
	   
	   (cond
	    ((eq? m 'wait)
	     (let ((r (simulate s)))
	       (display r)
	       r))
	    ((eq? m 'abort)
	     (display s)
	     s)
	    (else
	     (let ((r (simulate (move-robot s m))))
	       (display "i-am-dead?: ")
	       (display (i-am-dead? r))
	       (display "\n")
	       (display r)
	       r))))
	 w
	 themoves)
  (display "\n")
  (display (output-moves (reverse themoves)))
)
(display "\n")
