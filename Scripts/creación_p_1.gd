extends Node
# Creación P1

var recetas = {
	"pack_construccion" : {
		"coste" : {
			"madera" : 2,
			"hierro" : 1,
			"hueso" : 2
		},
		"escena" : preload("res://Escenas/pack_construccion.tscn"),
		"icono" : preload("res://Assets/Assets 2D/Caja madera.png"),
		"nombre" : "Pack Construcción"
	},
	
	"pack_barcos" : {
		"coste" : {
			"tabla" : 4,
			"lingote" : 3,
			"combustible": 1
		},
		"escena" : preload("res://Escenas/pack_barco.tscn"),
		"icono" : preload("res://Assets/Assets 2D/Caja metal.png"),
		"nombre" : "Pack Barcos"
	},
	
	"combustible" : {
		"coste" : {
			"sangre" : 3
		},
		"escena" : preload("res://Escenas/combustible.tscn"),
		"icono" : preload("res://Assets/Assets 2D/Combustible.png"),
		"nombre" : "Combustible"
	},
	
	"mazo_sabotaje" : {
		"coste": {"madera" : 2, "hueso": 1},
		"escena" : preload("res://Escenas/maza.tscn"),
		"icono" : preload("res://assets/Assets 2D/martillo.png"),
		"nombre" : "mazo sabotaje"
	}
}

# Fijo porque no se van a agregar mas fuera del código
var orden_recetas = [
	"pack_construccion",
	"pack_barcos",
	"combustible",
	"mazo_sabotaje"
]


func fabricar(nombre_receta: String, inventario, parent_node: Node, posicion: Vector3) -> bool:
	var receta = recetas[nombre_receta]
	var coste = receta["coste"]
	
	for material in coste:
		if !inventario.tiene_material(material, coste[material]):
			print("nose pudo crear")
			return false
	
	for material in coste:
		inventario.gastar_material(material, coste[material])
	
	var escena: PackedScene = receta["escena"]
	
	var objeto = escena.instantiate()
	
	parent_node.add_child(objeto)
	
	objeto.global_position = posicion
	
	return true
