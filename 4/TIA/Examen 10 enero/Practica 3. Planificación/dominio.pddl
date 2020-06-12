;; Transportar paquetes

(define (domain packages_distribution)

(:requirements 
  :typing :durative-actions :fluents
)

;; Types
;;  camion: Un vehiculo grande
;;  paquete_ligero: Paquete que pesa poco
;;  paquete_pesado: Paquete que pesa mucho
;;  ciudad: Un lugar
;;  camionero: Persona que conduce el camion

(:types camion paquete_ligero paquete_pesado ciudad camionero - object)


;;Predicados - Ingormacion booleana que es Verdad
(:predicates

  ;; Indica si esta conectada una ciudad con otra
  (conectada ?ciudad1 - ciudad ?ciudad2 - ciudad)

  ;; Indica si un paquete, camionero o camion esta en una ciudad/camion
  (Esta ?x - (either paquete_ligero paquete_pesado camionero camion) ?c - ciudad)
  (Esta_montado ?x - (either paquete_ligero paquete_pesado camionero) ?c - camion)

  ;; Indica si una grúa está disponible en una ciudad
  (Grua ?c - ciudad)

  ;;Indica si el caminon esta vacio
  (Camion_vacio ?camion - camion)
)

;;Funciones

(:functions

  ;; Coste y duracion entre dos ciudades 
  (duracion ?a ?b - ciudad)
  (coste ?a ?b - ciudad)
  
  ;;Cargar paquete ligero
  (coste_carga_ligera)
  (duracion_carga_ligera)
  
  ;;Descargar paquete ligero
  (coste_descarga_ligera)
  (duracion_descarga_ligera)
  
  ;;Cargar paquete pesado
  (coste_carga_pesada)
  (duracion_carga_pesada)
  
  ;;Descargar paquete pesado
  (coste_descarga_pesada)
  (duracion_descarga_pesada)
  
  ;;Subir y bajar del camion
  (duracion_subir)
  (duracion_bajar)
  (coste_subir)
  (coste_bajar)
  
  ;;Viajar en bus
  (duracion_bus)
  (coste_bus)

  ;;Variables totales
  (coste_total)
)

;;Acciones
(:durative-action subir_conductor ;Subir conductor al camion
  :parameters (?camion - camion ?camionero - camionero ?ciudad - ciudad)
  :duration (= ?duration (duracion_subir))
  :condition (and 
             (at start (Esta ?camionero ?ciudad))
             (over all (Esta ?camion ?ciudad))
             (over all (Camion_vacio ?camion)))
  :effect (and
             (at start (not (Esta ?camionero ?ciudad)))
             (at end (Esta ?camion ?ciudad))
             (at end(not (Camion_vacio ?camion)))
             (increase (coste_total) (coste_subir))
  )
)

(:durative-action bajar_conductor ;Bajar conductor del camion
  :parameters (?camion - camion ?camionero - camionero ?ciudad - ciudad)
  :duration (= ?duration (duracion_bajar))
  :condition (and 
             (at start (Esta_montado ?camionero ?camion))
             (over all (Esta ?camion ?ciudad)))
  :effect (and
             (at start (not (Esta_montado ?camionero ?camion)))
             (at end (Esta ?camionero ?ciudad))
             (at end (Camion_vacio ?camion))
             (increase (coste_total) (coste_bajar))
  )
)

(:durative-action cargar_paquete_ligero ;Cargar paquete ligero en camion
  :parameters (?camion - camion ?paquete - paquete_ligero ?ciudad - ciudad)
  :duration (= ?duration (duracion_carga_ligera))
  :condition (and 
             (at start (Esta ?paquete ?ciudad))
             (over all (Esta ?camion ?ciudad)))
  :effect (and
             (at start (not (Esta ?paquete ?ciudad)))
             (at end (Esta_montado ?paquete ?camion))
             (increase (coste_total) (coste_carga_ligera))
  )
)

(:durative-action descargar_paquete_ligero ;Descargar paquete ligero en ciudad
  :parameters (?camion - camion ?paquete - paquete_ligero ?ciudad - ciudad)
  :duration (= ?duration (duracion_descarga_ligera))
  :condition (and 
             (at start (Esta_montado ?paquete ?camion))
             (over all (Esta ?camion ?ciudad)))
  :effect (and
             (at start (not (Esta_montado ?paquete ?camion)))
             (at end (Esta ?paquete ?ciudad))
             (increase (coste_total) (coste_descarga_ligera))
  )
)

(:durative-action cargar_paquete_pesado ;Cargar paquete pesado en camion
  :parameters (?camion - camion ?paquete - paquete_pesado ?ciudad - ciudad)
  :duration (= ?duration (duracion_carga_pesada))
  :condition (and 
             (at start (Esta ?paquete ?ciudad))
             (at start (Grua ?ciudad))
             (over all (Esta ?camion ?ciudad)))
  :effect (and
             (at start (not (Grua ?ciudad)))
             (at start (not (Esta ?paquete ?ciudad)))
             (at end (Esta_montado ?paquete ?camion))
             (at end (Grua ?ciudad))
             (increase (coste_total) (coste_carga_pesada))
  )
)

(:durative-action descargar_paquete_pesado ;Descargar paquete pesado en ciudad
  :parameters (?camion - camion ?paquete - paquete_pesado ?ciudad - ciudad)
  :duration (= ?duration (duracion_descarga_pesada))
  :condition (and 
             (at start (Esta_montado ?paquete ?camion))
             (at start (Grua ?ciudad))
             (over all (Esta ?camion ?ciudad)))
  :effect (and
             (at start (not (Grua ?ciudad)))
             (at start (not (Esta_montado ?paquete ?camion)))
             (at end (Esta ?paquete ?ciudad))
             (at end (Grua ?ciudad))
             (increase (coste_total) (coste_descarga_pesada))
  )
)

(:durative-action descargar_paquete_pesado ;Descargar paquete pesado en ciudad
  :parameters (?camion - camion ?paquete - paquete_pesado ?ciudad - ciudad)
  :duration (= ?duration (duracion_descarga_pesada))
  :condition (and 
             (at start (Esta_montado ?paquete ?camion))
             (at start (Grua ?ciudad))
             (over all (Esta ?camion ?ciudad)))
  :effect (and
             (at start (not (Grua ?ciudad)))
             (at start (not (Esta_montado ?paquete ?camion)))
             (at end (Esta ?paquete ?ciudad))
             (at end (Grua ?ciudad))
             (increase (coste_total) (coste_descarga_pesada))
  )
)

(:durative-action conducir ;Conducir de una ciudad a otra
  :parameters (?camion - camion ?camionero - camionero ?ciudad_origen ?ciudad_destino - ciudad)
  :duration (= ?duration (duracion ?ciudad_origen ?ciudad_destino))
  :condition (and 
             (at start (Esta ?camion ?ciudad_origen))
             (at start (conectada ?ciudad_origen ?ciudad_destino)) 
             (at start (Esta_montado ?camionero ?camion))
             (at start (not (Camion_vacio ?camion)))
             (over all (Esta_montado ?camionero ?camion))
             )
  :effect (and
             (at start (not (Esta ?camion ?ciudad_origen)))
             (at end (Esta ?camion ?ciudad_destino))
             (increase (coste_total) (coste ?ciudad_origen ?ciudad_destino))
  )
)

(:durative-action bus ;Ir en bus de una ciudad a otra
  :parameters (?camionero - camionero ?ciudad_origen ?ciudad_destino - ciudad)
  :duration (= ?duration (duracion ?ciudad_origen ?ciudad_destino))
  :condition (and 
             (at start (conectada ?ciudad_origen ?ciudad_destino)) 
             (at start (Esta ?camionero ?ciudad_origen))
             )
  :effect (and
             (at start (not (Esta ?camionero ?ciudad_origen)))
             (at end (Esta ?camionero ?ciudad_destino))
             (increase (coste_total) (coste ?ciudad_origen ?ciudad_destino))
  )
)

)

