;// AGENT


(defmodule AGENT (import MAIN ?ALL)(export ?ALL))

(deftemplate K-cell
  (slot sound (allowed-values yes no unknown) (default unknown))
  (slot pos-r)
  (slot pos-c)
  (slot contains (allowed-values empty wall parking personseated personstanding unknown)) ;a che serve contain person??
  (slot injured (allowed-values yes no unknown))
  (slot discovered)
  (slot checked)
  (slot clear)
)

(deftemplate K-agent
  (slot step)
  (slot time)
  (slot pos-r)
  (slot pos-c)
  (slot direction)
  (slot loaded)
)

(deftemplate K-person
  (slot step)
  (slot time)
  (slot pos-r)
  (slot pos-c)
)


(deftemplate offset-around
  (slot direction)
  (slot position)
  (slot offset-r)
  (slot offset-c)
)


(deftemplate goal
  (slot ident)
  (slot priority)
  (slot action)
  (slot status )
)

; sono i fatti di cui è formato un piano che verrano poi convertite in exec
(deftemplate plan-action
  (slot plan-step)
  (slot action  (allowed-values Forward Turnright Turnleft Wait 
                                      LoadMeal LoadPill LoadDessert 
                                      DeliveryMeal DeliveryPill DeliveryDessert 
                                      CleanTable EmptyRobot ReleaseTrash CheckId 
                                      Inform Done))
  (slot param1)
  (slot param2)
  (slot param3)
)

(deftemplate next-left
  (slot direction)
  (slot left)
)

(deftemplate next-right
  (slot direction)
  (slot right)
)


; step dell'ultima percezione esaminata
(deftemplate last-perc (slot step))
(deftemplate last-perc-vision (slot step))
(deftemplate last-perc-drill (slot step))
(deftemplate last-perc-acoustic (slot step))
(deftemplate exec-mode (slot step))

; Ci dice se l'inizializzazione dell'agente è conclusa
(deftemplate init-agent (slot done (allowed-values yes no)))

; Contiene condizioni particolari che si possono verificare in corsa
(deftemplate special-condition (slot bumped (allowed-values yes no)))

; Serve per ricordarsi qual è il prossimo modulo da attivare
(deftemplate go (slot module (allowed-values perception deliberation reasoning action none)))


(deffacts initial-fact-agent
  (last-perc (step -1))
  (last-perc-vision (step -1))
  (last-perc-acoustic (step -1))
  (last-perc-drill (step -1))
)


(deffacts offset-around
  (offset-around (direction north) (position forward) (offset-r 1) (offset-c 0))
  (offset-around (direction south) (position forward) (offset-r -1) (offset-c 0))
  (offset-around (direction east)  (position forward) (offset-r 0) (offset-c 1))
  (offset-around (direction west)  (position forward) (offset-r 0) (offset-c -1))
  (offset-around (direction north) (position forward-left) (offset-r 1) (offset-c -1))
  (offset-around (direction south) (position forward-left) (offset-r -1) (offset-c 1))
  (offset-around (direction east)  (position forward-left) (offset-r 1) (offset-c 1))
  (offset-around (direction west)  (position forward-left) (offset-r -1) (offset-c -1))
  (offset-around (direction north) (position forward-right) (offset-r 1) (offset-c 1))
  (offset-around (direction south) (position forward-right) (offset-r -1) (offset-c -1))
  (offset-around (direction east)  (position forward-right) (offset-r -1) (offset-c 1))
  (offset-around (direction west)  (position forward-right) (offset-r 1) (offset-c -1))
  (offset-around (direction north) (position left) (offset-r 0) (offset-c -1))
  (offset-around (direction south) (position left) (offset-r 0) (offset-c 1))
  (offset-around (direction east)  (position left) (offset-r 1) (offset-c 0))
  (offset-around (direction west)  (position left) (offset-r -1) (offset-c 0))
  (offset-around (direction north) (position behind-left) (offset-r -1) (offset-c -1))
  (offset-around (direction south) (position behind-left) (offset-r 1) (offset-c 1))
  (offset-around (direction east)  (position behind-left) (offset-r 1) (offset-c -1))
  (offset-around (direction west)  (position behind-left) (offset-r -1) (offset-c 1))
  (offset-around (direction north) (position behind) (offset-r -1) (offset-c 0))
  (offset-around (direction south) (position behind) (offset-r 1) (offset-c 0))
  (offset-around (direction east)  (position behind) (offset-r 0) (offset-c -1))
  (offset-around (direction west)  (position behind) (offset-r 0) (offset-c 1))
  (offset-around (direction north) (position behind-right) (offset-r -1) (offset-c 1))
  (offset-around (direction south) (position behind-right) (offset-r 1) (offset-c -1))
  (offset-around (direction east)  (position behind-right) (offset-r -1) (offset-c -1))
  (offset-around (direction west)  (position behind-right) (offset-r 1) (offset-c 1))
  (offset-around (direction north) (position right) (offset-r 0) (offset-c 1))
  (offset-around (direction south) (position right) (offset-r 0) (offset-c -1))
  (offset-around (direction east)  (position right) (offset-r -1) (offset-c 0))
  (offset-around (direction west)  (position right) (offset-r 1) (offset-c 0))


)

(deffacts nexts
  (next-left (direction north) (left west))
  (next-left (direction west) (left south))
  (next-left (direction south) (left east))
  (next-left (direction east) (left north))
  (next-right (direction north) (right east))
  (next-right (direction east) (right south))
  (next-right (direction south) (right west))
  (next-right (direction west) (right north))
)


;  ---------------------------------------------
;  --- Regole iniziali per creare la mappa   ---
;  ---------------------------------------------

;(defrule  beginagent_kcell_no_injuried
;    (declare (salience 11))
;    (status (step 0))
;    (not (init-agent (done yes)))
;    (not (exec (step 0)))
;    (init_cell (pos-r ?r) (pos-c ?c) (contains ?x&outdoor|wall|empty|gate))

;=>
;   (assert (K-cell (pos-r ?r) (pos-c ?c) (contains ?x) (injured no)))
;)

;(defrule  beginagent_kcell_maybe_injuried
;    (declare (salience 11))
;    (status (step 0))
;    (not (init-agent (done yes)))
;    (not (exec (step 0)))
;    (init_cell (pos-r ?r) (pos-c ?c) (contains ?x&debris|unknown))

;=>
;   (assert (K-cell (pos-r ?r) (pos-c ?c) (contains ?x) (injured unknown)))
;)



(defrule  beginagent_position

    (declare (salience 10))

    (status (step 0))
    (not (init-agent (done yes)))
    (not (exec (step 0)))
    (initial_agentposition (pos-r ?r) (pos-c ?c) (direction ?d))
=>
    (assert
      (K-agent
        (step 0)
        (time 0)
        (pos-r ?r)
        (pos-c ?c)
        (direction ?d)
        (loaded no)
      )
      (init-agent (done yes))
   )
)




; ;  -----------------------------------------------------
; ;  --- Regole per gestire l'attivazione dei moduli   ---
; ;  -----------------------------------------------------


(defrule first-module
  (declare (salience 9))
  (init-agent (done yes))
  (not (go (module ?)))
  =>
  (assert (go (module perception)))
)

(defrule go-perception
  (declare (salience 5))
  ?f <- (go (module perception))
  =>
  (modify ?f (module reasoning))
  (focus PERCEPTION)
)

(defrule go-reasoning
  (declare (salience 5))
  ?f <- (go (module reasoning))
  =>
  (modify ?f (module action))
  (focus REASONING)
)

(defrule go-action
  (declare (salience 5))
  ?f <- (go (module action))
  =>
  (modify ?f (module none))
  (focus ACTION)
)


; ;  ------------------------------------------------
;  --- Regole da eseguire alla fine dell'agent  ---
;  ------------------------------------------------

; Esegue l'azione dello step corrente, lasciando il controllo al main

(defrule exec_act
    (declare (salience 0))
    (status (step ?i))
    (exec (step ?i))
    ?go <- (go (module none))
  =>
    (retract ?go)
    (pop-focus)
)

; L'agent non sa cosa fare. Halt per evitare di far crashare CLIPS
(defrule nothing-to-do
  (declare (salience -1000))
  =>
  (printout t "Don't know what to do")
  (assert (clips-monitor stop))
  (halt)
)




