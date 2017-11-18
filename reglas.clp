(defrule inicio
(declare (salience 100))
=>
(assert (busqueda (ingredientes barbacoa) (tipo_plato null) (estilo ITALIANO)))
(set-strategy random)
;;(dribble-on)
)
(defrule mensaje_error
(declare (salience 95))
(busqueda (estilo ?busq_e) (tipo_plato ?busq_tp) (ingredientes $? ?busq_ing))
(test (eq ?busq_e null))
(test (eq ?busq_tp null))
(test (eq ?busq_ing null))
=>
(printout t "*********Error: Busqueda no definida*********" crlf)
(halt)
)

(defrule filtrar_recetas
(declare (salience 90))
(busqueda (estilo ?busq_e) (tipo_plato ?busq_tp) (ingredientes $? ?busq_ing))
?ob<-(object (is-a ?obj_e&RECETA)(id_receta ?id)(tipo_plato ?obj_tp) (elegido false))
(test(or
	(superclassp ?busq_e ?obj_e)
	(eq ?busq_e ?obj_e)
	(eq ?busq_e null)
))
(test(or
	(eq ?busq_tp ?obj_tp)
	(eq ?busq_tp null)
))
(or
	(test (eq ?busq_ing null))
	(forall (busqueda (ingredientes $? ?ingrediente_receta $?))
			(object (is-a ?obj_e) (id_receta ?id) (ingredientes $? ?ingrediente_receta $?)))
)
=>
(modify-instance ?ob (elegido true))
(printout t ?obj_e crlf)
)


(defrule generar_plantilla_receta_1
(declare (salience 85))
(object (is-a ?obj_e&RECETA) (id_receta ?id) (elegido true) (generado false))
(object (is-a INGREDIENTE_RECETA) (id_receta ?id) (id_ingrediente ?id_ing) (paso ?p) (cantidad ?cant) (generado false) (tipo ?tipo))
(busqueda (ingredientes $? ?id_ing $?))
=>

;;;;CAMBIAR EL NUEVO ID DE RECETA!!!!!;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(make-instance of INGREDIENTE_RECETA_GEN (id_receta new) (id_ingrediente ?id_ing) (paso ?p) (cantidad ?cant) (generado true) (tipo ?tipo) (fijado true))
;;(make-instance of RECETA_GENERADA) (id_receta new) (basado_en ?id) (generado true) (tipo_plato pizza) (num_ingredientes 3 ))
)

(defrule generar_plantilla_receta_2
(declare (salience 80))
(object (is-a ?obj_e&RECETA) (id_receta ?id) (elegido true) (generado false))
(object (is-a INGREDIENTE_RECETA) (id_receta ?id) (id_ingrediente ?id_ing) (paso ?p) (cantidad ?cant) (generado false) (tipo ?tipo))
(not (object (is-a INGREDIENTE_RECETA) (id_ingrediente ?id_ing) (paso ?p) (cantidad ?cant) (generado true)))
=>

;;;;CAMBIAR EL NUEVO ID DE RECETA!!!!!;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(make-instance of INGREDIENTE_RECETA_GEN (id_receta new) (id_ingrediente CAMBIAR) (paso ?p) (cantidad ?cant) (generado true) (tipo ?tipo))
;;(make-instance of RECETA_GENERADA) (id_receta new) (basado_en ?id) (generado true) (tipo_plato pizza) (num_ingredientes 3 ))
)

;;Suponemos que todas las recetas tienen al menos 2 ingredientes
;;La primera regla es cuando no hay ningun ingrediente fijado. Fijamos la tupla que tiene la maxima sinergia (segun el tipo de ingrediente)

(defrule fijar_ingrediente_1
(declare (salience 75))
(not (object (is-a INGREDIENTE_RECETA_GEN)(id_receta ?id)(id_ingrediente ~CAMBIAR)))

?ing1<-(object (is-a INGREDIENTE_RECETA_GEN) (id_receta ?id) (id_ingrediente CAMBIAR) (tipo ?tipo1) (fijado false))
?ing2<-(object (is-a INGREDIENTE_RECETA_GEN) (id_receta ?id) (id_ingrediente CAMBIAR) (tipo ?tipo2) (fijado false))

(object (is-a ?tipo1&INGREDIENTE) (id_ingrediente ?id_ing1))
(object (is-a ?tipo2&INGREDIENTE) (id_ingrediente ?id_ing2))
(object (is-a ?tipo1&INGREDIENTE) (id_ingrediente ?id_ing3))
(object (is-a ?tipo2&INGREDIENTE) (id_ingrediente ?id_ing4))

(object (is-a SINERGIA) (id_ingrediente1 ?id_ing1) (id_ingrediente2 ?id_ing2) (grado ?g1))

(and
	(not (object (is-a SINERGIA) (id_ingrediente1 ?id_ing1) (id_ingrediente2 ?id_ing4) (grado ?g2&:(> ?g2 ?g1))))
	(not (object (is-a SINERGIA) (id_ingrediente1 ?id_ing3) (id_ingrediente2 ?id_ing2) (grado ?g3&:(> ?g3 ?g1))))
)

=>
(modify-instance ?ing1 (id_ingrediente ?id_ing1) (fijado true))
(modify-instance ?ing2 (id_ingrediente ?id_ing2) (fijado true))
)

;;Si ya hay ingredientes fijados, el siguiente ingrediente a añadir es el que tiene el grado de sinergia mas alto con alguno de los ingredientes introducidos
(defrule fijar_ingrediente_2
(declare (salience 70))
(object (is-a INGREDIENTE_RECETA_GEN) (id_receta ?id) (id_ingrediente ?id_ing1) (fijado true))
?ing2<-(object (is-a INGREDIENTE_RECETA_GEN) (id_receta ?id) (id_ingrediente CAMBIAR) (tipo ?tipo2) (fijado false))

(object (is-a ?tipo2&INGREDIENTE) (id_ingrediente ?id_ing2))
(object (is-a ?tipo2&INGREDIENTE) (id_ingrediente ?id_ing3))

(object (is-a SINERGIA) (id_ingrediente1 ?id_ing1) (id_ingrediente2 ?id_ing2) (grado ?g1))
(not (object (is-a SINERGIA) (id_ingrediente1 ?id_ing1) (id_ingrediente2 ?id_ing3) (grado ?g2&:(> ?g2 ?g1))))

=>
(modify-instance ?ing2 (id_ingrediente ?id_ing2) (fijado true))
)
































