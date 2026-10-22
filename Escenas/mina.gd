extends Recolectable

@export var hierro_scene: PackedScene

func collected(player_id: int) -> void:
	var hierro = hierro_scene.instantiate()
	get_parent().add_child(hierro)
	hierro.global_position = global_position + Vector3(2, 0, 2)
