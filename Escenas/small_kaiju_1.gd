extends Recolectable # Extiende del script base Recolectable

# Cargar las escenas desde el inspector para que despues las pueda crear
@export var kaiju_blood_scene: PackedScene
@export var kaiju_bone_scene: PackedScene

func collected(player_id: int):
	
	# Crear el objeto
	var sangre = kaiju_blood_scene.instantiate()
	var hueso = kaiju_bone_scene.instantiate()
	
	# Ponerlo en la escena
	get_parent().add_child(sangre)
	get_parent().add_child(hueso)
	
	# Acomodar su posición para que no queden superpuestos
	sangre.global_position = global_position
	hueso.global_position = global_position + Vector3(1, 0, 0)
	
	queue_free()
