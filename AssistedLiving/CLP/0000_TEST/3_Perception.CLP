(defmodule PERCEPTION (import MAIN ?ALL) (import AGENT ?ALL) (export ?ALL))


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
          =>
  (modify ?k-agent (step ?s)(time ?t) (pos-r ?r) (pos-c ?c) (direction ?dir) (loaded ?kl))
  (retract ?perc)
)


;fixme: 
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
