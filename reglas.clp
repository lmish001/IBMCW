
(definstances ingredientes
([i1] of CARNE (id_ingrediente carne))
([i2] of SALSA (id_ingrediente boloñesa))
([i3] of VERDURA (id_ingrediente tomate))
([i4] of QUESO (id_ingrediente mozarella))
([i5] of CEREALES (id_ingrediente masa))
)

(definstances platos
([pl1] of TIPO_PLATO (id_plato pizza))
)

(definstances receta1 
([p11] of PASO (id_receta "Pizza con queso") (orden 1) (descripcion "Preparar la masa: ") (ingredientes masa carne))
([p12] of PASO (id_receta "Pizza con queso") (orden 2) (descripcion "Preparar los toppings: ") (ingredientes queso))
([p13] of PASO (id_receta "Pizza con queso") (orden 3) (descripcion "Hornear la pizza"))
([i1p1] of INGREDIENTE_RECETA (id_ingrediente masa) (id_receta "Pizza con queso") (paso 1) (cantidad 200))
([i2p1] of INGREDIENTE_RECETA (id_ingrediente carne) (id_receta "Pizza con queso")(paso 1)(cantidad 50))
([i1p2] of INGREDIENTE_RECETA (id_ingrediente mozarella) (id_receta "Pizza con queso")(paso 2) (cantidad 150))
([r1] of ITALIANO (id_receta "Pizza con queso") (tipo_plato pizza) (ingredientes carne queso masa) (num_ingredientes 3))
)

(defrule inicio
(declare (salience 100))
=>
(assert (busqueda (ingredientes  queso mozarella carne) (tipo_plato null) (estilo ITALIANO)))
(set-strategy random)
;;(dribble-on)
)


(defrule filtrar_por_ingredientes
(declare (salience 6))
(busqueda (estilo ?busq_e) (tipo_plato ?busq_tp))
?ob<-(object (is-a ?obj_e&RECETA)(id_receta ?id)(tipo_plato ?obj_tp) (elegido false))
(test(or
	(eq ?busq_e ?obj_e)
	(eq ?busq_e null)
))
(test(or
	(eq ?busq_tp ?obj_tp)
	(eq ?busq_tp null)
))
(forall (busqueda (ingredientes $? ?ingrediente_receta $?))
(object (is-a ?obj_e) (id_receta ?id) (ingredientes $? ?ingrediente_receta $?))
)

=>
(modify-instance ?ob (elegido true))
)




