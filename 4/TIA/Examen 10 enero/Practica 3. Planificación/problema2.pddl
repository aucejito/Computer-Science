;;./mips-xxl -o dominio2.pddl -f problema2.pddl -O
;;./lpg-td-1.0 -o dominio2.pddl -f problema2.pddl -n 3

(define (problem problema)
    (:domain transportar_paquetes)
    (:objects 
        ;; Paquetes
        p1 - paquete_ligero
        p2 - paquete_pesado

        ;; Camiones
        c1 - camion
        c2 - camion

        ;; Conductores
        d1 - camionero
        d2 - camionero

        ;; Ciudades
        A - ciudad
        B - ciudad
        C - ciudad
        D - ciudad
        E - ciudad        
    )

    (:init 
        ;; Estado inicial de paquetes, camiones y conductores
        (esta p1 A)
        (esta p2 D)
        (esta c1 A)
        (esta c2 A)
        (esta d1 C)
        (esta d2 D)

        ;; estado inicial de grúas
        (grua-disponible A)
        (grua-disponible B)
		(grua-disponible C)
		(grua-disponible D)
		(grua-disponible E)

        ;; estado de los camiones
        (camion-vacio c1)
        (camion-vacio c2)

        ;; Desplazamientos entre dos ciudades (izq -> der)
        (= (duracion A B) 4)
        (= (coste A B) 1)
        (conectada A B)

        (= (duracion A C) 2)
        (= (coste A C) 1)
        (conectada A C)

        (= (duracion B A) 4)
        (= (coste B A) 1)
        (conectada B A)

        (= (duracion B C) 3)
        (= (coste B C) 2)
        (conectada B C)

        (= (duracion B D) 3)
        (= (coste B D) 3)
        (conectada B D)

        (= (duracion B E) 4)
        (= (coste B E) 3)
        (conectada B E)

        (= (duracion C A) 2)
        (= (coste C A) 1)
        (conectada C A)

        (= (duracion C B) 3)
        (= (coste C B) 2)
        (conectada C B)

        (= (duracion C E) 9)
        (= (coste C E) 6)
        (conectada C E)

        (= (duracion D B) 3)
        (= (coste D B) 3)
        (conectada D B)

        (= (duracion E B) 4)
        (= (coste E B) 3)
        (conectada E B)

        (= (duracion E C) 9)
        (= (coste E C) 6)
        (conectada E C)

        ;; Cargar paquete ligero
        (= (duracion-carga-ligera) 1)
        (= (coste-carga-ligera) 2)

        ;; Descargar paquete ligero
        (= (duracion-descarga-ligera) 1)
        (= (coste-descarga-ligera) 2)

        ;; Cargar paquete pesado
        (= (duracion-carga-pesada) 2)
        (= (coste-carga-pesada) 4)

        ;; Descargar paquete pesado
        (= (duracion-descarga-pesada) 2)
        (= (coste-descarga-pesada) 4)

        ;; Subir y bajar del camion
        (= (duracion-subir) 1)
        (= (coste-subir) 1)
        (= (duracion-bajar) 1)
        (= (coste-bajar) 1)
        
        ;; Viajar en autobus
        (= (duracion-bus) 10)
        (= (coste-bus) 3)

        ;; Variables totales
        (= (coste-total) 0)        
    )

    (:goal 
        ;; estado final de paquetes, camiones y conductores
        (and
        (esta p1 E)
        (esta p2 C)
        (esta c2 A)
        (esta d1 B))        
    )

    (:metric 
        ;; Funcion de optimiación (minimizar)
        minimize(+ (* 0.2 (total-time)) (* 0.5 (coste-total)))        
    )
)