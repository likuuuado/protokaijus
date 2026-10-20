extends Node

var modo_construccion := false
var jugador: CharacterBody3D


func _ready() -> void:
	jugador = get_parent()
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
	print("Jugador ", jugador.player_number,
		" - Modo construcción: ", modo_construccion)
