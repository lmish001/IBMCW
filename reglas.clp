
(defrule inicio
=>
(assert (busqueda (ingredientes masa mozarella carne) (tipo_plato null) (estilo null)))
)

(definstances ingredientes
([i1] of CARNE (id_ingrediente carne))
([i2] of SALSA (id_ingrediente boloñesa))
([i3] of VERDURA (id_ingrediente tomate))
([i4] of QUESO (id_ingrediente mozarella))
([i5] of CEREALES (id_ingrediente masa))
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


(defrule filtrar_por_estilo
(declare (salience 10))
(busqueda (estilo ?e&~null))
?ob <-(object (is-a ~?e) (elegido false))
=>
(modify-instance ?ob (elegido true))
)

(defrule filtrar_por_plato
(declare (salience 8))
(busqueda (tipo_plato ?tipo&~null))
?ob <-(object (is-a RECETA)(tipo_plato ?tipo) (elegido false))
=>
(modify-instance ?ob (elegido true))
)

(defrule filtrar_por_ingredientes
(declare (salience 6))
?ob<-(object (is-a RECETA)(id_receta ?id))
(forall (object (is-a RECETA) (id_receta ?id) (ingredientes $? ?ingrediente_receta $?) (elegido false))
(busqueda (ingredientes $? ?ingrediente_receta $?)))

=>
(modify-instance ?ob (elegido true))
)







