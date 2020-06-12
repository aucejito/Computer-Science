;; Transportar paquetes

(define (domain transportar_paquetes)

  ;;-------------------------------------------------------------------------
  ;;Requisitos

    (:requirements
      :durative-actions :typing :fluents
    )
  ;;-------------------------------------------------------------------------

  ;; Tipos

  ;;  camion: Un vehiculo grande
  ;;  paquete_ligero: Paquete que pesa poco
  ;;  paquete_pesado: Paquete que pesa mucho
  ;;  ciudad: Un lugar
  ;;  camionero: Persona que conduce el camion

  (:types camion paquete_ligero paquete_pesado ciudad camionero - object)
  ;;-------------------------------------------------------------------------

  ;;Predicados (informacion booleana que es verdad)

  (:predicates

    ;;Ciudad en la que está un camion, camionero o paquete_ligero
    (esta ?x - (either camion camionero paquete_ligero paquete_pesado) ?ciudad - ciudad)

    ;;Camion en el que esta un conductor o paquete_ligero
    (montado ?x - (either camionero paquete_ligero paquete_pesado) ?camion - camion)

    ;;Conexion entre las ciudades
    (conectada ?ciudad1 ?ciudad2 - ciudad)

    ;;Disponibilidad de grua en las ciudades
    (grua-disponible ?ciudad - ciudad)

    ;;Camion sin comionero
    (camion-vacio ?camion - camion)
  
  )

  ;;-------------------------------------------------------------------------

  ;;Funciones
  
  (:functions
  
    ;; Coste y duracion entre dos ciudades 
    (duracion ?ciudad1 ?ciudad2 - ciudad)
    (coste ?ciudad1 ?ciudad2 - ciudad)
    
    ;;Cargar paquete ligero
    (coste-carga-ligera)
    (duracion-carga-ligera)
    
    ;;Descargar paquete ligero
    (coste-descarga-ligera)
    (duracion-descarga-ligera)
    
    ;;Cargar paquete pesado
    (coste-carga-pesada)
    (duracion-carga-pesada)
    
    ;;Descargar paquete pesado
    (coste-descarga-pesada)
    (duracion-descarga-pesada)
    
    ;;Subir y bajar del camion
    (duracion-subir)
    (duracion-bajar)
    (coste-subir)
    (coste-bajar)
    
    ;;Viajar en bus
    (duracion-bus)
    (coste-bus)

    ;;Variables totales
    (coste-total)
  
  )

  ;;-------------------------------------------------------------------------
  
  ;; Acciones
  ;;****************************************************
  ;;Cargar paquete pesado

  (:durative-action cargar-paquete-pesado

    :parameters(
      ?camion - camion
      ?ciudad - ciudad
      ?paquete_pesado - paquete_pesado
    )

    :duration (= ?duration (duracion-carga-pesada))

    :condition
      (and

        ;;Grua disponible en la ciudad
        (at start (grua-disponible ?ciudad))

        ;;Camion esta en la ciudad
        (over all (esta ?camion ?ciudad))

        ;;Paquete en la ciudad
        (at start (esta ?paquete_pesado ?ciudad))

      )

    :effect
      (and
      
        ;;Grua no disponible durante la carga
        (at start (not (grua-disponible ?ciudad)))

        ;;Paquete ya no esta en la ciudad
        (at start (not (esta ?paquete_pesado ?ciudad)))

        ;;Paquete en el camion
        (at end (montado ?paquete_pesado ?camion))

        ;;Grua ya esta disponible
        (at end (grua-disponible ?ciudad))
        
        ;;Incrementamos el coste total
        (at end (increase (coste-total) (coste-carga-pesada)))

      )
  )

  ;;****************************************************
  ;;Descarga paquete pesado

  (:durative-action descargar-paquete-pesado

    :parameters(
      ?camion - camion
      ?ciudad - ciudad
      ?paquete_pesado - paquete_pesado
    )

    :duration (= ?duration (duracion-descarga-pesada))

    :condition
      (and

        ;;Grua disponible en la ciudad
        (at start (grua-disponible ?ciudad))

        ;;Camion esta en la ciudad
        (over all (esta ?camion ?ciudad))

        ;;Paquete en el camion
        (at start (montado ?paquete_pesado ?camion))

      )

    :effect
      (and
      
        ;;Grua no disponible durante la descarga
        (at start (not (grua-disponible ?ciudad)))

        ;;Paquete ya no esta en el camion
        (at start (not (montado ?paquete_pesado ?camion)))

        ;;Paquete en la ciudad
        (at end (esta ?paquete_pesado ?ciudad))

        ;;Grua ya esta disponible
        (at end (grua-disponible ?ciudad))
        
        ;;Incrementamos el coste total
        (at end (increase (coste-total) (coste-descarga-pesada)))

      )
  )

  ;;****************************************************
  ;;Carga paquete ligero

  (:durative-action cargar-paquete-ligero

    :parameters(
      ?camion - camion
      ?ciudad - ciudad
      ?paquete_ligero - paquete_ligero
    )

    :duration (= ?duration (duracion-carga-ligera))

    :condition
      (and

        ;;Camion esta en la ciudad
        (over all (esta ?camion ?ciudad))

        ;;Paquete en la ciudad
        (at start (esta ?paquete_ligero ?ciudad))

      )

    :effect
      (and

        ;;Paquete ya no esta en la ciudad
        (at start (not (esta ?paquete_ligero ?ciudad)))

        ;;Paquete en el camion
        (at end (montado ?paquete_ligero ?camion))
        
        ;;Incrementamos el coste total
        (at end (increase (coste-total) (coste-carga-ligera)))

      )
  )

  ;;****************************************************
  ;;Descarga paquete ligero

  (:durative-action descargar-paquete-ligero

    :parameters(
      ?camion - camion
      ?ciudad - ciudad
      ?paquete_ligero - paquete_ligero
    )

    :duration (= ?duration (duracion-descarga-ligera))

    :condition
      (and

        ;;Camion esta en la ciudad
        (over all (esta ?camion ?ciudad))

        ;;Paquete en el camion
        (at start (montado ?paquete_ligero ?camion))

      )

    :effect
      (and

        ;;Paquete ya no esta en el camion
        (at start (not (montado ?paquete_ligero ?camion)))

        ;;Paquete en la ciudad
        (at end (esta ?paquete_ligero ?ciudad))
        
        ;;Incrementamos el coste total
        (at end (increase (coste-total) (coste-descarga-ligera)))

      )
  )

  ;;****************************************************
  ;;Conductor sube al camion

  (:durative-action subir-conductor

    :parameters(
      ?camion - camion
      ?camionero - camionero
      ?ciudad - ciudad
    )

    :duration (= ?duration (duracion-subir))

    :condition
      (and

        ;;Camion esta en la ciudad
        (over all (esta ?camion ?ciudad))

        ;;Camionero esta en la ciudad
        (at start (esta ?camionero ?ciudad))

        ;;El camion esta vacio
        (over all (camion-vacio ?camion))

      )

    :effect
      (and

        ;;Camionero ya no esta en la ciudad
        (at start (not (esta ?camionero ?ciudad)))

        ;;Camionero esta en el camion
        (at end (montado ?camionero ?camion))

        ;;Camion pasa a estar ocupado
        (at end(not (camion-vacio ?camion)))

        ;;Incrementamos el coste total
        (at end (increase (coste-total) (coste-subir)))

      )
  )

  ;;****************************************************
  ;;Conductor baja del camion

  (:durative-action bajar-conductor

    :parameters(
      ?camion - camion
      ?camionero - camionero
      ?ciudad - ciudad
    )

    :duration (= ?duration (duracion-bajar))

    :condition
      (and

        ;;Camion esta en la ciudad
        (over all (esta ?camion ?ciudad))

        ;;Camionero esta en el camion
        (at start (montado ?camionero ?camion))

      )

    :effect
      (and

        ;;Camionero ya no esta en em el camion
        (at start (not (montado ?camionero ?camion)))

        ;;Camionero esta en la ciudad
        (at end (esta ?camionero ?ciudad))

        ;;Camion pasa a estar vacio
        (at end (camion-vacio ?camion))

        ;;Incrementamos el coste total
        (at end (increase (coste-total) (coste-subir)))

      )
  )

  ;;****************************************************
  ;;Conductor conduce el camion de una ciudad a otra ciudad

  (:durative-action conducir-camion

    :parameters(
      ?camion - camion
      ?ciudad1 - ciudad
      ?ciudad2 - ciudad
    )

    :duration (= ?duration (duracion ?ciudad1 ?ciudad2))

    :condition
      (and

        ;;Camion esta en la ciudad1
        (at start (esta ?camion ?ciudad1))

        ;;Hay un camionero en el camion
        (at start (not (camion-vacio ?camion)))

        ;;Hay camino de la ciudad1 a ciudad2
        (over all (conectada ?ciudad1 ?ciudad2))

      )

    :effect
      (and

        ;;Camion ya no esta en ciudad1
        (at start (not (esta ?camion ?ciudad1)))

        ;;Camion esta en la ciudad2
        (at end (esta ?camion ?ciudad2))

        ;;Incrementamos el coste total
        (at end (increase (coste-total) (coste ?ciudad1 ?ciudad2)))

      )
  )

  ;;****************************************************
  ;;Conductor viaja en bus

  (:durative-action viajar-bus

    :parameters(
      ?camionero - camionero
      ?ciudad1 - ciudad
      ?ciudad2 - ciudad
    )

    :duration (= ?duration (duracion-bus))

    :condition
      (and

        ;;Camionero esta en la ciudad1
        (at start (esta ?camionero ?ciudad1))

        ;;Hay camino de la ciudad1 a ciudad2
        (over all (conectada ?ciudad1 ?ciudad2))

      )

    :effect
      (and

        ;;Camionero ya no esta en ciudad1
        (at start (not (esta ?camionero ?ciudad1)))

        ;;Camionero esta en la ciudad2
        (at end (esta ?camionero ?ciudad2))

        ;;Incrementamos el coste total
        (at end (increase (coste-total) (coste-bus)))

      )
  )


)