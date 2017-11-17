


(defrule inicio
(declare (salience 100))
=>
(assert (busqueda (ingredientes  queso mozarella carne) (tipo_plato null) (estilo ITALIANO)))
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
(object (is-a INGREDIENTE_RECETA) (id_receta ?id) (id_ingrediente ?id_ing) (paso ?p) (cantidad ?cant) (generado false))
(busqueda (ingredientes $? ?id_ing $?))
=>
(make-instance of INGREDIENTE_RECETA (id_receta new) (id_ingrediente ?id_ing) (paso ?p) (cantidad ?cant) (generado true))
)

(defrule generar_plantilla_receta_2
(declare (salience 80))
(object (is-a ?obj_e&RECETA) (id_receta ?id) (elegido true) (generado false))
(object (is-a INGREDIENTE_RECETA) (id_receta ?id) (id_ingrediente ?id_ing) (paso ?p) (cantidad ?cant) (generado false))
(not (object (is-a INGREDIENTE_RECETA) (id_ingrediente ?id_ing) (paso ?p) (cantidad ?cant) (generado true)))
=>
(make-instance of INGREDIENTE_RECETA (id_receta new) (id_ingrediente CAMBIAR) (paso ?p) (cantidad ?cant) (generado true))
)

