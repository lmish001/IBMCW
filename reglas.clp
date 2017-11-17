
(definstances ingredientes
([ing0] of CARNE (id_ingrediente ternera))
([ing1] of CARNE (id_ingrediente pollo))
([ing2] of CARNE (id_ingrediente pavo))
([ing3] of SALSA (id_ingrediente barbacoa))
([ing4] of SALSA (id_ingrediente bolognesa))
([ing5] of SALSA (id_ingrediente chile_picante))
([ing6] of PESCADO (id_ingrediente atun))
([ing7] of PESCADO (id_ingrediente salmon))
([ing8] of PESCADO (id_ingrediente emperados))
([ing9] of VERDURA (id_ingrediente tomate))
([ing10] of VERDURA (id_ingrediente lechuga))
([ing11] of LEGUMBRE (id_ingrediente judias_verdes))
([ing12] of LEGUMBRE (id_ingrediente repollo))
([ing13] of LEGUMBRE (id_ingrediente lentejas))
([ing14] of FRUTA (id_ingrediente naranja))
([ing15] of FRUTA (id_ingrediente manzana))
([ing16] of FRUTA (id_ingrediente platano))
([ing17] of PASTA (id_ingrediente macarrones))
([ing18] of PASTA (id_ingrediente ravioli))
([ing19] of QUESO (id_ingrediente parmesano))
([ing20] of QUESO (id_ingrediente queso_de_cabra))
([ing21] of CEREALES (id_ingrediente cereales_integrales))
([ing22] of CEREALES (id_ingrediente cereales_choco))
([ing23] of LIQUIDO (id_ingrediente caldo_de_pollo))
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
(busqueda (estilo ?busq_e) (tipo_plato ?busq_tp) (ingredientes $? ?busq_ing))
?ob<-(object (is-a ?obj_e&RECETA)(id_receta ?id)(tipo_plato ?obj_tp) (elegido false))
(test(or
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
(object (is-a ?obj_e) (id_receta ?id) (ingredientes $? ?ingrediente_receta $?))
)
)


=>
(modify-instance ?ob (elegido true))
)





