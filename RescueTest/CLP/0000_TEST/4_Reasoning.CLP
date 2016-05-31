; ;; Modulo per la definizione dei meccanismi di reasoning dell'agente

; ;; MODULO REASONING

(defmodule REASONING (import MAIN ?ALL)(import AGENT ?ALL)(export ?ALL))

; Crea uno stupido piano di prova
(defrule create-test-plan
  (not
    (plan-action)
  )
  => 
  (assert
    (plan-action (action Wait) (plan-step -1))
    (plan-action (action Turnleft) (plan-step 0))
    (plan-action (action Turnleft) (plan-step 1))
    (plan-action (action Forward) (plan-step 2))
    (plan-action (action Forward) (plan-step 3))
    (plan-action (action Forward) (plan-step 4))
    (plan-action (action Turnright) (plan-step 5))
    (plan-action (action Done) (plan-step 6))
  )
)
