extends Recolectable

@export var kaiju_blood_scene: PackedScene
@export var kaiju_bone_scene: PackedScene

func collected(player_id: int):
	var sangre = kaiju_blood_scene.instantiate()
	var hueso = kaiju_bone_scene.instantiate()
	
	get_parent().add_child(sangre)
	get_parent().add_child(hueso)
	
	sangre.global_position = global_position
	hueso.global_position = global_position + Vector3(1, 0, 0)
	
	queue_free()
