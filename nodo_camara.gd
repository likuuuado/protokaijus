extends Node3D

var camara: Camera3D
@export var cam_offset: Vector3 = Vector3(0.0, 3.0, 3.0)
var PJAsignado

func _ready() -> void:
	if get_parent().is_in_group("P1"):
		camara = get_tree().get_first_node_in_group("P1")
	elif get_parent().is_in_group("P2"):
		camara = get_tree().get_first_node_in_group("P2")


func _process(delta: float) -> void:
	if camara:
		camara.global_position = global_position + cam_offset
