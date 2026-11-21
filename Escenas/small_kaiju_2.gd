extends Recolectable # Extiende del script base Recolectable

# Cargar las escenas desde el inspector para que despues las pueda crear
@export var kaiju_blood_scene: PackedScene
@export var kaiju_skin_scene: PackedScene

func collected(player_id: int):
	
	# Crear el objeto
	
	var piel = kaiju_skin_scene.instantiate()
	
	# Ponerlo en la escena
	
	get_parent().add_child(piel)
	
	# Acomodar su posición para que no queden superpuestos
	
	piel.global_position = global_position + Vector3(1, 0, 0)
	
	queue_free()
