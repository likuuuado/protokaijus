extends Node3D

var camara: Camera3D
@export var cam_offset: Vector3 = Vector3(0.0, 3.0, 3.0)
var PJAsignado

func _ready() -> void:
	if get_parent().player_number == 1:
		camara = get_tree().get_first_node_in_group("P1")
	elif get_parent().player_number == 2:
		camara = get_tree().get_first_node_in_group("P2")


func _process(delta: float) -> void:
	var jugador = get_parent()
	if jugador.conduciendo_barco and jugador.barco_actual:
		cam_offset = Vector3(0,10,10)
		camara.global_position = jugador.barco_actual.global_position + cam_offset
	else:
		camara.global_position = global_position + cam_offset
		cam_offset = Vector3(0,3,3)
