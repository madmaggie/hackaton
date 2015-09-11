
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;      CLASSSES         ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;      TEMPLATES        ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




(deftemplate cognitiveEvaluation
	(slot topic (type INTEGER))
	(multislot grades (type SYMBOL) (allowed-symbols NEV NACQ CRTACQ ACQ))
	(slot gradesNo (type INTEGER))
	(slot avgGrade (type SYMBOL) (allowed-symbols NEV NACQ CRTACQ ACQ))
)

(deftemplate action
	(slot name (type SYMBOL) (allowed-symbols NEXT CONTINUE HINT RELAX))
)


(deftemplate answer
	(slot text (type STRING))
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;    GLOBAL VARS        ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defglobal
	?*threshold_comp* = 10   ; it's compulsory to write at least ?*threshold_comp* letters
	?*threshold_opt* = 20    ; the child has to write up to ?*threshold_opt* characters if the letter 
	?*grades* = (create$ NEV NACQ CRTACQ ACQ)
	?*affect* = (create$ POS NEG NEU)
	?**actions* = (create$ NEXT CONTINUE HINT RELAX)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;      FUNCTIONS        ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(deffunction previous-action-relax ($?pa) 
	(bind ?l (length $?pa))
	(return (or (eq (nth$ ?l $?pa) RELAX) (eq (nth$ (- ?l 1) $?pa) RELAX) (eq (nth$ (- ?l 2) $?pa) RELAX) ))
)


(deffunction previous-action-hint ($?pa) 
	(bind ?l (length $?pa))
	(return (or (eq (nth$ ?l $?pa) HINT) (eq (nth$ (- ?l 1) $?pa) HINT) (eq (nth$ (- ?l 2) $?pa) HINT) ))
)


(deffunction no-previous-action-relax ($?pa) 
	(bind ?l (length $?pa))
	(return (and (neq (nth$ ?l $?pa) RELAX) (neq (nth$ (- ?l 1) $?pa) RELAX) (neq (nth$ (- ?l 2) $?pa) RELAX) ))
)



(deffunction no-previous-action-hint ($?pa) 
	(bind ?l (length $?pa))
	(return (and (neq (nth$ ?l $?pa) HINT) (neq (nth$ (- ?l 1) $?pa) HINT) (neq (nth$ (- ?l 2) $?pa) HINT) ))
)



(deffunction all-previous-actions-relax ($?pa) 
	(bind ?l (length $?pa))
	(return (and (eq (nth$ ?l $?pa) RELAX) (eq (nth$ (- ?l 1) $?pa) RELAX) (eq (nth$ (- ?l 2) $?pa) RELAX) ))
)



(deffunction not-all-previous-actions-relax ($?pa) 
	(bind ?l (length $?pa))
	(return (or (neq (nth$ ?l $?pa) RELAX) (neq (nth$ (- ?l 1) $?pa) RELAX) (neq (nth$ (- ?l 2) $?pa) RELAX) ))
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;       RULES           ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                       CONTINUE                                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 1. <THRESHOLD_COMP   =>   CONTINUE
; 2. CRTACQ   <THRESHOLD_OPT   POS/NEU   =>  CONTINUE
; 3. CRTACQ   >=THRESHOLD_COMP   NEG   EXISTS(RELAX)   EXISTS(HINT)   =>  CONTINUE
; 4. NACQ   >=THRESHOLD_COMP   POS/NEU   => CONTINUE
; 5. NACQ   >=THRESHOLD_COMP   NEG   EXISTS(RELAX)   EXISTS(HINT)   =>  CONTINUE



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 1. <THRESHOLD_COMP   =>   CONTINUE
; if the number of exercises is not enough (under threshold_comp)
; then continue writing letters

(defrule continue1
	(cognitiveEvaluation (gradesNo ?nrg&:(< ?nrg ?*threshold_comp*)))
=>
	(assert (action (name CONTINUE)))
	(assert (answer (text "[CONTINUE 1] SA MAI SCRIEM NISTE LITERE, AI SCRIS CAM PUTINE")))
	(printout t "------------[CONTINUE 1] SA MAI SCRIEM NISTE LITERE, AI SCRIS CAM PUTINE---------------" crlf)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 2. CRTACQ   >=THRESHOLD_COMP   <THRESHOLD_OPT   POS/NEU   =>  CONTINUE
; if student results are pretty good (skill acquiring)
; and the number of exercises is over threshold_comp
; and the number of exercises is not enough (under threshold_opt)
; and student affective state is positive or neutral
; then continue writing letters

(defrule continue2
	(cognitiveEvaluation (avgGrade ?grade&:(eq ?grade (nth$ 3 ?*grades*)))
						 (gradesNo ?nrg&:(and (< ?nrg ?*threshold_opt*) (>= ?nrg ?*threshold_comp*))))
	(emotion ?em&:(or (eq ?em (nth$ 1 ?*affect*)) (eq ?em (nth$ 3 ?*affect*))))
=>
	(assert (action (name CONTINUE)))
	(assert (answer (text "[CONTINUE 2] HAI SA MAI SCRIEM, SE POATE SI MAI BINE")))
	(printout t "------------[CONTINUE 2] HAI SA MAI SCRIEM, SE POATE SI MAI BINE---------" crlf)
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;3. CRTACQ   >=THRESHOLD_COMP   NEG   EXISTS(RELAX)   EXISTS(HINT)   =>  CONTINUE
; if student results are pretty good (skill acquiring)
; and the number of exercises is enough (over threshold_comp)
; and student affective state is negative
; and there was already a relax action previously
; and there was already a hint action previously
; then continue writing letters

(defrule continue3
	(cognitiveEvaluation (avgGrade ?grade&:(eq ?grade (nth$ 3 ?*grades*)))
						 (gradesNo ?nrg&:(>= ?nrg ?*threshold_comp*)))
	(emotion ?em&:(eq ?em (nth$ 2 ?*affect*)))	
	(prevous-actions $?pa&:(and (previous-action-relax $?pa) (previous-action-hint $?pa)))
=>
	(assert (action (name CONTINUE)))
	(assert (answer (text "[CONTINUE 3] ACUM HAIDE SA MAI SCRIEM NISTE LITERE")))
	(printout t "--------[CONTINUE 3] ACUM HAIDE SA MAI SCRIEM NISTE LITERE---------" crlf)
)





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 4. NACQ   >=THRESHOLD_COMP   POS/NEU   => CONTINUE
; if student results are not good (skill not acquired)
; and the number of exercises is enough (over threshold_comp)
; and student affective state is positive or neutral
; then continue writing letters

(defrule continue4
	(cognitiveEvaluation (avgGrade ?grade&:(eq ?grade (nth$ 2 ?*grades*)))
						 (gradesNo ?nrg&:(>= ?nrg ?*threshold_comp*)))
	(emotion ?em&:(or (eq ?em (nth$ 1 ?*affect*)) (eq ?em (nth$ 3 ?*affect*))))
=>
	(assert (action (name CONTINUE)))
	(assert (answer (text "[CONTINUE 4] MAI INCEARCA")))
	(printout t "--------[CONTINUE 4] MAI INCEARCA---------" crlf)
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;5. NACQ   >=THRESHOLD_COMP   NEG   EXISTS(RELAX)   EXISTS(HINT)   =>  CONTINUE
; if student results are not good (skill not acquired)
; and the number of exercises is enough (over threshold_comp)
; and student affective state is negative
; and there was already a relax action previously
; and there was already a hint action previously
; then continue writing letters

(defrule continue5
	(cognitiveEvaluation (avgGrade ?grade&:(eq ?grade (nth$ 2 ?*grades*)))
						 (gradesNo ?nrg&:(>= ?nrg ?*threshold_comp*)))
	(emotion ?em&:(eq ?em (nth$ 2 ?*affect*)))	
	(previous-actions $?pa&:(and (previous-action-relax $?pa) (previous-action-hint $?pa)))
=>
	(assert (action (name CONTINUE)))
	(assert (answer (text "[CONTINUE 5] STIU CA E GREU, DAR MAI INCEARCA")))
	(printout t "--------[CONTINUE 5] STIU CA E GREU, DAR MAI INCEARCA---------" crlf)
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                         NEXT                                  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 1. ACQ   >=THRESHOLD_COMP   POS/NEU   =>   NEXT
; 2. ACQ   >=THRESHOLD_COMP   NEG   ALL(RELAX)   =>   NEXT
; 3. CRTACQ   >=THRESHOLD_OPT   POS/NEU   =>   NEXT
; 4. CRTACQ   >=THRESHOLD_OPT   NEG   ALL(RELAX)   =>   NEXT



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 1. ACQ   >=THRESHOLD_COMP   POS/NEU   =>   NEXT
; if student results are very good (skill acquired)
; and the number of exercises is enough (over threshold_comp)
; and student affective state is positive or neutral
; then go to the next topic

(defrule nextTopic1
	(cognitiveEvaluation (avgGrade ?grade&:(eq ?grade (nth$ 4 ?*grades*)))
						 (gradesNo ?nrg&:(>= ?nrg ?*threshold_comp*)))
	(emotion ?em&:(or (eq ?em (nth$ 1 ?*affect*)) (eq ?em (nth$ 3 ?*affect*))))
=>
	(assert (action (name NEXT)))
	(assert (answer (text "[NEXT 1] SUPER, PERFECT, PUTEM TRECE LA URMATOAREA LITERA")))
	(printout t "------------[NEXT 1] SUPER, PERFECT, PUTEM TRECE LA URMATOAREA LITERA---------------" crlf)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 2. ACQ   >=THRESHOLD_COMP   NEG   ALL(RELAX)   =>   NEXT
; if student results are very good (skill acquired)
; and the number of exercises is enough (over threshold_comp)
; and student affective state is negative
; and all (3) previous actions are relax
; then go to the next topic

(defrule nextTopic2
	(cognitiveEvaluation (avgGrade ?grade&:(eq ?grade (nth$ 4 ?*grades*)))
						 (gradesNo ?nrg&:(>= ?nrg ?*threshold_comp*)))
	(emotion ?em&:(eq ?em (nth$ 2 ?*affect*)))
	(previous-actions $?pa&:(all-previous-actions-relax $?pa))
=>
	(assert (action (name NEXT)))
	(assert (answer (text "[NEXT 2] TE-AI RELAXAT DESTUL, HAI SA TRECEM URMATOAREA LITERA")))
	(printout t "------------[NEXT 2] TE-AI RELAXAT DESTUL, HAI SA TRECEM URMATOAREA LITERA---------------" crlf)
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 3. CRTACQ   >=THRESHOLD_OPT   POS/NEU   =>   NEXT
; if student results are good (skill acquiring)
; and the number of exercises is enough (over threshold_opt)
; and student affective state is positive or neutral
; then go to the next topic

(defrule nextTopic3
	(cognitiveEvaluation (avgGrade ?grade&:(eq ?grade (nth$ 3 ?*grades*)))
						 (gradesNo ?nrg&:(>= ?nrg ?*threshold_opt*)))
	(emotion ?em&:(or (eq ?em (nth$ 1 ?*affect*)) (eq ?em (nth$ 3 ?*affect*))))
=>
	(assert (action (name NEXT)))
	(assert (answer (text "[NEXT 3] SE PUTEA SI MAI BINE, DAR TREAA DE LA MINE, HAI SA ITI ARAT URMATOAREA LITERA")))
	(printout t "------------[NEXT 3] SE PUTEA SI MAI BINE, DAR TREAA DE LA MINE, HAI SA ITI ARAT URMATOAREA LITERA---------------" crlf)
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 4. CRTACQ   >=THRESHOLD_OPT   NEG   ALL(RELAX)   =>   NEXT
; if student results are good (skill acquiring)
; and the number of exercises is enough (over threshold_opt)
; and student affective state is negative
; and all previous (3) actions are relax
; then go to the next topic

(defrule nextTopic4
	(cognitiveEvaluation (avgGrade ?grade&:(eq ?grade (nth$ 3 ?*grades*)))
						 (gradesNo ?nrg&:(>= ?nrg ?*threshold_opt*)))
	(emotion ?em&:(eq ?em (nth$ 2 ?*affect*)))
	(previous-actions $?pa&:(all-previous-actions-relax $?pa))
	
=>
	(assert (action (name NEXT)))
	(assert (answer (text "[NEXT 4] EI, NU FI TRIST, HAI SA ITI ARAT URMATOAREA LITERA")))
	(printout t "------------[NEXT 4] EI, NU FI TRIST, HAI SA ITI ARAT URMATOAREA LITERA---------------" crlf)
)





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                          RELAX                                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 1. ACQ   >=THRESHOLD_COMP   NEG   ~ALL(RELAX)   =>   RELAX
; 2. CRTACQ   >=THRESHOLD_OPT   NEG   ~ALL(RELAX)   =>   RELAX
; 3. CRTACQ  >=THRESHOLD_COMP   NEG   ~EXISTS(RELAX)   =>   RELAX
; 4. NACQ  >=THRESHOLD_COMP   ~EXISTS(RELAX)   =>   RELAX



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 1. ACQ   >=THRESHOLD_COMP   NEG   ~ALL(RELAX)   =>   RELAX
; if student results are very good (skill acquired)
; and the number of exercises is enough (over threshold_comp)
; and student affective state is negative
; and not all previous (3) actions are relax
; then RELAX (entertain, tell a story)


(defrule relax1
	(cognitiveEvaluation (avgGrade ?grade&:(eq ?grade (nth 4 ?*grades*)))
						 (gradesNo ?nrg&:(>= ?nrg ?*threshold_comp*)))
	(emotion ?em&:(eq ?em (nth$ 2 ?*affect*)))
	(previous-actions $?pa&:(not-all-previous-actions-relax $?pa))
=>
	(assert (action (name RELAX)))
	(assert (answer (text "[RELAX 1] NU FI TRIST, AI SCRIS FOARTE FRUMOS! HAI SA-TI SPUN O POVESTE")))
	(printout t "--------[RELAX 1] NU FI TRIST, AI SCRIS FOARTE FRUMOS! HAI SA-TI SPUN O POVESTE---------" crlf)
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 2. CRTACQ   >=THRESHOLD_OPT   NEG   ~ALL(RELAX)   =>   RELAX
; if student results are good (skill acquiring)
; and the number of exercises is enough (over threshold_opt)
; and student affective state is negative
; and not all previous (3) actions are relax
; then RELAX (entertain, tell a story)

(defrule relax2
	(cognitiveEvaluation (avgGrade ?grade&:(eq ?grade (nth 3 ?*grades*)))
						 (gradesNo ?nrg&:(>= ?nrg ?*threshold_opt*)))
	(emotion ?em&:(eq ?em (nth$ 2 ?*affect*)))
	(previous-actions $?pa&:(not-all-previous-actions-relax $?pa))
=>
	(assert (action (name RELAX)))
	(assert (answer (text "[RELAX 2] NU FI TRIST, HAI SA-TI MAI SPUN O POVESTE")))
	(printout t "--------[RELAX 2] NU FI TRIST, HAI SA-TI MAI SPUN O POVESTE---------" crlf)
)





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 3. CRTACQ  >=THRESHOLD_COMP   NEG   ~EXISTS(RELAX)   =>   RELAX
; if student results are good (skill acquiring)
; and the number of exercises is enough (over threshold_comp)
; and student affective state is negative
; and there is no previous relax action
; then RELAX (entertain, tell a story)

(defrule relax3
	(cognitiveEvaluation (avgGrade ?grade&:(eq ?grade (nth 3 ?*grades*)))
						 (gradesNo ?nrg&:(>= ?nrg ?*threshold_comp*)))
	(emotion ?em&:(eq ?em (nth$ 2 ?*affect*)))
	(previous-actions $?pa&:(no-previous-action-relax $?pa))
=>
	(assert (action (name RELAX)))
	(assert (answer (text "[RELAX 3] DATA VIITOARE O SA FACI SI MAI BINE, HAI SA-TI SPUN O POVESTE ACUM")))
	(printout t "--------[RELAX 3] DATA VIITOARE O SA FACI SI MAI BINE, HAI SA-TI SPUN O POVESTE ACUM---------" crlf)
)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 4. NACQ  >=THRESHOLD_COMP   ~EXISTS(RELAX)   =>   RELAX
; if student results are not good (skill not acquired)
; and the number of exercises is high (over threshold_comp)
; and there is no previous relax action
; then RELAX (entertain, tell a story)

(defrule relax4
	(cognitiveEvaluation (avgGrade ?grade&:(eq ?grade (nth 2 ?*grades*)))
						 (gradesNo ?nrg&:(>= ?nrg ?*threshold_comp*)))
	(previous-actions $?pa&:(no-previous-action-relax $?pa))
=>
	(assert (action (name RELAX)))
	(assert (answer (text "[RELAX 4] HAI SA-TI SPUN O POVESTE SI MAI EXERSAM PE URMA")))
	(printout t "--------[RELAX 4] HAI SA-TI SPUN O POVESTE SI MAI EXERSAM PE URMA---------" crlf)
)






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                        HINT                                   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 1. CRTACQ   >=THRESHOLD_COMP   NEG   ~EXISTS(HINT)   =>   HINT
; 2. NACQ   >=THRESHOLD_COMP   ~EXISTS(HINT)   =>   HINT



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 1. CRTACQ   >=THRESHOLD_COMP   NEG   ~EXISTS(HINT)   =>   HINT
; if student results are good (skill acquiring)
; and the number of exercises is high (over threshold_comp)
; and student affective state is negative
; and there is no previous hint action
; then repeat topic description 

(defrule hint1
	(cognitiveEvaluation (avgGrade ?grade&:(eq ?grade (nth 3 ?*grades*)))
						 (gradesNo ?nrg&:(>= ?nrg ?*threshold_comp*)))
	(emotion ?em&:(eq ?em (nth$ 2 ?*affect*)))
	(previous-actions $?pa&:(no-previous-action-hint $?pa))
=>
	(assert (action (name HINT)))
	(assert (answer (text "[HINT 1] E BINE, DAR MAI UITA-TE O DATA CUM SE FACE:")))
	(printout t "--------[HINT 1] E BINE, DAR MAI UITA-TE O DATA CUM SE FACE:---------" crlf)
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 2. NACQ   >=THRESHOLD_COMP   ~EXISTS(HINT)   =>   HINT
; if student results are not good (skill not acquired)
; and the number of exercises is high (over threshold_comp)
; and there is no previous hint action
; then repeat topic description 

(defrule hint2
	(cognitiveEvaluation (avgGrade ?grade&:(eq ?grade (nth 2 ?*grades*)))
						 (gradesNo ?nrg&:(>= ?nrg ?*threshold_comp*)))
	(previous-actions $?pa&:(no-previous-action-hint $?pa))
=>
	(assert (action (name HINT)))
	(assert (answer (text "[HINT 2] HAI SA-TI MAI ARAT O DATA CUM SE FACE:")))
	(printout t "--------[HINT 2] HAI SA-TI MAI ARAT O DATA CUM SE FACE:---------" crlf)
)



