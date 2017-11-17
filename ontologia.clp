

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





