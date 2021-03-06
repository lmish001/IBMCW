(defrule inicio
(declare (salience 100))
=>
(set-strategy random)
(dribble-on "dribble.txt")
)
(defrule mensaje_error
(declare (salience 95))
(busqueda (estilo ?busq_e) (tipo_plato ?busq_tp) (ingredientes $? ?busq_ing))
(test (eq ?busq_e null))
(test (eq ?busq_tp null))
(test (eq ?busq_ing null))
=>
(printout t "_________________Error: Busqueda no definida_________________" crlf)
(halt)
)


(defrule filtrar_recetas
(declare (salience 90))
(busqueda (estilo ?busq_e) (tipo_plato ?busq_tp) (ingredientes $? ?busq_ing))
?ob<-(object (is-a ?obj_e&RECETA)(id_receta ?id)(tipo_plato ?obj_tp) (elegido false) (generado false))
(test(or
	(superclassp ?busq_e ?obj_e)
	(eq ?busq_e ?obj_e)
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
(printout t "Se ha seleccionado la receta: " ?id crlf)
)



(defrule generar_plantilla_receta
(declare (salience 85))
(object (is-a RECETA) (id_receta ?id) (tipo_plato ?tipo_plato) (elegido true) (generado false) (num_ingredientes ?num))
(not (object (is-a RECETA_GENERADA)(basado_en ?id)))
=>
(make-instance of RECETA_GENERADA (id_receta (str-cat ?tipo_plato " basado en " ?id)) (tipo_plato ?tipo_plato) (basado_en ?id) (num_ingredientes ?num) (generado true))
(printout t "Generada receta basada en: " ?id crlf)
)


(defrule generar_plantilla_paso
(declare (salience 80))
(object (is-a RECETA) (id_receta ?id))
(object (is-a RECETA_GENERADA) (id_receta ?id1) (basado_en ?id))
(object (is-a PASO) (id_receta ?id) (orden ?o) (descripcion ?d))
(not (object (is-a PASO_GENERADO)(id_receta ?id1) (orden ?o)))
=>
(make-instance of PASO_GENERADO (id_receta ?id1) (orden ?o) (descripcion ?d))
(printout t "Paso " ?o ", generado para receta: " ?id1 crlf)
)

(defrule generar_plantilla_ingrediente_1
(declare (salience 75))
(object (is-a RECETA) (id_receta ?id) (tipo_plato ?tipo_plato) (elegido true))
(object (is-a INGREDIENTE_RECETA) (id_receta ?id) (id_ingrediente ?id_ing) (paso ?p) (cantidad ?cant) (tipo ?tipo_ing))
(busqueda (ingredientes $? ?id_ing $?))
=>

(make-instance of INGREDIENTE_RECETA_GEN (id_receta (str-cat ?tipo_plato " basado en " ?id)) (id_ingrediente ?id_ing) (paso ?p) (cantidad ?cant) (tipo ?tipo_ing) (fijado true))
(printout t "Ingrediente " ?id_ing ", fijado para receta: " (str-cat ?tipo_plato " basado en " ?id) crlf)
)

(defrule generar_plantilla_ingrediente_2
(declare (salience 70))
(object (is-a RECETA) (id_receta ?id) (tipo_plato ?tipo_plato) (elegido true))
(object (is-a INGREDIENTE_RECETA) (id_receta ?id) (id_ingrediente ?id_ing) (paso ?p) (cantidad ?cant)(tipo ?tipo_ing))
(not (object (is-a INGREDIENTE_RECETA_GEN) (id_ingrediente ?id_ing) (paso ?p) (cantidad ?cant)))
=>

(make-instance of INGREDIENTE_RECETA_GEN (id_receta (str-cat ?tipo_plato " basado en " ?id)) (id_ingrediente CAMBIAR) (paso ?p) (cantidad ?cant) (tipo ?tipo_ing))
(printout t "Falta por fijar ingrediente de tipo " ?tipo_ing ", para receta: " (str-cat ?tipo_plato " basado en " ?id) crlf)
)

;;Suponemos que todas las recetas tienen al menos 2 ingredientes
;;La primera regla es cuando no hay ningun ingrediente fijado. Fijamos la tupla que tiene la maxima sinergia (segun el tipo de ingrediente)

(defrule fijar_ingrediente_1
(declare (salience 65))
(object (is-a RECETA_GENERADA) (id_receta ?id))
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
(declare (salience 60))
(object (is-a INGREDIENTE_RECETA_GEN) (id_receta ?id) (id_ingrediente ?id_ing1) (fijado true))
?ing2<-(object (is-a INGREDIENTE_RECETA_GEN) (id_receta ?id) (id_ingrediente CAMBIAR) (tipo ?tipo2) (fijado false))

(object (is-a ?tipo2&INGREDIENTE) (id_ingrediente ?id_ing2))
(object (is-a ?tipo2&INGREDIENTE) (id_ingrediente ?id_ing3))

(object (is-a SINERGIA) (id_ingrediente1 ?id_ing1) (id_ingrediente2 ?id_ing2) (grado ?g1))
(not (object (is-a SINERGIA) (id_ingrediente1 ?id_ing1) (id_ingrediente2 ?id_ing3) (grado ?g2&:(> ?g2 ?g1))))

=>
(modify-instance ?ing2 (id_ingrediente ?id_ing2) (fijado true))
(printout t "Sinergia optima encontrada: " ?id_ing2 ", grado: " ?g1 ", para receta: " ?id crlf)
)

(defrule incluir_ing_receta
(declare (salience 55))
?ing<-(object (is-a INGREDIENTE_RECETA_GEN) (id_receta ?id) (id_ingrediente ?id_ing) (fijado true) (incluir_receta false))
?receta<-(object (is-a RECETA_GENERADA) (id_receta ?id) (ingredientes $?x))
=>
(modify-instance ?ing (incluir_receta true))
(modify-instance ?receta (ingredientes $?x ?id_ing))
)

(defrule incluir_ing_paso
(declare (salience 50))
?ing<-(object (is-a INGREDIENTE_RECETA_GEN) (id_receta ?id) (id_ingrediente ?id_ing) (paso ?p) (fijado true) (incluir_paso false))
?paso<-(object (is-a PASO_GENERADO) (id_receta ?id) (orden ?p) (ingredientes $?x))
=>
(modify-instance ?ing (incluir_paso true))
(modify-instance ?paso (ingredientes $?x ?id_ing))
)

(defrule imprimir_receta
(declare (salience 45))
?rec<-(object (is-a RECETA_GENERADA)(id_receta ?id)(tipo_plato ?tp)(num_ingredientes ?ni)(impreso false))
(not(object (is-a IMPRIMIR) (imprimiendo true) (acabado false)))
;;(not(imprimiendo true))
;;(not(imprimir_pasos ?id))
=>
(printout t "_______________________________________" crlf)
(printout t "Receta generada: " ?id crlf)
(printout t "	tipo de plato: " ?tp crlf)
(printout t "	ingredientes: " crlf)
(make-instance of IMPRIMIR (id_receta ?id) (imprimiendo true) (acabado false))
(modify-instance ?rec (impreso true))
;;(assert (imprimir_pasos ?id))
;;(assert (imprimir_ingredientes ?id))
;;(assert (paso 1))
;;(assert (imprimiendo true))
)

(defrule imprimir_ingredientes
(declare (salience 42))
;;(imprimir_ingredientes ?id)
(object (is-a IMPRIMIR) (imprimiendo true) (acabado false) (id_receta ?id))
?ingrediente<-(object (is-a INGREDIENTE_RECETA)(id_receta ?id)(id_ingrediente ?i)(cantidad ?c)(impreso false))
=>
(printout t "		"?i", " ?c"g" crlf)
;;(modify-instance ?imprimir (paso (+ 1 ?p)))
(modify-instance ?ingrediente (impreso true))
)

(defrule imprimir_pasos
(declare (salience 40))
;;(imprimir_pasos ?id)
?imprimir<-(object (is-a IMPRIMIR) (imprimiendo true) (acabado false) (id_receta ?id) (paso ?p))
;;?po <-(paso ?o)
?paso_gen<-(object (is-a PASO_GENERADO) (id_receta ?id)(orden ?p)(descripcion ?d)(ingredientes $?ings)(impreso false))
=>
(printout t "	Paso "?p": " ?d $?ings crlf)
;;(retract ?po)
;;(assert (paso (+ ?o 1)))
(modify-instance ?imprimir (paso (+ ?p 1)))
(modify-instance ?paso_gen (impreso true))
)

(defrule reset_imprimir
(declare (salience 47))
?imprimir<-(object (is-a IMPRIMIR) (imprimiendo true) (acabado false) (id_receta ?id) (paso ?p))
;;?ip<-(imprimir_pasos ?id)
;;?ii<-(imprimir_ingredientes ?id)
;;?po <-(paso ?o)
;;?i <- (imprimiendo true)
(not (object (is-a PASO_GENERADO) (id_receta ?id)(orden ?p)(impreso false)))
=>
(modify-instance ?imprimir (acabado true) (imprimiendo false))
;;(retract ?i)
;;(retract ?po)
)

(defrule recetas_no_encontradas
(declare (salience 45))
(not (object (is-a RECETA) (elegido true)))
=>
(printout t "No ha sido posible generar una receta a partir de los criterios de busqueda introducidos." crlf)
(dribble-off)
)

(defrule finalizar
(declare (salience 5))
=>
(dribble-off)
)


























