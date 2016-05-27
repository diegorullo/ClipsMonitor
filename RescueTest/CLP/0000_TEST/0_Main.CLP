; Questo programma contiene il simulatore dell'agente robotico per applicazione 
;   ASSISTED LIVING
;
;  Si noti che la parte di funzionamento dell'agente è separata
;  dal particolare problema da risolvere.
;
;  Infatti la definizione del problema in termini di 
;         mappa iniziale (descritta con istanzazioni di prior_cell)
;  deve essere contenuta nel file InitMap.txt       
; cosi come l'accoppiamento <Tavolo,sedia>.
;
;  la descrizione di quali eventi avvengono durante l'esecuzione è
;  contenuta nel file history.txt inclusa la durata massima (maxduration)
;  Questo file contiene anche le informazioni per indicare  quali sono 
;  gli anziani (dove sono localizzati all'inizio), quali attività svolgeranno 
;  e quali sono gli operatori sanitari,
;  
;
 
;_______________________________________________________________________________________________________________________
;// MAIN                                                
;// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯ 


(defmodule MAIN (export ?ALL))


(deftemplate exec 
	(slot step) 	
	(slot action  (allowed-values forward turnright turnleft wait 
                                      loadmeal loadpill loaddessert 
                                      deliverymeal deliverypill deliverydessert 
                                      cleantable emptyrobot releasetrash checkid 
                                      inform done))
        (slot param1)
        (slot param2)
        (slot param3)
        (slot param4))




(deftemplate status (slot step) (slot time) (slot result (allowed-values no done disaster)) )

(deftemplate table-seat (slot t_pos-r) (slot t_pos-c)(slot s_pos-r) (slot s_pos-c))
(deftemplate prescription
              (slot patient)
              (slot meal (allowed-values normal dietetic))
              (slot pills (allowed-values no before after))
              (slot dessert (allowed-values yes no)))
(deftemplate init_cell

    (slot pos-r)
    (slot pos-c)
    (slot contains (allowed-values empty debris wall gate outdoor unknown seat))
)


(deftemplate initial_agentposition (slot pos-r)  (slot pos-c) (slot direction))


(deftemplate perc-vision
    (slot step)
    (slot time)
    (slot pos-r)
    (slot pos-c)
    (slot direction)
    (slot perc1  (allowed-values   empty debris wall gate outdoor person seat))
    (slot perc2  (allowed-values   empty debris wall gate outdoor person seat))
    (slot perc3  (allowed-values   empty debris wall gate outdoor person seat))
    (slot perc4  (allowed-values   empty debris wall gate outdoor person seat))
    (slot perc5  (allowed-values  robot empty debris wall gate outdoor person seat))
    (slot perc6  (allowed-values   empty debris wall gate outdoor person seat))
    (slot perc7  (allowed-values   empty debris wall gate outdoor person seat))
    (slot perc8  (allowed-values   empty debris wall gate outdoor person seat))
    (slot perc9  (allowed-values   empty debris wall gate outdoor person seat))
)


(deftemplate perc-acoust
  (slot step)
  (slot time)
  (slot pos-r)
  (slot pos-c)
  (slot ac (allowed-values no yes))
)




(deftemplate perc-drill
   (slot step)
   (slot time)
   (slot pos-r)
   (slot pos-c)
   (slot result (allowed-values yes no fail))
)





(deftemplate perc-bump

	(slot step)
  (slot time)
	(slot pos-r)
	(slot pos-c)
	(slot direction)
	(slot bump (allowed-values no yes))
)



(deftemplate perc-loaded
  (slot step)
  (slot time)
  (slot robotpos-r)
  (slot robotpos-c)
  (slot loaded  (allowed-values yes no))
)


(deffacts init
	(create)
)


;; regola per inizializzazione
;; legge anche initial map , initial agent status e durata simulazione (in numero di passi)



(defrule createworld

    ?f<- (create) =>
    (assert (create-map))
    (retract ?f)
    (focus ENV)
)

;; SI PASSA AL MODULO AGENT SE NON  E' ESAURITO IL TEMPO (indicato da maxduration)



(defrule go-on-agent

   (declare (salience 20))
   (maxduration ?d)
   (status (time ?t&:(< ?t ?d)) (step ?s) (result no))

 =>

    ;(printout t crlf crlf)
    ;:(printout t "vado ad agent  step" ?s)
    (focus AGENT)
)



;// SI PASSA AL MODULO ENV DOPO CHE AGENTE HA DECISO AZIONE DA FARE

(defrule go-on-env

	(declare (salience 21))
  ?f1<-	(status (step ?s))
  (exec (step ?s)) 	;// azione da eseguire al passo s, viene simulata dall'environment

=>

  ; (printout t crlf crlf)
  ; (printout t "vado ad ENV  step" ?s)
  (focus ENV)

)



;; tempo esaurito

(defrule increase-penalties
  (declare (salience 20))
  (maxduration ?d)
  (status (time ?t) (result no))
  (or
    (test (= ?t ?d))
    (test (> ?t ?d))
  )
  ?penalty<-(penalty ?p)
  (not (penalty-update))
  =>
  (retract ?penalty)
  (assert ( penalty (+ ?p 10000000)))
  (assert (penalty-update))
)

(defrule finish1

   (declare (salience 19))
   (maxduration ?d)
   (penalty-update)
   (status (time ?t) (result no))
   (or
     (test (= ?t ?d))
     (test (> ?t ?d))
   )
   (penalty ?p)
      =>

  (printout t crlf crlf)
  (printout t "time over   " ?t)
  (printout t crlf crlf)
  (printout t "penalty:" ?p )
  (printout t crlf crlf)
  (halt)
)


;; l'agent ha dichiarato che ha terminato il suo compito (messaggio done)


(defrule finish2

   (declare (salience 19))
   (status (time ?t) (result done))
   (penalty ?p)

          =>

  (printout t crlf crlf)
  (printout t "done at time   " ?t)
  (printout t crlf crlf)
  (printout t "penalty:" ?p)
  (printout t crlf crlf)
  (halt)
)



;; SI BLOCCA TUTTO SE OCCORRE DISASTER



(defrule disaster

   (declare (salience 19))
   (status (time ?t) (result disaster))

 =>

   (printout t crlf crlf)
   (printout t "game over at time " ?t)
   (halt)
)
