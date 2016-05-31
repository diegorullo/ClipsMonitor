;; *************************************
;; *************************************
;; MODULO ENV
;;
;; *************************************


(defmodule ENV (import MAIN ?ALL)(export ?ALL))





(deftemplate cell  
        (slot step) ;  Rescue
        (slot time) ;  Rescue
        (slot pos-r) 
        (slot pos-c) 
        (slot contains (allowed-values robot wall Robot Wall PersonSeated PersonStanding  
                                                  Empty Parking Table Seat TrashBasket
                                                  DessertDispenser PillDispenser MealDispenser))
        (slot previous)

)


(deftemplate agentstatus
  (slot step)
  (slot time)
  (slot pos-r)
  (slot pos-c)
  (slot direction)
  ;(slot loaded) ; sostituire con content (multislot)
	(multislot content)
        (slot free)
        (slot waste)
)

(deftemplate agentstatusdisplayed 
	(slot step)
        (slot time) 
	(slot pos-r) 
	(slot pos-c) 
	(slot direction) 
	(slot loaded)
)

(deftemplate tablestatus	
	(slot step)
        (slot time)
	(slot pos-r) 
	(slot pos-c) 
	(slot clean (allowed-values yes no stop))
	(slot occupied-by)
        )

(deftemplate mealstatus	;// 
	(slot step)
        (slot time)			;// tempo corrente
	(slot arrivaltime)	;// momento in cui é arrivata l'ordinazione
	(slot requested-by)	;// 
	(slot type)
        (slot tpos-r)
        (slot tpos-c)
        (slot delivered)
        (slot delivertime)
        (slot answer (allowed-values pending yes wait reject))	
)

(deftemplate dessertstatus	;// 
	(slot step)
        (slot time)			;// tempo corrente
	(slot arrivaltime)	;// momento in cui é arrivata l'ordinazione
	(slot requested-by)	;// 
        (slot tpos-r)
        (slot tpos-c)
        (slot delivered)
        (slot answer (allowed-values pending yes wait reject))	
)

(deftemplate pillstatus	;// 
	(slot step)
        (slot time)			;// tempo corrente
	(slot for)	;// 
        (slot delivered)
        (slot when (allowed-values before after no))	
)

(deftemplate initpersonpos	;// informazioni sulla posizione degli anziani
	(slot ident)
	(slot type (allowed-values staff patient))
        (slot pos-r)
	(slot pos-c)			
)

(deftemplate personstatus 	;// informazioni sulla posizione delle persone
  (slot step)
  (slot time)
  (slot ident)
  (slot pos-r)
  (slot pos-c)
  (slot activity)   ;// activity out se soccorritore � outdoor, stand se in piedi, oppure path
  (slot move)
)

(deftemplate staffstatus 	;// informazioni sulla posizione delle persone
	(slot step)
        (slot time)
	(slot ident)
	(slot pos-r)
	(slot pos-c)
	(slot activity)   ;// activity  stand se in piedi, oppure path  		
        (slot move)			
)

(deftemplate personmove		;// modella i movimenti delle persone. l'environment deve tenere conto dell'interazione di tanti agenti. Il mondo cambia sia per le azioni del robot, si per le azioni degli operatori. Il modulo environment deve gestire le interazioni.
  (slot step)
  (slot ident)
  (slot path-id)
)

(deftemplate event   		;// gli eventi sono le richieste meal dessert
	(slot step)
	(slot type (allowed-values meal dessert))
	(slot person)
	
)

(deftemplate pillrepository
        (slot id)
        (multislot content))

;// DEFRULE

;//imposta il valore iniziale di ciascuna cella 


(defrule create1
  (declare (salience 28))
  ?f<-(create-map)
  =>
  (load-facts "RealMap.txt")
  (assert
   (create-real-map)
   (create-init-map)
   (create-initial-setting)
   (create-history)
  )
  (retract ?f)
)



(defrule  create2
  (declare (salience 27))
  (create-real-map)
  (real_cell (pos-r ?r) (pos-c ?c) (contains ?x) )
=>
  (assert
    (cell
      (step 0)
      (time 0)
      (pos-r ?r)
      (pos-c ?c)
      (contains ?x)
      (previous ?x)
    )
  )
)

(defrule creation12	
     (declare (salience 25))
        (create-map)
?f1 <-  (cell (pos-r ?r) (pos-c ?c) (contains Parking))
        
=>
     (modify ?f1 (contains Robot) (previous Parking))
     (assert (agentstatus (time 0) (step 0) (pos-r ?r) (pos-c ?c) (direction north)
                          (free 2) (waste no))
             (agentstatusdisplayed (time 0) (step 0) (pos-r ?r) (pos-c ?c) (direction north)
                          (loaded no))
             (pillrepository (id PD1) (content)))
            
)



(defrule  create3-2
  (declare (salience 25))
  (create-init-map)
; [adeguamentoAL]
;  (real_cell (pos-r ?r) (pos-c ?c) (contains ?x&wall|gate|debris|seat|table|dessertdispenser|parking|mealdispenser|trashbasket|pilldispenser))
 (real_cell (pos-r ?r) (pos-c ?c) (contains ?x&Wall|Parking|Table|Seat|TrashBasket|DessertDispenser|PillDispenser|MealDispenser))

  =>
  (assert (init_cell (pos-r ?r) (pos-c ?c) (contains ?x)))
)


; Questa regola inzializza le celle empty. Per costruzione del mondo iniziale le celle
; empty sono solo celle interne all'ambiente, se fossero vicino all'esterno sarebbero
; di tipo gate



(defrule  create3-3
  (declare (salience 25))
  (create-init-map)
  (real_cell (pos-r ?r) (pos-c ?c) (contains Empty))
=>
  (assert (init_cell (pos-r ?r) (pos-c ?c) (contains unknown)))
)



(defrule  create3-4
  (declare (salience 24))
  (create-init-map)
; [adeguamentoAL]
;  (real_cell (pos-r ?r) (pos-c ?c) (contains ?x&wall|gate|debris|seat|table|dessertdispenser|parking|mealdispenser|trashbasket|pilldispenser))
   (real_cell (pos-r ?r) (pos-c ?c) (contains ?x&Wall|Parking|Table|Seat|TrashBasket|DessertDispenser|PillDispenser|MealDispenser))
  (not (init_cell (pos-r ?r) (pos-c ?c)))
  =>
  (assert (init_cell (pos-r ?r) (pos-c ?c) (contains unknown)))
)



(defrule creation4
  (declare (salience 23))
  ?f1<-	(create-history)
  =>
  (load-facts "history.txt")
  (retract ?f1)
)

(defrule creation31	
	(declare (salience 23))
        (create-initial-setting)
        (initpersonpos (ident ?p) (type patient) (pos-r ?r) (pos-c ?c))
=>
   	(assert (personstatus (step 0) (time 0) (ident ?p) 
                              (pos-r ?r) (pos-c ?c)
                              (activity seated) (move NA)))
)

(defrule creation32	
	(declare (salience 23))
        (create-initial-setting)
        (initpersonpos (ident ?p) (type staff) (pos-r ?r) (pos-c ?c))
?f1<-   (cell (pos-r ?r) (pos-c ?c) (contains Empty))
=>
   	(assert (staffstatus (step 0) (time 0) (ident ?p) 
                              (pos-r ?r) (pos-c ?c)
                              (activity stand) (move NA)))
        (modify ?f1 (contains PersonStanding) (previous Empty))
)

(defrule creation331
      (declare (salience 23))
      (create-initial-setting)
      (prescription (patient ?id) (pills ?pills&~no))
      (not (pillstatus (step 0) (for ?id)))
?f<-  (pillrepository (content $?cont))
=> 
      (assert (pillstatus (step 0) (time 0) (for ?id) (delivered no) 
                          (when ?pills)))
      (modify ?f (content (insert$ $?cont 1 ?id)))
)

(defrule creation332
      (declare (salience 23))
      (create-initial-setting)
      (prescription (patient ?id) (pills no))
      (not (pillstatus (step 0) (for ?id)))
?f<-  (pillrepository (content $?cont))
=> 
      (assert (pillstatus (step 0) (time 0) (for ?id) (delivered no) 
                          (when no)))
)


(defrule creation5
  (declare (salience 21))
  ?f1 <-   (create-initial-setting)
  ?f2 <-   (create-real-map)
  ?f4 <-   (create-init-map)
  (initial_agentposition
    (pos-r ?r)
    (pos-c ?c)
    (direction ?d)
  )
  ?f3 <- (cell
     (step 0)
     (pos-r ?r)
     (pos-c ?c)
     (contains ?xx)
     )
  =>
  (modify ?f3 (contains Robot) (previous ?xx))
  (assert
    (agentstatus
      (step 0)
      (time 0)
      (pos-r ?r)
      (pos-c ?c)
      (direction ?d)     
    )
    (agentstatusdisplayed
      (step 0)
      (time 0)
      (pos-r ?r)
      (pos-c ?c)
      (direction ?d)
      (loaded no)
    )
    (status
      (step 0)
      (time 0)
      (result no)
    )
    (penalty 0)
  )
  (retract ?f1 ?f2 ?f4)
)


;*****************************************************
;      AZIONI DI MOVIMENTO
;*****************************************************



(defrule move-north-ok1
  (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
  (exec (step ?i) (action  Forward))
  ?f1<- (agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction north))
  ?f4<- (cell (step ?i) (pos-r ?r) (pos-c ?c) (previous ?zz))
  ?f3<- (cell (step ?i) (pos-r =(+ ?r 1)) (pos-c ?c) (contains ?xx&Empty|Parking))
  =>
  (modify  ?f1 (pos-r (+ ?r 1)) (step (+ ?i 1))(time (+ ?t 1)))
  (modify  ?f2 (step (+ ?i 1))(time (+ ?t 1)))
  (modify  ?f3 (step (+ ?i 1))(time (+ ?t 1)) (contains Robot) (previous ?xx))
  (modify  ?f4 (step (+ ?i 1))(time (+ ?t 1)) (contains ?zz))
)



(defrule move-north-ok2
  (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
  (exec (step ?i) (action  Forward))
  ?f1<- (agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction north) )
  ?f4<- (cell (step ?i) (pos-r ?r) (pos-c ?c) (previous ?zz))
  ?f3<- (cell (step ?i) (pos-r =(+ ?r 1)) (pos-c ?c) (contains ?xx&Empty|Parking))
  =>
  (modify  ?f1 (pos-r (+ ?r 1)) (step (+ ?i 1))(time (+ ?t 2)))
  (modify  ?f2 (step (+ ?i 1))(time (+ ?t 2)))
  (modify  ?f3 (step (+ ?i 1))(time (+ ?t 1)) (contains Robot) (previous ?xx))
  (modify  ?f4 (step (+ ?i 1))(time (+ ?t 1)) (contains ?zz))
)



(defrule move-north-bump1
  (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
  (exec (step ?i) (action  Forward))
  ?f1<- (agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction north))
  ?f3<- (cell
          (step ?i)
          (pos-r =(+ ?r 1))
          (pos-c ?c)
; [adeguamentoAL]
;          (contains wall|debris|outdoor|seat|table|dessertdispenser|mealdispenser|trashbasket|pilldispenser)
           (contains Wall|Table|Seat|TrashBasket|DessertDispenser|PillDispenser|MealDispenser)
        )
  ?f4<- (penalty ?p)
  =>
  (modify  ?f1 (step (+ ?i 1))(time (+ ?t 10)))
  (modify  ?f2 (step (+ ?i 1))(time (+ ?t 10)))
  (modify  ?f3 (step (+ ?i 1))(time (+ ?t 10)))
  (assert
    (perc-bump
      (step (+ ?i 1))
      (time (+ ?t 10))
      (pos-r ?r)
      (pos-c ?c)
      (direction north)
      (bump yes)
    )
    (penalty (+ ?p 1000000))
 )
 (retract ?f4)
)



(defrule move-north-bump2
  (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
  (exec (step ?i) (action  Forward))
  ?f1<- (agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction north))
  ?f3<- (cell
    (step ?i)
    (pos-r =(+ ?r 1))
    (pos-c ?c)
    (contains PersonSeated|PersonStanding)
    )
    ?f4<- (penalty ?p)
  =>
  (modify  ?f1 (step (+ ?i 1))(time (+ ?t 10)))
  (modify  ?f2 (step (+ ?i 1))(time (+ ?t 10)))
  (modify  ?f3 (step (+ ?i 1))(time (+ ?t 10)))
  (assert
    (perc-bump
      (step (+ ?i 1))
      (time (+ ?t 10))
      (pos-r ?r)
      (pos-c ?c)
      (direction north)
      (bump yes)
    )
    (penalty (+ ?p 10000000))
  )
  (retract ?f4)
)



(defrule move-south-ok1
  (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
  (exec (step ?i) (action  Forward))
  ?f1<- (agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction south) )
  ?f4<- (cell (step ?i) (pos-r ?r) (pos-c ?c) (previous ?zz))
  ?f3<- (cell (step ?i) (pos-r =(- ?r 1)) (pos-c ?c) (contains ?xx&Empty|Parking))
  =>
  (modify  ?f1 (pos-r (- ?r 1)) (step (+ ?i 1))(time (+ ?t 1)))
  (modify  ?f2 (step (+ ?i 1))(time (+ ?t 1)))
  (modify  ?f3 (step (+ ?i 1))(time (+ ?t 1))(contains Robot) (previous ?xx))
  (modify  ?f4 (step (+ ?i 1))(time (+ ?t 1)) (contains ?zz))
)



(defrule move-south-ok2
  (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
  (exec (step ?i) (action  Forward))
  ?f1<- (agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction south) )
  ?f4<- (cell (step ?i) (pos-r ?r) (pos-c ?c) (previous ?zz))
  ?f3<- (cell (step ?i) (pos-r =(- ?r 1)) (pos-c ?c) (contains ?xx&Empty|Parking))
  =>
  (modify  ?f1 (pos-r (- ?r 1)) (step (+ ?i 1))(time (+ ?t 2)))
  (modify  ?f2 (step (+ ?i 1))(time (+ ?t 2)))
  (modify  ?f3 (step (+ ?i 1))(time (+ ?t 2))(contains Robot) (previous ?xx))
  (modify  ?f4 (step (+ ?i 1))(time (+ ?t 1)) (contains ?zz))
)



(defrule move-south-bump1
  (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
  (exec (step ?i) (action  Forward))
  ?f1<- (agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction south))
  ?f3<- (cell (step ?i) (pos-r =(- ?r 1)) (pos-c ?c)
; [adeguamentoAL]
;      (contains wall|debris|outdoor|seat|table|dessertdispenser|mealdispenser|trashbasket|pilldispenser))
       (contains Wall|Table|Seat|TrashBasket|DessertDispenser|PillDispenser|MealDispenser))
  ?f4<- (penalty ?p)
  =>
  (modify  ?f1 (step (+ ?i 1))(time (+ ?t 10)))
  (modify  ?f2 (step (+ ?i 1))(time (+ ?t 10)))
  (modify  ?f3 (step (+ ?i 1))(time (+ ?t 10)))
  (assert (perc-bump (step (+ ?i 1))(time (+ ?t 10))
                    (pos-r ?r) (pos-c ?c) (direction south)
                    (bump yes))
         (penalty (+ ?p 1000000))
 )
 (retract ?f4))



(defrule move-south-bump2
  (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
  (exec (step ?i) (action  Forward))
  ?f1<- (agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction south))
  ?f3<- (cell (step ?i) (pos-r =(- ?r 1)) (pos-c ?c)
      (contains PersonSeated|PersonStanding))
  ?f4<- (penalty ?p)
  =>
  (modify  ?f1 (step (+ ?i 1))(time (+ ?t 10)))
  (modify  ?f2 (step (+ ?i 1))(time (+ ?t 10)))
  (modify  ?f3 (step (+ ?i 1))(time (+ ?t 10)))
  (assert (perc-bump (step (+ ?i 1))(time (+ ?t 10))
                    (pos-r ?r) (pos-c ?c) (direction south)
                    (bump yes))
         (penalty (+ ?p 10000000))
  )
  (retract ?f4)
)



(defrule move-west-ok1
  (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
  (exec (step ?i) (action  Forward))
  ?f1<- (agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction west) )
  ?f4<- (cell (step ?i) (pos-r ?r) (pos-c ?c) (previous ?zz))
  ?f3<- (cell (step ?i) (pos-r ?r) (pos-c =(- ?c 1)) (contains ?xx&Empty|Parking))
  =>
  (modify  ?f1 (pos-c (- ?c 1)) (step (+ ?i 1))(time (+ ?t 1)))
  (modify  ?f2 (step (+ ?i 1))(time (+ ?t 1)))
  (modify  ?f3 (step (+ ?i 1))(time (+ ?t 1))(contains Robot) (previous ?xx))
  (modify  ?f4 (step (+ ?i 1))(time (+ ?t 1)) (contains ?zz))
)



(defrule move-west-ok2
  (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
  (exec (step ?i) (action  Forward))
  ?f1<- (agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction west) )
  ?f4<- (cell (step ?i) (pos-r ?r) (pos-c ?c) (previous ?zz))
  ?f3<- (cell (step ?i) (pos-r ?r) (pos-c =(- ?c 1)) (contains ?xx&Empty|Parking))
  =>
  (modify  ?f1 (pos-c (- ?c 1)) (step (+ ?i 1))(time (+ ?t 2)))
  (modify  ?f2 (step (+ ?i 1))(time (+ ?t 2)))
  (modify  ?f3 (step (+ ?i 1))(time (+ ?t 2))(contains Robot) (previous ?xx))
  (modify  ?f4 (step (+ ?i 1))(time (+ ?t 1)) (contains ?zz))
)



(defrule move-west-bump1
  (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
  (exec (step ?i) (action  Forward))
  ?f1<- (agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction west))
  ?f3<- (cell (step ?i) (pos-r ?r) (pos-c =(- ?c 1))
; [adeguamentoAL]
;     (contains wall|debris|outdoor|seat|table|dessertdispenser|mealdispenser|trashbasket|pilldispenser))
      (contains Wall|Table|Seat|TrashBasket|DessertDispenser|PillDispenser|MealDispenser))
  ?f4<- (penalty ?p)
  =>
  (modify  ?f1 (step (+ ?i 1))(time (+ ?t 10)))
  (modify  ?f2 (step (+ ?i 1))(time (+ ?t 10)))
  (modify  ?f3 (step (+ ?i 1))(time (+ ?t 10)))
  (assert (perc-bump (step (+ ?i 1))(time (+ ?t 10))
                    (pos-r ?r) (pos-c ?c) (direction west)
                    (bump yes))
         (penalty (+ ?p 1000000))
  )
  (retract ?f4)
)



(defrule move-west-bump2
  (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
  (exec (step ?i) (action  Forward))
  ?f1<- (agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction west))
  ?f3<- (cell (step ?i) (pos-r ?r) (pos-c =(- ?c 1))
      (contains PersonSeated|PersonStanding))
  ?f4<- (penalty ?p)
  =>
  (modify  ?f1 (step (+ ?i 1))(time (+ ?t 10)))
  (modify  ?f2 (step (+ ?i 1))(time (+ ?t 10)))
  (modify  ?f3 (step (+ ?i 1))(time (+ ?t 10)))
  (assert (perc-bump (step (+ ?i 1))(time (+ ?t 10))
                    (pos-r ?r) (pos-c ?c) (direction west)
                    (bump yes))
  (penalty (+ ?p 10000000))
  )
  (retract ?f4)
)



(defrule move-east-ok1
    (declare (salience 20))
    ?f2<- (status (step ?i) (time ?t))
    (exec (step ?i) (action  Forward))
    ?f1<- (agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction east) )
    ?f4<- (cell (step ?i) (pos-r ?r) (pos-c ?c) (previous ?zz))
    ?f3<- (cell (step ?i) (pos-r ?r) (pos-c =(+ ?c 1)) (contains ?xx&Empty|Parking))
  =>
    (modify  ?f1 (pos-c (+ ?c 1)) (step (+ ?i 1))(time (+ ?t 1)))
    (modify  ?f2 (step (+ ?i 1))(time (+ ?t 1)))
    (modify  ?f3 (step (+ ?i 1))(time (+ ?t 1))(contains Robot) (previous ?xx))
    (modify  ?f4 (step (+ ?i 1))(time (+ ?t 1)) (contains ?zz))
)



(defrule move-east-ok2
  (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
  (exec (step ?i) (action  Forward))
  ?f1<- (agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction east) )
  ?f4<- (cell (step ?i) (pos-r ?r) (pos-c ?c) (previous ?zz))
  ?f3<- (cell (step ?i) (pos-r ?r) (pos-c =(+ ?c 1)) (contains ?xx&Empty|Parking))
  =>
  (modify  ?f1 (pos-c (+ ?c 1)) (step (+ ?i 1))(time (+ ?t 2)))
  (modify  ?f2 (step (+ ?i 1))(time (+ ?t 2)))
  (modify  ?f3 (step (+ ?i 1))(time (+ ?t 2))(contains Robot) (previous ?xx))
  (modify  ?f4 (step (+ ?i 1))(time (+ ?t 1)) (contains ?zz))
)



(defrule move-east-bump1
  (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
  (exec (step ?i) (action  Forward))
  ?f1<- (agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction east))
  ?f3<- (cell (step ?i) (pos-r ?r) (pos-c =(+ ?c 1))
; [adeguamentoAL]
;      (contains wall|debris|outdoor|seat|table|dessertdispenser|mealdispenser|trashbasket|pilldispenser))
       (contains Wall|Table|Seat|TrashBasket|DessertDispenser|PillDispenser|MealDispenser))
  ?f4<- (penalty ?p)
  =>
  (modify  ?f1 (step (+ ?i 1))(time (+ ?t 10)))
  (modify  ?f2 (step (+ ?i 1))(time (+ ?t 10)))
  (modify  ?f3 (step (+ ?i 1))(time (+ ?t 10)))
  (assert (perc-bump (step (+ ?i 1))(time (+ ?t 10))
                    (pos-r ?r) (pos-c ?c) (direction east)
                    (bump yes))
         (penalty (+ ?p 1000000))
  )
  (retract ?f4)
)

(defrule move-east-bump2
  (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
  (exec (step ?i) (action  Forward))
  ?f1<- (agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction east))
  ?f3<- (cell (step ?i) (pos-r ?r) (pos-c =(+ ?c 1))
      (contains PersonSeated|PersonStanding))
  ?f4<- (penalty ?p)
  =>
  (modify  ?f1 (step (+ ?i 1))(time (+ ?t 10)))
  (modify  ?f2 (step (+ ?i 1))(time (+ ?t 10)))
  (modify  ?f3 (step (+ ?i 1))(time (+ ?t 10)))
  (assert (perc-bump (step (+ ?i 1))(time (+ ?t 10))
                    (pos-r ?r) (pos-c ?c) (direction east)
                    (bump yes))
         (penalty (+ ?p 10000000))
  )
  (retract ?f4)
)


(defrule turnleft11
  (declare (salience 20))
  ?f2<-	(status (step ?i) (time ?t))
  (exec (step ?i) (action  Turnleft))
  ?f1<-	(agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction west) )
  ?f3<-	(cell (step ?i) (pos-r ?r) (pos-c ?c))
  =>
  (modify ?f1 (direction south) (step (+ ?i 1)) (time (+ ?t 2)) )
  (modify ?f2 (step (+ ?i 1)) (time (+ ?t 2)) )
  (modify ?f3 (step (+ ?i 1))(time (+ ?t 2)))
)



(defrule turnleft12
  (declare (salience 20))
  ?f2<-	(status (step ?i) (time ?t))
  (exec (step ?i) (action  Turnleft))
  ?f1<-	(agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction west) )
  ?f3<-	(cell (step ?i) (pos-r ?r) (pos-c ?c))
  =>
  (modify ?f1 (direction south) (step (+ ?i 1)) (time (+ ?t 3)) )
  (modify ?f2 (step (+ ?i 1)) (time (+ ?t 3)) )
  (modify ?f3 (step (+ ?i 1))(time (+ ?t 3)))
)



(defrule turnleft21
  (declare (salience 20))
  ?f2<-	(status (step ?i) (time ?t))
  (exec (step ?i) (action  Turnleft))
  ?f1<-	(agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction south))
  ?f3<-	(cell (step ?i) (pos-r ?r) (pos-c ?c))
=>
  (modify ?f1 (direction east) (step (+ ?i 1)) (time (+ ?t 2)) )
  (modify ?f2 (step (+ ?i 1)) (time (+ ?t 2)) )
  (modify ?f3 (step (+ ?i 1))(time (+ ?t 2)))
)



(defrule turnleft22
  (declare (salience 20))
  ?f2<-	(status (step ?i) (time ?t))
  (exec (step ?i) (action  Turnleft))
  ?f1<-	(agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction south))
  ?f3<-	(cell (step ?i) (pos-r ?r) (pos-c ?c))
  =>
  (modify ?f1 (direction east) (step (+ ?i 1)) (time (+ ?t 3)) )
  (modify ?f2 (step (+ ?i 1)) (time (+ ?t 3)) )
  (modify ?f3 (step (+ ?i 1))(time (+ ?t 3)))
)



(defrule turnleft31
  (declare (salience 20))
  ?f2<-	(status (step ?i) (time ?t))
  (exec (step ?i) (action  Turnleft))
  ?f1<-	(agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction east) )
  ?f3<-	(cell (step ?i) (pos-r ?r) (pos-c ?c))
  =>
  (modify ?f1 (direction north) (step (+ ?i 1)) (time (+ ?t 2)) )
  (modify ?f2 (step (+ ?i 1)) (time (+ ?t 2)) )
  (modify ?f3 (step (+ ?i 1))(time (+ ?t 2)))
)



(defrule turnleft32
  (declare (salience 20))
  ?f2<-	(status (step ?i) (time ?t))
  (exec (step ?i) (action  Turnleft))
  ?f1<-	(agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction east) )
  ?f3<-	(cell (step ?i) (pos-r ?r) (pos-c ?c))
  =>
  (modify ?f1 (direction north) (step (+ ?i 1)) (time (+ ?t 3)) )
  (modify ?f2 (step (+ ?i 1)) (time (+ ?t 3)) )
  (modify ?f3 (step (+ ?i 1))(time (+ ?t 3)))
)



(defrule turnleft41
  (declare (salience 20))
  ?f2<-	(status (step ?i) (time ?t))
  (exec (step ?i) (action  Turnleft))
  ?f1<-	(agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction north) )
  ?f3<-	(cell (step ?i) (pos-r ?r) (pos-c ?c))
  =>
  (modify ?f1 (direction west) (step (+ ?i 1)) (time (+ ?t 2)) )
  (modify ?f2 (step (+ ?i 1)) (time (+ ?t 2)) )
  (modify ?f3 (step (+ ?i 1))(time (+ ?t 2)))
)



(defrule turnleft42
  (declare (salience 20))
  ?f2<-	(status (step ?i) (time ?t))
  (exec (step ?i) (action  Turnleft))
  ?f1<-	(agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction north) )
  ?f3<-	(cell (step ?i) (pos-r ?r) (pos-c ?c))
  =>
  (modify ?f1 (direction west) (step (+ ?i 1)) (time (+ ?t 3)) )
  (modify ?f2 (step (+ ?i 1)) (time (+ ?t 3)) )
  (modify ?f3 (step (+ ?i 1))(time (+ ?t 3)))
)



(defrule turnright11
  (declare (salience 20))
  ?f2<-	(status (step ?i) (time ?t))
  (exec (step ?i) (action  Turnright))
  ?f1<-	(agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction west))
  ?f3<-	(cell (step ?i) (pos-r ?r) (pos-c ?c))
  =>
  (modify ?f1 (direction north) (step (+ ?i 1)) (time (+ ?t 2)) )
  (modify ?f2 (step (+ ?i 1)) (time (+ ?t 2)) )
  (modify ?f3 (step (+ ?i 1))(time (+ ?t 2)))
)



(defrule turnright12
  (declare (salience 20))
  ?f2<-	(status (step ?i) (time ?t))
  (exec (step ?i) (action  Turnright))
  ?f1<-	(agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction west) )
  ?f3<-	(cell (step ?i) (pos-r ?r) (pos-c ?c))
  =>
  (modify ?f1 (direction north) (step (+ ?i 1)) (time (+ ?t 3)) )
  (modify ?f2 (step (+ ?i 1)) (time (+ ?t 3)) )
  (modify ?f3 (step (+ ?i 1))(time (+ ?t 3)))
)



(defrule turnright21
  (declare (salience 20))
  ?f2<-	(status (step ?i) (time ?t))
  (exec (step ?i) (action  Turnright))
  ?f1<-	(agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction south))
  ?f3<-	(cell (step ?i) (pos-r ?r) (pos-c ?c))
  =>
  (modify ?f1 (direction west) (step (+ ?i 1)) (time (+ ?t 2)) )
  (modify ?f2 (step (+ ?i 1)) (time (+ ?t 2)) )
  (modify ?f3 (step (+ ?i 1))(time (+ ?t 2)))
)



(defrule turnright22
  (declare (salience 20))
  ?f2<-	(status (step ?i) (time ?t))
  (exec (step ?i) (action  Turnright))
  ?f1<-	(agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction south))
  ?f3<-	(cell (step ?i) (pos-r ?r) (pos-c ?c))
  =>
  (modify ?f1 (direction west) (step (+ ?i 1)) (time (+ ?t 3)) )
  (modify ?f2 (step (+ ?i 1)) (time (+ ?t 3)) )
  (modify ?f3 (step (+ ?i 1))(time (+ ?t 3)))
)



(defrule turnright31
  (declare (salience 20))
  ?f2<-	(status (step ?i) (time ?t))
  (exec (step ?i) (action  Turnright))
  ?f1<-	(agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction east))
  ?f3<-	(cell (step ?i) (pos-r ?r) (pos-c ?c))
  =>
  (modify ?f1 (direction south) (step (+ ?i 1)) (time (+ ?t 2)) )
  (modify ?f2 (step (+ ?i 1)) (time (+ ?t 2)) )
  (modify ?f3 (step (+ ?i 1))(time (+ ?t 2)))
)



(defrule turnright32
  (declare (salience 20))
  ?f2<-	(status (step ?i) (time ?t))
  (exec (step ?i) (action  Turnright))
  ?f1<-	(agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction east) )
  ?f3<-	(cell (step ?i) (pos-r ?r) (pos-c ?c))
  =>
  (modify ?f1 (direction south) (step (+ ?i 1)) (time (+ ?t 3)) )
  (modify ?f2 (step (+ ?i 1)) (time (+ ?t 3)) )
  (modify ?f3 (step (+ ?i 1))(time (+ ?t 3)))
)



(defrule turnright41
  (declare (salience 20))
  ?f2<-	(status (step ?i) (time ?t))
  (exec (step ?i) (action  Turnright))
  ?f1<-	(agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction north))
  ?f3<-	(cell (step ?i) (pos-r ?r) (pos-c ?c))
  =>
  (modify ?f1 (direction east) (step (+ ?i 1)) (time (+ ?t 2)) )
  (modify ?f2 (step (+ ?i 1)) (time (+ ?t 2)) )
  (modify ?f3 (step (+ ?i 1))(time (+ ?t 2)))
)



(defrule turnright42
  (declare (salience 20))
  ?f2<-	(status (step ?i) (time ?t))
  (exec (step ?i) (action  Turnright))
  ?f1<-	(agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction north) )
  ?f3<-	(cell (step ?i) (pos-r ?r) (pos-c ?c))
  =>
  (modify ?f1 (direction east) (step (+ ?i 1)) (time (+ ?t 3)) )
  (modify ?f2 (step (+ ?i 1)) (time (+ ?t 3)) )
  (modify ?f3 (step (+ ?i 1))(time (+ ?t 3)))
)


(defrule inform-clear-ok
(declare (salience 20))
?f2<- (status (step ?i) (time ?t))
(exec (step ?i) (action  Inform) (param1 ?x) (param2 ?y))
?f3<- (cell (step ?i) (pos-r ?x) (pos-c ?y) (contains Empty))
?f1<- (agentstatus (step ?i))
=>
 (modify ?f1  (step (+ ?i 1)) (time (+ ?t 1)))
 (modify ?f3 (step (+ ?i 1)) (time (+ ?t 1)) )
 (modify ?f2 (step (+ ?i 1)) (time (+ ?t 1)))
 )



(defrule inform-clear-KO
  (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
  (exec (step ?i) (action  Inform) (param1 ?x) (param2 ?y) )
  ?f3<- (cell (step ?i) (pos-r ?x) (pos-c ?y) (contains ~Empty))
  ?f1<- (agentstatus (step ?i))
  ?f4<- (penalty ?p)
  =>
  (modify ?f1  (step (+ ?i 1)) (time (+ ?t 1)))
  (modify ?f3 (step (+ ?i 1)) (time (+ ?t 1)))
  (modify ?f2 (step (+ ?i 1)) (time (+ ?t 1)))
  (assert (penalty (+ ?p 200000)))
  (retract ?f4)
 )


;******************************
;          DONE
;******************************


(defrule done-no-gate
  (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
  (exec (step ?i) (action  Done))
  (agentstatus (step ?i) (pos-r ?r) (pos-c ?c))
  (cell (step ?i)(pos-r ?r) (pos-c ?c) (previous ~Parking))
  ?f1<- (penalty ?p)
  =>
  (assert (penalty (+ ?p 100000)))
  (retract ?f1)
  (modify ?f2 (step (+ ?i 1)) (time (+ ?t 1)) (result done))
  (pop-focus)
)



(defrule done-in-gate
  (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
  (exec (step ?i) (action  Done))
  (agentstatus (step ?i) (pos-r ?r) (pos-c ?c))
  (cell (step ?i) (pos-r ?r) (pos-c ?c) (previous Parking))
  =>
  (modify ?f2 (step (+ ?i 1)) (time (+ ?t 1)) (result done))
  (pop-focus)
)


;******************************
;          WAIT
;******************************



(defrule wait
  (declare (salience 20))
  ?f2<-	(status (time ?t) (step ?i))
  (exec (step ?i) (action Wait))
  ?f1<-	(agentstatus (step ?i) (time ?t))
  =>
  (modify ?f2 (step (+ ?i 1)) (time (+ ?t 5)))
  (modify ?f1 (step (+ ?i 1)) (time (+ ?t 5)))
)


(defrule Evolution-empty-no-clear
(declare (salience 15))
(status (time ?t) (step ?i))
?f1<-	(cell (step = (- ?i 1)) (time ?tt) (pos-r ?x) (pos-c ?y) (contains Empty) )
(not (cell (step ?i) (pos-r ?x) (pos-c ?y)))
?f2<-	(penalty ?p)
=>
(modify ?f1 (time ?t) (step ?i))
(assert (penalty (+ ?p (* (- ?t ?tt) 1))))
(retract ?f2)
)



(defrule Evolution-empty-clear
(declare (salience 15))
(status (time ?t) (step ?i))
?f1<-	(cell (step = (- ?i 1)) (time ?tt) (pos-r ?x) (pos-c ?y) (contains Empty) )
(not (cell (step ?i) (pos-r ?x) (pos-c ?y)))
=>
(modify ?f1 (time ?t) (step ?i))
)
;// evoluzione per altre celle



(defrule Evolution-generic-cell
(declare (salience 15))
(status (time ?t) (step ?i))
?f1<-	(cell (step = (- ?i 1)) (time ?tt) (pos-r ?x) (pos-c ?y)
; [adeguamentoAL]
    (contains Wall|Parking|PersonSeated|PersonStanding|Robot|Seat))
(not (cell (step ?i) (pos-r ?x) (pos-c ?y)))
=>
(modify ?f1 (time ?t) (step ?i))
)



; GENERA MOVIMENTI PERSONE
; Persona ferma non arriva comando di muoversi



(defrule MovePerson1
  (declare (salience 9))
  (status (step ?i) (time ?t))
  ?f1<-	(personstatus (step =(- ?i 1)) (ident ?id) (activity out|stand))
  (not (personmove (step ?i) (ident ?id)))
=>
  (modify ?f1 (time ?t) (step ?i))
)

;Persona ferma ma arriva comando di muoversi



(defrule MovePerson2
  (declare (salience 10))
  (status (step ?i) (time ?t))
  ?f1 <- (personstatus (step =(- ?i 1)) (ident ?id) (activity out|stand))
  ?f2 <- (personmove (step  ?i) (ident ?id) (path-id ?m))
=>
  (modify  ?f1 (time ?t) (step ?i) (activity ?m) (move 0))
  (retract ?f2)
)
;// La cella in cui deve  andare la persona � libera. Persona si muove.
;//



(defrule MovePerson3
  (declare (salience 10))
  (status (step ?i) (time ?t))
  ?f1 <- (personstatus (step =(- ?i 1)) (ident ?id) (pos-r ?x) (pos-c ?y)
              (activity ?m&~out&~stand) (move ?s))
  ?f4 <- (cell (step ?i) (pos-r ?x) (pos-c ?y) (previous ?w))
  ?f3 <- (move-path ?m =(+ ?s 1) ?id ?r ?c)
  ?f2 <- (cell (step ?i) (pos-r ?r) (pos-c ?c) (contains ?xx&Empty|Parking))
=>
   (modify  ?f1  (step ?i) (time ?t) (pos-r ?r) (pos-c ?c) (move (+ ?s 1)))
   (modify ?f2 (contains PersonStanding) (previous ?xx))
   (modify ?f4 (contains ?w))
   (retract ?f3)
)
;// La cella in cui deve  andare la persona � occupata dal robot. Persona non si muove



(defrule MovePerson_wait1
(declare (salience 10))
(status (step ?i) (time ?t))
?f1<-	(personstatus (step =(- ?i 1)) (time ?tt) (ident ?id) (activity ?m&~out&~stand) (move ?s))
(move-path ?m =(+ ?s 1) ?id ?r ?c)
(cell (step ?i) (pos-r ?r) (pos-c ?c) (contains Robot))
?f2<-	(penalty ?p)
=>
(modify  ?f1 (time ?t) (step ?i))
(assert (penalty (+ ?p (* (- ?t ?tt) 5))))
(retract ?f2)
;	(printout t " - penalit� aumentate" ?id " attende che il robot si sposti)" crlf)
)
;// La cella in cui deve  andare la persona non � libera (ma non � occupata da robot). Persona non si muove



(defrule MovePerson_wait2
  (declare (salience 10))
  (status (step ?i) (time ?t))
  ?f1<-	(personstatus (step =(- ?i 1)) (time ?tt) (ident ?id) (activity ?m&~out&~stand) (move ?s))
  (move-path ?m =(+ ?s 1) ?id ?r ?c)
; [adeguamentoAL]
  (cell (step ?i)(pos-r ?r) (pos-c ?c) (contains Wall|PersonSeated|PersonStanding|Seat|Table|DessertDispenser|MealDispenser|PillDispenser|TrashBasket))
=>
  (modify  ?f1 (time ?t) (step ?i))
)
;//La serie di mosse � stata esaurita, la persona rimane ferma dove si trova



(defrule MovePerson_end
  (declare (salience 9))
  (status (step ?i) (time ?t))
  ?f1<-	(personstatus (step =(- ?i 1)) (time ?tt) (ident ?id) (activity ?m&~outd&~stand) (move ?s))
  (not (move-path ?m =(+ ?s 1) ?id ?r ?c))
  =>
  (modify  ?f1  (time ?t) (step ?i) (activity stand) (move NA))
)






(defrule percept-acoust-no
  (declare (salience 7))
  (status (step ?i) (time ?t&:(> ?t 0)))
  (agentstatus (pos-r ?r) (pos-c ?c) (step ?i))
  (not (perc-acoust (time ?t)))
=>
  (assert (perc-acoust (step ?i) (time ?t) (pos-r ?r) (pos-c ?c) (ac no)))
)


;******************************************
;        GENERAZIONE PERCEZIONI VISIVE
;******************************************



(defrule percept-north
  (declare (salience 5))
  ?f1<- (agentstatus (step ?i) (time ?t&:(> ?t 0)) (pos-r ?r) (pos-c ?c) (direction north))
  (cell (step ?i)(pos-r =(+ ?r 1)) (pos-c =(- ?c 1)) (contains ?x1))
  (cell (step ?i)(pos-r =(+ ?r 1)) (pos-c ?c)  (contains ?x2))
  (cell (step ?i)(pos-r =(+ ?r 1)) (pos-c =(+ ?c 1)) (contains ?x3))
  (cell (step ?i)(pos-r ?r)  (pos-c =(- ?c 1)) (contains ?x4))
  (cell (step ?i)(pos-r ?r)  (pos-c ?c)  (contains ?x5))
  (cell (step ?i)(pos-r ?r)  (pos-c =(+ ?c 1)) (contains ?x6))
  (cell (step ?i)(pos-r =(- ?r 1)) (pos-c =(- ?c 1)) (contains ?x7))
  (cell (step ?i)(pos-r =(- ?r 1)) (pos-c ?c)  (contains ?x8))
  (cell (step ?i)(pos-r =(- ?r 1)) (pos-c =(+ ?c 1)) (contains ?x9))
  =>
  (assert
    (perc-vision
       (step ?i)
       (time ?t)
       (pos-r ?r) (pos-c ?c) (direction north)
       (perc1 ?x1) (perc2 ?x2) (perc3 ?x3)
       (perc4 ?x4) (perc5 ?x5) (perc6 ?x6)
       (perc7 ?x7) (perc8 ?x8) (perc9 ?x9)))
  (pop-focus)
)



(defrule percept-south
  (declare (salience 5))
  ?f1<- (agentstatus (step ?i)(time ?t&:(> ?t 0)) (pos-r ?r) (pos-c ?c) (direction south))
  (cell (step ?i)(pos-r =(- ?r 1)) (pos-c =(+ ?c 1)) (contains ?x1))
  (cell (step ?i)(pos-r =(- ?r 1)) (pos-c ?c)  (contains ?x2))
  (cell (step ?i)(pos-r =(- ?r 1)) (pos-c =(- ?c 1)) (contains ?x3))
  (cell (step ?i)(pos-r ?r)  (pos-c =(+ ?c 1)) (contains ?x4))
  (cell (step ?i)(pos-r ?r)  (pos-c ?c)  (contains ?x5))
  (cell (step ?i)(pos-r ?r)  (pos-c =(- ?c 1)) (contains ?x6))
  (cell (step ?i)(pos-r =(+ ?r 1)) (pos-c =(+ ?c 1)) (contains ?x7))
  (cell (step ?i)(pos-r =(+ ?r 1)) (pos-c ?c)  (contains ?x8))
  (cell (step ?i)(pos-r =(+ ?r 1)) (pos-c =(- ?c 1)) (contains ?x9))
  =>
  (assert
    (perc-vision
      (step ?i)
      (time ?t)
      (pos-r ?r)
      (pos-c ?c)
      (direction south)
      (perc1 ?x1) (perc2 ?x2) (perc3 ?x3)
      (perc4 ?x4) (perc5 ?x5) (perc6 ?x6)
      (perc7 ?x7) (perc8 ?x8) (perc9 ?x9)
    )
  )
  (pop-focus)
)



(defrule percept-east
  (declare (salience 5))
  ?f1<- (agentstatus (step ?i)(time ?t&:(> ?t 0)) (pos-r ?r) (pos-c ?c) (direction east))
  (cell (step ?i)(pos-r =(+ ?r 1)) (pos-c =(+ ?c 1)) (contains ?x1))
  (cell (step ?i)(pos-r ?r)  (pos-c =(+ ?c 1)) (contains ?x2))
  (cell (step ?i)(pos-r =(- ?r 1)) (pos-c =(+ ?c 1)) (contains ?x3))
  (cell (step ?i)(pos-r =(+ ?r 1)) (pos-c ?c)  (contains ?x4))
  (cell (step ?i)(pos-r ?r)  (pos-c ?c)  (contains ?x5))
  (cell (step ?i)(pos-r =(- ?r 1)) (pos-c ?c)  (contains ?x6))
  (cell (step ?i)(pos-r =(+ ?r 1)) (pos-c =(- ?c 1)) (contains ?x7))
  (cell (step ?i)(pos-r ?r)  (pos-c =(- ?c 1)) (contains ?x8))
  (cell (step ?i)(pos-r =(- ?r 1)) (pos-c =(- ?c 1)) (contains ?x9))
  =>
  (assert
    (perc-vision
      (step ?i)
      (time ?t)
      (pos-r ?r)
      (pos-c ?c)
      (direction east)
      (perc1 ?x1) (perc2 ?x2) (perc3 ?x3)
      (perc4 ?x4) (perc5 ?x5) (perc6 ?x6)
      (perc7 ?x7) (perc8 ?x8) (perc9 ?x9)))
  (pop-focus)
)



(defrule percept-west
(declare (salience 5))
?f1<- (agentstatus (step ?i)(time ?t&:(> ?t 0)) (pos-r ?r) (pos-c ?c) (direction west))
(cell (step ?i)(pos-r =(- ?r 1)) (pos-c =(- ?c 1)) (contains ?x1))
(cell (step ?i)(pos-r ?r)  (pos-c =(- ?c 1)) (contains ?x2))
(cell (step ?i)(pos-r =(+ ?r 1)) (pos-c =(- ?c 1)) (contains ?x3))
(cell (step ?i)(pos-r =(- ?r 1)) (pos-c ?c)  (contains ?x4))
(cell (step ?i)(pos-r ?r)  (pos-c ?c)  (contains ?x5))
(cell (step ?i)(pos-r =(+ ?r 1)) (pos-c ?c)  (contains ?x6))
(cell (step ?i)(pos-r =(- ?r 1)) (pos-c =(+ ?c 1)) (contains ?x7))
(cell (step ?i)(pos-r ?r)  (pos-c =(+ ?c 1)) (contains ?x8))
(cell (step ?i)(pos-r =(+ ?r 1)) (pos-c =(+ ?c 1)) (contains ?x9))
=>
(assert (perc-vision (step ?i)(time ?t)
                 (pos-r ?r) (pos-c ?c) (direction west)
                 (perc1 ?x1) (perc2 ?x2) (perc3 ?x3)
                 (perc4 ?x4) (perc5 ?x5) (perc6 ?x6)
                 (perc7 ?x7) (perc8 ?x8) (perc9 ?x9)))
(pop-focus)
)
