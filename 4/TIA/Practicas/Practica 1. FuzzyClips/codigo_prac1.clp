;Funcion para pasar de valor CRIPS a Difuso
(deffunction fuzzify(?fztemplate ?value ?delta)
    (bind ?low (get-u-from ?fztemplate))
    (bind ?hi (get-u-to ?fztemplate))
    
    (if (<= ?value ?low)
        then
            (assert-string
                (format nil "(%s (%g 1.0) (%g 0.0))" ?fztemplate ?low ?delta))
        else
            (if (>= ?value ?hi)
                then
                    (assert-string
                        (format nil "(%s (%g 0.0) (%g 1.0))"
                            ?fztemplate (- ?hi ?delta) ?hi))
                else
                    (assert-string
                        (format nil "(%s (%g 0.0) (%g 1.0) (%g 0.0))"
                            ?fztemplate (max ?low (- ?value ?delta))
                            ?value (min ?hi (+ ?value ?delta)) ))
    )))

(deftemplate id)

; Variables difusas
;----------------------------------------------------------------------

(deftemplate distancia ;Variable difusa
    0 50 metros ; Rango
    ((cerca (0 1) (15 0))
    (medio (10 0) (25 1) (35 1) (40 0))
    (lejos (35 0) (50 1)))) 

 (deftemplate velocidad-relativa
    -30 30 kmh
    ((alejando (-30 1) (0 0))
    (constante (-10 0) (0 1) (10 0))
    (acercando (0 0) (30 1)))) 

(deftemplate presion-freno 
    0 100 %
    ((nula (z 10 25))
    (media (pi 25 65))
    (alta (s 65 90))))


; Clase coche y metodos
;---------------------------------------------------------------------- 

(deftemplate coche
    (slot id (type SYMBOL))
    (slot distancia (type INTEGER))
    (slot velocidad-relativa (type INTEGER))
    (slot presion-freno (type INTEGER))
    (slot warning (type INTEGER))
)

; ToString de la clase Vehiculo
(defrule toString-coche
    (toString-coche)
    (coche (id ?id) (distancia ?d) (velocidad-relativa ?v) (presion-freno ?p) (warning ?w))
    =>
    (printout t "Identificador: " ?id crlf)
    (printout t "Distancia: " ?d crlf)
    (printout t "Velocidad: " ?v crlf)
    (printout t "Presion freno: " ?p crlf)
    (printout t "Warning: " ?w crlf)
    (halt)
)

; Conjunto de Reglas
;----------------------------------------------------------------------

; Distancia-velocidad alejando

(defrule cerca-alejando
	(distancia cerca)
    (velocidad-relativa alejando)
	=>
	(assert (presion-freno nula)))

(defrule medio-alejando
	(distancia medio)
    (velocidad-relativa alejando)
	=>
	(assert (presion-freno nula)))

(defrule lejos-alejando
	(distancia lejos)
    (velocidad-relativa alejando)
	=>
	(assert (presion-freno nula)))

; Distancia-velocidad constante

(defrule cerca-constante
	(distancia cerca)
    (velocidad-relativa constante)
	=>
	(assert (presion-freno more-or-less media)))

(defrule medio-constante
	(distancia medio)
    (velocidad-relativa constante)
	=>
	(assert (presion-freno nula)))

(defrule lejos-constante
	(distancia lejos)
    (velocidad-relativa constante)
	=>
	(assert (presion-freno nula)))

; Distancia-velocidad acercando

(defrule cerca-acercando
	(distancia cerca)
    (velocidad-relativa acercando)
	=>
	(assert (presion-freno alta)))

(defrule medio-acercando
	(distancia medio)
    (velocidad-relativa acercando)
	=>
	(assert (presion-freno media)))

(defrule lejos-acercando
	(distancia lejos)
    (velocidad-relativa acercando)
	=>
	(assert (presion-freno more-or-less media)))

; Presion Freno

(defrule presion-freno-alta
	?f <- (coche (id ?id) (distancia ?distancia) (velocidad-relativa ?velocidad) (presion-freno ?p) (warning ?w))
    (presion-freno alta)
	=>
    (modify ?f (warning 1)) ;Ponemos el warning del coche a 1 (encendido)
    (assert (toString-coche)) ; Hacemos el toString del coche
)

(defrule presion-freno-media
	(presion-freno media)
	?f <- (coche (id ?id) (distancia ?distancia) (velocidad-relativa ?velocidad) (presion-freno ?p) (warning ?w))
	=>
    (modify ?f (warning 0)) ;Ponemos el warning del coche a 0 (apagado)
    (assert (toString-coche)); Hacemos el toString del coche
)

(defrule presion-freno-nula
	(presion-freno nula)
	?f <- (coche (id ?id) (distancia ?distancia) (velocidad-relativa ?velocidad) (presion-freno ?p) (warning ?w))
	=>
    (modify ?f (warning 0)) ;Ponemos el warning del coche a 0 (apagado)
    (assert (toString-coche)); Hacemos el toString del coche
)



; Metodos de defusificacion
;----------------------------------------------------------------------

;defusificacion con maximo
(defrule defuzzy0
    (declare(salience 50)) ;prioridad
    (tipo_deffuzy 0) ;comprobamos que sea defuzzy por maximo la escogida por el usuario
    ?presion <- (presion-freno ?) ;nos quedamos con la presion
    ?f <- (coche (id ?id) (distancia ?distancia) (velocidad-relativa ?velocidad) (presion-freno -1) (warning ?w))
    => 
    (bind ?e (maximum-defuzzify ?presion))
    (printout t "La presion con maximo es " ?e crlf)
    (modify ?f (presion-freno ?e))
) 

;defusificacion con momento
(defrule defuzzy1
    (declare(salience 25))
    (tipo_deffuzy 1) ;comprobamos que sea defuzzy por momento la escogida por el usuario
    ?presion <- (presion-freno ?)
    ?f <- (coche (id ?id) (distancia ?distancia) (velocidad-relativa ?velocidad) (presion-freno -1) (warning ?w))
    => 
    (bind ?e (moment-defuzzify ?presion))
    (printout t "La presion con momento es " ?e crlf)
    (modify ?f (presion-freno ?e))

)

;defusificacion con maximo y momento (en clase se guarda maximo)
(defrule defuzzy2
    (declare(salience 10)) ;prioridad
    (tipo_deffuzy 2) ;comprobamos que sea defuzzy por maximo y momento la escogida por el usuario
    ?presion <- (presion-freno ?) ;nos quedamos con la presion
    ?f <- (coche (id ?id) (distancia ?distancia) (velocidad-relativa ?velocidad) (presion-freno -1) (warning ?w))
    => 
    (bind ?moment (moment-defuzzify ?presion))
    (printout t "La presion con momento es " ?moment crlf)

    (bind ?maximum (maximum-defuzzify ?presion))
    (printout t "La presion con maximo es " ?maximum crlf)

    (modify ?f (presion-freno ?maximum))
) 

;Metodo de inicio del programa
;----------------------------------------------------------------------
(deffunction inicio()
    (printout t "Introduzca identificador del vehiculo: " )
    (bind ?id (read))
    (printout t "Introduzca distancia al vehiculo de delante: " )
    (bind ?distancia (read))
    (bind ?distancia_fuzzify (fuzzify distancia ?distancia 0))
    (printout t "Introduzca velocidad relativa del coche: " )
    (bind ?velocidad (read))
    (printout t "Introduzca 0, 1 o 2 para elegir entre defusicacion con maximo, con momento o ambas, respectivamente: " )
    (bind ?tipo_deffuzy (read))
    (assert (tipo_deffuzy ?tipo_deffuzy))
    (bind ?velocidad_fuzzify (fuzzify velocidad-relativa ?velocidad 0))
    (assert (coche (id ?id) (distancia ?distancia) (velocidad-relativa ?velocidad) (presion-freno -1) (warning 0)))
)



