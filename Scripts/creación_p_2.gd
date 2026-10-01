extends Node
# Creación P2

var recetas = {
	"pack_construccion" : {
		"coste" : {
			"madera" : 1,
			"hierro" : 1,
			"hueso" : 1
		},
		"escena" : preload("res://Escenas/pack_construccion.tscn")
	},
	
	"pack_barcos" : {
		"coste" : {
			"madera" : 1,
			"hierro" : 1,
			"piel" : 1
		},
		"escena" : preload("res://Escenas/pack_barcos.tscn")
	},
	
	"combustible" : {
		"coste" : {
			"sangre" : 3
		},
		"escena" : preload("res://Escenas/combustible.tscn")
	}
}

# Fijo porque no se van a agregar mas fuera del código
var orden_recetas = [
	"pack_construccion",
	"pack_barcos",
	"combustible"
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
