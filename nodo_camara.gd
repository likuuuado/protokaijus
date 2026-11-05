extends Node3D

var camara: Camera3D

@export var distancia := 6.0
@export var altura := 3.0
@export var sensibilidad := 2.5
@export var velocidad_teclado := 2.0 # Velocidad de giro brusca para el teclado

var yaw := 0.0
var pitch := 0.2 

func _ready() -> void:
	if get_parent().player_number == 1:
		camara = get_tree().get_first_node_in_group("P1")
	elif get_parent().player_number == 2:
		camara = get_tree().get_first_node_in_group("P2")

func _process(delta: float) -> void:
	var jugador = get_parent()
	if not jugador or not camara:
		return

	# 1. Leer stick derecho (como ya lo tenías)
	var look_input := Vector2.ZERO
	if jugador.player_number == 1:
		look_input = JoystickControlManager.get_right_stick(1)
	elif jugador.player_number == 2:
		look_input = JoystickControlManager.get_right_stick(2)

	# Aplicar movimiento del joystick
	yaw -= look_input.x * sensibilidad * delta
	pitch = clamp(pitch + look_input.y * sensibilidad * delta, -1.2, 1.2)

	# 2. AÑADIR: Control por teclado para un giro tosco que acompañe al jugador
	var input_teclado_giro = 0.0
	if jugador.player_number == 1:
		# Puedes cambiar "ui_left" / "ui_right" por las acciones de teclado que prefieras para el P1
		if Input.is_action_pressed("p1left"): # o usa tus propias acciones de teclado
			input_teclado_giro -= 1.0
		if Input.is_action_pressed("p1right"):
			input_teclado_giro += 1.0
	elif jugador.player_number == 2:
		if Input.is_action_pressed("p2left"):
			input_teclado_giro -= 1.0
		if Input.is_action_pressed("p2right"):
			input_teclado_giro += 1.0

	# Si quieres que la cámara acompañe automáticamente cuando el jugador presiona izquierda/derecha de movimiento:
	# (Por ejemplo, usando la misma dirección horizontal en la que camina)
	if input_teclado_giro != 0.0:
		# Giro más brusco / tosco impulsado por teclado
		yaw -= input_teclado_giro * velocidad_teclado * delta

	# Calcular posición orbital alrededor del jugador
	var offset = Vector3(
		sin(yaw) * cos(pitch) * distancia,
		sin(pitch) * distancia + altura,
		cos(yaw) * cos(pitch) * distancia
	)

	camara.global_position = global_position + offset
	camara.look_at(global_position + Vector3(0, altura * 0.5, 0), Vector3.UP)
