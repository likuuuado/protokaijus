extends Node
#inventario p2

var recursos_p2 := {
"madera": 0,
"hierro": 0,
"sangre": 0,
"piel": 0,
"hueso": 0,
}

func add_resource(tipo: String, cantidad: int) -> void:
	recursos_p2[tipo] += cantidad
	print("P2: ", recursos_p2)
