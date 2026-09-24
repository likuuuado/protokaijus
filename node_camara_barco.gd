extends Node3D

var camara: Camera3D
@export var cam_offset: Vector3 = Vector3(0.0, 10.0, 10.0)
@onready var jugador = get_tree().get_first_node_in_group("Jugador1")

func _ready() -> void:
	if get_parent().player_number == 1:
		camara = get_tree().get_first_node_in_group("P1")
	elif get_parent().player_number == 2:
		camara = get_tree().get_first_node_in_group("P2")


func _process(delta: float) -> void:
	if camara and jugador.visible == false:
		camara.global_position = global_position + cam_offset
	
