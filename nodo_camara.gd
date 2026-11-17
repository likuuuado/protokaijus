
extends Node3D

var camara: Camera3D

@export var distancia := 6.0
@export var altura := 3.0
@export var sensibilidad := 2.5
@export var velocidad_teclado := 2.0

var yaw := 0.0
var pitch := 0.2

func _ready() -> void:
	var jugador = get_parent()

	if jugador.player_number == 1:
		camara = get_tree().get_first_node_in_group("P1")
	elif jugador.player_number == 2:
		camara = get_tree().get_first_node_in_group("P2")


func _process(delta: float) -> void:
	var jugador = get_parent()
	if not jugador or not camara:
		return

	var nodo_construccion = jugador.get_node("NodoConstruccion")

	# 1. MODO CONSTRUCCIÓN
	if nodo_construccion.modo_construccion and is_instance_valid(nodo_construccion.objeto_construccion):
		var objetivo = nodo_construccion.objeto_construccion
		camara.global_position = objetivo.global_position + Vector3(0, 10, 10)
		camara.look_at(objetivo.global_position, Vector3.UP)
		return

	# 2. MODO BARCO
	elif jugador.conduciendo_barco and is_instance_valid(jugador.barco_actual):
		var objetivo = jugador.barco_actual
		camara.global_position = objetivo.global_position + Vector3(0, 10, 10)
		camara.look_at(objetivo.global_position, Vector3.UP)
		return

	# 3. JUGADOR A PIE
	elif jugador.a_pie:

		var look_input := Vector2.ZERO

		if jugador.player_number == 1:
			look_input = JoystickControlManager.get_right_stick(1)
		elif jugador.player_number == 2:
			look_input = JoystickControlManager.get_right_stick(2)

		yaw -= look_input.x * sensibilidad * delta
		pitch = clamp(pitch + look_input.y * sensibilidad * delta, -1.2, 1.2)

		var input_teclado_giro := 0.0

		if jugador.player_number == 1:
			if Input.is_action_pressed("p1left"):
				input_teclado_giro -= 1.0
			if Input.is_action_pressed("p1right"):
				input_teclado_giro += 1.0

		elif jugador.player_number == 2:
			if Input.is_action_pressed("p2left"):
				input_teclado_giro -= 1.0
			if Input.is_action_pressed("p2right"):
				input_teclado_giro += 1.0

		if input_teclado_giro != 0.0:
			yaw -= input_teclado_giro * velocidad_teclado * delta

		var offset = Vector3(
			sin(yaw) * cos(pitch) * distancia,
			sin(pitch) * distancia + altura,
			cos(yaw) * cos(pitch) * distancia
		)

		camara.global_position = global_position + offset
		camara.look_at(global_position + Vector3(0, altura * 0.5, 0), Vector3.UP)
