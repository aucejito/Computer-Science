;;./mips-xxl -o dominio.pddl -f problema.pddl -O
;;./lpg-td-1.0 -o dominio.pddl -f problema.pddl -n 3

(define (problem problema-logistica)
    (:domain packages_distribution)
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
        (Esta p1 A)
        (Esta p2 D)
        (Esta c1 A)
        (Esta c2 A)
        (Esta d1 C)
        (Esta d2 D)

        ;; Estado inicial de grúas
        (Grua A)
        (Grua B)
		(Grua C)
		(Grua D)
		(Grua E)

        ;; Estado de loos camiones
        (Camion_vacio c1)
        (Camion_vacio c2)

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
        (= (duracion_carga_ligera) 1)
        (= (coste_carga_ligera) 2)

        ;; Desargar paquete ligero
        (= (duracion_descarga_ligera) 1)
        (= (coste_descarga_ligera) 2)

        ;; Cargar paquete pesado
        (= (duracion_carga_pesada) 2)
        (= (duracion_carga_pesada) 4)

        ;; Desargar paquete pesado
        (= (duracion_descarga_pesada) 2)
        (= (duracion_descarga_pesada) 4)

        ;; Subir y bajar del camion
        (= (duracion_subir) 1)
        (= (coste_subir) 1)
        (= (duracion_bajar) 1)
        (= (coste_bajar) 1)
        
        ;; Viajar en autobus
        (= (duracion_bus) 10)
        (= (coste_bus) 3)

        ;; Variables totales
        (= (coste_total) 0)        
    )

    (:goal 
        ;; Estado final de paquetes, camiones y conductores
        (and
        (Esta p1 E)
        (Esta p2 C)
        (Esta c2 A)
        (Esta d1 B))        )

    (:metric 
        ;; Funcion de optimiación (minimizar)
        minimize(+ (* 0.2 (total-time)) (* 0.5 (coste_total)))        
    )
)