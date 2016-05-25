(defmodule PERCEPTION (import MAIN ?ALL) (import AGENT ?ALL) (export ?ALL))

; Celle in cui vengono messe temporaneamente le percezioni visive
(deftemplate V-cell
 (slot pos-r)
 (slot pos-c)
 (slot contains (allowed-values empty debris wall gate outdoor person unknown robot))
)

; -------------------------
; --- Percezioni visive ---
; -------------------------


(defrule incoming-percepts
  (status (step ?s))
  ?perc<-(perc-vision (step ?s)(time ?t) (pos-r ?r) (pos-c ?c) (direction ?dir)
                     (perc1 ?x1) (perc2 ?x2) (perc3 ?x3)
                     (perc4 ?x4) (perc5 ?x5) (perc6 ?x6)
                     (perc7 ?x7) (perc8 ?x8) (perc9 ?x9))

  ?k-agent <- (K-agent (step ?ks ) (time ?kt) (pos-r ?kr) (pos-c ?kc) (direction ?kd) (loaded ?kl))
  (offset-around (direction ?dir) (position forward)         (offset-r ?fr) (offset-c ?fc))
  (offset-around (direction ?dir) (position forward-left)    (offset-r ?flr) (offset-c ?flc))
  (offset-around (direction ?dir) (position forward-right)   (offset-r ?frr) (offset-c ?frc))
  (offset-around (direction ?dir) (position left)            (offset-r ?lr) (offset-c ?lc))
  (offset-around (direction ?dir) (position behind-left)     (offset-r ?blr) (offset-c ?blc))
  (offset-around (direction ?dir) (position behind)          (offset-r ?br) (offset-c ?bc))
  (offset-around (direction ?dir) (position behind-right)    (offset-r ?brr) (offset-c ?brc))
  (offset-around (direction ?dir) (position right)           (offset-r ?rr) (offset-c ?rc))
          =>

  (modify ?k-agent (step ?s)(time ?t) (pos-r ?r) (pos-c ?c) (direction ?dir) (loaded ?kl))
  (assert
    (V-cell (pos-r =(+ ?r ?flr))  (pos-c =(+ ?c  ?flc)) (contains ?x1))
    (V-cell (pos-r =(+ ?r ?fr ))  (pos-c =(+ ?c  ?fc))  (contains ?x2))
    (V-cell (pos-r =(+ ?r ?frr))  (pos-c =(+ ?c  ?frc)) (contains ?x3))
    (V-cell (pos-r =(+ ?r ?lr ))  (pos-c =(+ ?c  ?lc))  (contains ?x4))
    (V-cell (pos-r ?r)            (pos-c ?c)            (contains ?x5))
    (V-cell (pos-r =(+ ?r ?rr ))  (pos-c =(+ ?c  ?rc))  (contains ?x6))
    (V-cell (pos-r =(+ ?r ?blr))  (pos-c =(+ ?c  ?blc)) (contains ?x7))
    (V-cell (pos-r =(+ ?r ?br ))  (pos-c =(+ ?c  ?bc))  (contains ?x8))
    (V-cell (pos-r =(+ ?r ?brr))  (pos-c =(+ ?c  ?brc)) (contains ?x9))
  )
  (retract ?perc)
)



; aggiorna le k-cell in base a ciò che l'agente ha visto
(defrule update-K-cell
  ?v-cell <- (V-cell (pos-r ?r)(pos-c ?c)(contains ?contains&debris|unknown))
  ?k-cell <- (K-cell (pos-r ?r)(pos-c ?c)(contains ?))
  =>
  (modify ?k-cell (contains ?contains))
  (retract ?v-cell)
)


; aggiorna le k-cell in base a ciò che l'agente ha visto, impostando injured a no
(defrule update-K-cell-no-injured
  ?v-cell <- (V-cell (pos-r ?r)(pos-c ?c)(contains ?contains&outdoor|wall|empty|gate))
  ?k-cell <- (K-cell (pos-r ?r)(pos-c ?c)(contains ?))
  =>
  (modify ?k-cell (contains ?contains)(injured no))
  (retract ?v-cell)
)


; aggiorna le k-cell in base a ciò che l'agente ha visto, impostando injured a no
(defrule update-K-cell-person
  (status (step ?step)(time ?time))
  ?v-cell <- (V-cell (pos-r ?r)(pos-c ?c)(contains ?contains&person))
  ?k-cell <- (K-cell (pos-r ?r)(pos-c ?c))
  =>
  (modify ?k-cell (injured no))
  (assert
    (K-person
      (step ?step)
      (time ?time)
      (pos-r ?r)
      (pos-c ?c)
    )
  )
  (retract ?v-cell)
)



; aggiorna la k-cell che contiene il robot. Non mette contains robot ma tiene il valore precedente
(defrule update-K-cell-robot
  ?v-cell <- (V-cell (pos-r ?r)(pos-c ?c)(contains ?contains&robot))
  ?k-cell <- (K-cell (pos-r ?r)(pos-c ?c))
  =>
  (modify ?k-cell (injured no))
  (retract ?v-cell)
)


; --------------------------------
; --- Percezioni di drill      ---
; --------------------------------

; Percezioni per l'operazione di drill
(defrule drill-percepts-yes
 (status (step ?s))
  ?perc <-(perc-drill (step ?s)(time ?t) (pos-r ?r) (pos-c ?c) (result yes))
  ?k-cell <-(K-cell (pos-r ?r) (pos-c ?c))


  =>
  (modify ?k-cell (injured yes))
  (retract ?perc)
)

(defrule drill-percepts-no
  (status (step ?s))
  ?perc <-(perc-drill (step ?s)(time ?t) (pos-r ?r) (pos-c ?c) (result no))
  ?k-cell <-(K-cell (pos-r ?r) (pos-c ?c))

  =>
  (modify ?k-cell (injured no))
  (retract ?perc)
)

(defrule drill-percepts-fail
  (status (step ?s))
  ?perc <-(perc-drill (step ?s)(time ?t) (pos-r ?r) (pos-c ?c) (result fail))
  ?k-cell <-(K-cell (pos-r ?r) (pos-c ?c))
  =>
  (modify ?k-cell (injured unknown))
  (retract ?perc)
)


; --------------------------------
; --- Percezioni acustiche     ---
; --------------------------------
(defrule acoustic-percepts
  (status (step ?s))
  ?perc <- (perc-acoust (step ?s)(time ?t)(pos-r ?r)(pos-c ?c)(ac ?percAcoustic)) ;no o yes
  ?k-cell <- (K-cell (pos-r ?r)(pos-c ?c))
  =>
  (modify ?k-cell (sound ?percAcoustic))
  (retract ?perc)
)

; --------------------------------
; --- Percezioni load          ---
; --------------------------------
(defrule load-percepts
  (status (step ?s))
  ?perc <- (perc-loaded (step ?s)(time ?t)(robotpos-r ?)(robotpos-c ?)(loaded ?l))
  ?agent <- (K-agent (step ?)(time ?)(pos-r ?)(pos-c ?)(direction ?)(loaded ?))
  =>
  (modify ?agent (step ?s)(time ?t)(loaded ?l))
  (retract ?perc)
)

; --------------------------------
; --- Percezione bump          ---
; --------------------------------
(defrule bump-percepts
  (status (step ?s))
  ?perc <- (perc-bump (step ?s))
  =>
  (assert (special-condition (bumped yes)))
  (retract ?perc)
)


; -----------------------------------
; --- Ultime regole di perception ---
; -----------------------------------
(defrule update-last-perc
  (declare (salience -1))
  (status (step ?s))
  ?last-perc <- (last-perc (step ?l))
  (test (> ?s ?l))
  =>
  (modify ?last-perc (step ?s))
)
