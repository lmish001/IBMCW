

(defclass RECETA (is-a INITIAL-OBJECT)
(slot id_receta (type STRING))
(slot tipo_plato (type SYMBOL))
;;allowed-values
;;(multislot ingredientes (type INSTANCE)
;;						(allowed-classes INGREDIENTE))
(multislot ingredientes (type SYMBOL))
(slot num_ingredientes (type INTEGER))
(slot elegido (type SYMBOL)
(allowed-values true false)
(default false))
)


(defclass ASIATICO (is-a RECETA))
(defclass MEDITERRANEO (is-a RECETA))
(defclass ITALIANO (is-a MEDITERRANEO))


(defclass PASO (is-a INITIAL-OBJECT)
(slot id_receta (type STRING))
(slot orden (type INTEGER))
(slot descripcion (type STRING))
;;(multislot ingredientes (type INSTANCE)
;;						(allowed-classes INGREDIENTE))
(multislot ingredientes (type SYMBOL))
)

(defclass INGREDIENTE (is-a INITIAL-OBJECT)
(slot id_ingrediente (type SYMBOL)))

(defclass SALSA (is-a INGREDIENTE))
(defclass ESPECIE (is-a INGREDIENTE))
(defclass LIQUIDO (is-a INGREDIENTE))

(defclass ALIMENTO (is-a INGREDIENTE))
(defclass CARNE (is-a ALIMENTO))
(defclass PESCADO (is-a ALIMENTO))
(defclass VERDURA (is-a ALIMENTO))
(defclass LEGUMBRE (is-a ALIMENTO))
(defclass FRUTA (is-a ALIMENTO))
(defclass PASTA (is-a ALIMENTO))
(defclass DERIVADOS_LECHE (is-a ALIMENTO))
(defclass QUESO (is-a DERIVADOS_LECHE))
(defclass CEREALES (is-a ALIMENTO)
;;(defclass MASA (is-a ALIMENTO)
)

(defclass INGREDIENTE_RECETA (is-a INITIAL-OBJECT)
(slot id_ingrediente(type SYMBOL))
(slot id_receta (type STRING))
(slot paso (type INTEGER))
(slot cantidad (type INTEGER))
;;(slot esencial (type SYMBOL)
;;(allowed-values true, false))
)

(defclass SINERGIA (is-a INITIAL-OBJECT)
(slot id_ingrediente1(type SYMBOL))
(slot id_ingrediente2(type SYMBOL))
(slot grado (type INTEGER))
)

(deftemplate busqueda
	(multislot ingredientes (type SYMBOL))
	(slot tipo_plato
	(type SYMBOL))
	(slot estilo
	(type SYMBOL))
)

(definstances ingredientes
([ing0] of CARNE (id_ingrediente ternera))
([ing1] of CARNE (id_ingrediente pollo))
([ing2] of CARNE (id_ingrediente pavo))
([ing3] of CARNE (id_ingrediente jamon_york))
([ing4] of SALSA (id_ingrediente barbacoa))
([ing5] of SALSA (id_ingrediente bolognesa))
([ing6] of SALSA (id_ingrediente chile_picante))
([ing7] of PESCADO (id_ingrediente atun))
([ing8] of PESCADO (id_ingrediente salmon))
([ing9] of PESCADO (id_ingrediente emperados))
([ing10] of VERDURA (id_ingrediente tomate))
([ing11] of VERDURA (id_ingrediente lechuga))
([ing12] of LEGUMBRE (id_ingrediente judias_verdes))
([ing13] of LEGUMBRE (id_ingrediente repollo))
([ing14] of LEGUMBRE (id_ingrediente lentejas))
([ing15] of FRUTA (id_ingrediente naranja))
([ing16] of FRUTA (id_ingrediente manzana))
([ing17] of FRUTA (id_ingrediente platano))
([ing18] of PASTA (id_ingrediente macarrones))
([ing19] of PASTA (id_ingrediente ravioli))
([ing20] of QUESO (id_ingrediente parmesano))
([ing21] of QUESO (id_ingrediente queso_de_cabra))
([ing22] of QUESO (id_ingrediente mozzarella))
([ing23] of QUESO (id_ingrediente queso_de_cabra))
([ing24] of CEREALES (id_ingrediente cereales_integrales))
([ing25] of CEREALES (id_ingrediente cereales_choco))
([ing26] of LIQUIDO (id_ingrediente caldo_de_pollo))
([ing27] of ALIMENTO (id_ingrediente masa))
([ing28] of ALIMENTO (id_ingrediente masa_integral))
)

(definstances receta0
([r0] of ITALIANO (id_receta "Pizza 4 quesos") (tipo_plato pizza) (ingredientes  masa parmesano mozzarella queso_de_cabra roquefort) (num_ingredientes 5 ))
([p00] of PASO (id_receta "Pizza 4 quesos") (orden 1) (descripcion "Preparar la masa: ") (ingredientes masa))
([p01] of PASO (id_receta "Pizza 4 quesos") (orden 2) (descripcion "Preparar los toppings: ") (ingredientes parmesano mozzarella queso_de_cabra roquefort))
([p02] of PASO (id_receta "Pizza 4 quesos") (orden 3) (descripcion "Hornear la pizza"))
([i0r0] of INGREDIENTE_RECETA (id_ingrediente masa) (id_receta "Pizza 4 quesos")(paso 1) (cantidad 190))
([i1r0] of INGREDIENTE_RECETA (id_ingrediente parmesano) (id_receta "Pizza 4 quesos")(paso 2) (cantidad 80))
([i2r0] of INGREDIENTE_RECETA (id_ingrediente mozzarella) (id_receta "Pizza 4 quesos")(paso 2) (cantidad 80))
([i3r0] of INGREDIENTE_RECETA (id_ingrediente queso_de_cabra) (id_receta "Pizza 4 quesos")(paso 2) (cantidad 50))
([i4r0] of INGREDIENTE_RECETA (id_ingrediente roquefort) (id_receta "Pizza 4 quesos")(paso 2) (cantidad 150))
)
(definstances receta1
([r1] of ITALIANO (id_receta "Pizza barbacoa") (tipo_plato pizza) (ingredientes  masa ternera barbacoa) (num_ingredientes 3 ))
([p10] of PASO (id_receta "Pizza barbacoa") (orden 1) (descripcion "Preparar la masa: ") (ingredientes masa))
([p11] of PASO (id_receta "Pizza barbacoa") (orden 2) (descripcion "Preparar los toppings: ") (ingredientes ternera barbacoa))
([p12] of PASO (id_receta "Pizza barbacoa") (orden 3) (descripcion "Hornear la pizza"))
([i0r1] of INGREDIENTE_RECETA (id_ingrediente masa) (id_receta "Pizza barbacoa")(paso 1) (cantidad 80))
([i1r1] of INGREDIENTE_RECETA (id_ingrediente ternera) (id_receta "Pizza barbacoa")(paso 2) (cantidad 80))
([i2r1] of INGREDIENTE_RECETA (id_ingrediente barbacoa) (id_receta "Pizza barbacoa")(paso 2) (cantidad 140))
)
(definstances receta2
([r2] of ITALIANO (id_receta "Pizza carbonara") (tipo_plato pizza) (ingredientes  masa_integral pollo parmesano) (num_ingredientes 3 ))
([p20] of PASO (id_receta "Pizza carbonara") (orden 1) (descripcion "Preparar la masa: ") (ingredientes masa_integral))
([p21] of PASO (id_receta "Pizza carbonara") (orden 2) (descripcion "Preparar los toppings: ") (ingredientes pollo parmesano))
([p22] of PASO (id_receta "Pizza carbonara") (orden 3) (descripcion "Hornear la pizza"))
([i0r2] of INGREDIENTE_RECETA (id_ingrediente masa_integral) (id_receta "Pizza carbonara")(paso 1) (cantidad 90))
([i1r2] of INGREDIENTE_RECETA (id_ingrediente pollo) (id_receta "Pizza carbonara")(paso 2) (cantidad 180))
([i2r2] of INGREDIENTE_RECETA (id_ingrediente parmesano) (id_receta "Pizza carbonara")(paso 2) (cantidad 180))
)
(definstances receta3
([r3] of ITALIANO (id_receta "Pizza jamon y queso") (tipo_plato pizza) (ingredientes  masa jamon_york mozzarella) (num_ingredientes 3 ))
([p30] of PASO (id_receta "Pizza jamon y queso") (orden 1) (descripcion "Preparar la masa: ") (ingredientes masa))
([p31] of PASO (id_receta "Pizza jamon y queso") (orden 2) (descripcion "Preparar los toppings: ") (ingredientes jamon_york mozzarella))
([p32] of PASO (id_receta "Pizza jamon y queso") (orden 3) (descripcion "Hornear la pizza"))
([i0r3] of INGREDIENTE_RECETA (id_ingrediente masa) (id_receta "Pizza jamon y queso")(paso 1) (cantidad 160))
([i1r3] of INGREDIENTE_RECETA (id_ingrediente jamon_york) (id_receta "Pizza jamon y queso")(paso 2) (cantidad 10))
([i2r3] of INGREDIENTE_RECETA (id_ingrediente mozzarella) (id_receta "Pizza jamon y queso")(paso 2) (cantidad 20))
)






