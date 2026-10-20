extends Node

var modo_construccion := false
var jugador: CharacterBody3D
var controlador_mundo: Node3D
var objeto_construccion: Node3D

func _ready() -> void:
	jugador = get_parent()
	controlador_mundo = get_tree().get_first_node_in_group("Test")
	modo_construccion = false


func _physics_process(_delta: float) -> void:
	if jugador.player_number == 1:
		if Input.is_action_just_pressed("P1Construir"):
			alternar_construccion()
	elif jugador.player_number == 2:
		if Input.is_action_just_pressed("P2Construir"):
			alternar_construccion()


func alternar_construccion() -> void:
	modo_construccion = !modo_construccion
	
	if modo_construccion:
		if controlador_mundo == null:
			push_error("No se encontró el nodo del grupo Test.")
			modo_construccion = false
			return

		objeto_construccion = controlador_mundo.crear_vista_previa()
	else:
		if is_instance_valid(objeto_construccion):
			objeto_construccion.queue_free()
		objeto_construccion = null

	print("Jugador ", jugador.player_number,
		" - Modo construcción: ", modo_construccion)
