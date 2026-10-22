extends Recolectable

@export var rama_scene: PackedScene

func collected(player_id: int) -> void:
	var rama = rama_scene.instantiate()
	get_parent().add_child(rama)
	rama.global_position = global_position + Vector3(1, 0, 1)
