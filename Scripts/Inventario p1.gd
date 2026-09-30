extends Node
#inventario p1

# Diccionario de los recursos que puede agregar
var recursos_p1 := {
"madera": 0,
"hierro": 0,
"sangre": 0,
"piel": 0,
"hueso": 0,
}

func add_resource(tipo: String, cantidad: int) -> void:
	# Espera que le digan que tipo de material es y cuanta cantidad
	recursos_p1[tipo] += cantidad
	print("P1: ", recursos_p1)
