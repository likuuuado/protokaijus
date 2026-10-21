extends Node

var modo_construccion := false
var jugador: CharacterBody3D
var controlador_mundo: Node3D
var objeto_construccion: Node3D
var movimiento_pendiente := Vector3.ZERO

func _ready() -> void:
	jugador = get_parent()
	controlador_mundo = get_tree().get_first_node_in_group("Test")
	modo_construccion = false


func _physics_process(_delta: float) -> void:
	if jugador.player_number == 1:
		if Input.is_action_just_pressed("P1Construir"):
			alternar_construccion()
		elif modo_construccion and Input.is_action_just_pressed("p1interaction"):
			confirmar_construccion()
		elif modo_construccion:
			if Input.is_action_just_pressed("p1up"):
				movimiento_pendiente = Vector3(0, 0, -1)
			elif Input.is_action_just_pressed("p1down"):
				movimiento_pendiente = Vector3(0, 0, 1)
			elif Input.is_action_just_pressed("p1left"):
				movimiento_pendiente = Vector3(-1, 0, 0)
			elif Input.is_action_just_pressed("p1right"):
				movimiento_pendiente = Vector3(1, 0, 0)

	elif jugador.player_number == 2:
		if Input.is_action_just_pressed("P2Construir"):
			alternar_construccion()
		elif modo_construccion and Input.is_action_just_pressed("p2interaction"):
			confirmar_construccion()
		elif modo_construccion:
			if Input.is_action_just_pressed("p2up"):
				movimiento_pendiente = Vector3(0, 0, -1)
			elif Input.is_action_just_pressed("p2down"):
				movimiento_pendiente = Vector3(0, 0, 1)
			elif Input.is_action_just_pressed("p2left"):
				movimiento_pendiente = Vector3(-1, 0, 0)
			elif Input.is_action_just_pressed("p2right"):
				movimiento_pendiente = Vector3(1, 0, 0)


	if modo_construccion and movimiento_pendiente != Vector3.ZERO:
		if is_instance_valid(objeto_construccion):
			var posicion_anterior = objeto_construccion.global_position
			objeto_construccion.global_position += movimiento_pendiente

			if not controlador_mundo.estructura_dentro_de_grilla(objeto_construccion):
				print("Movimiento rechazado: fuera de la grilla")
				objeto_construccion.global_position = posicion_anterior
		if modo_construccion and is_instance_valid(objeto_construccion):
			controlador_mundo.validar_construccion(objeto_construccion)


	movimiento_pendiente = Vector3.ZERO
	



func alternar_construccion() -> void:
	modo_construccion = !modo_construccion

	if modo_construccion:
		if controlador_mundo == null:
			push_error("No se encontró el nodo del grupo Test.")
			modo_construccion = false
			return

		objeto_construccion = controlador_mundo.crear_vista_previa()
		controlador_mundo.vistas_previas_activas.append(objeto_construccion)
	else:
		if is_instance_valid(objeto_construccion):
			controlador_mundo.vistas_previas_activas.erase(objeto_construccion)
			objeto_construccion.queue_free()

		objeto_construccion = null
		controlador_mundo._reset_highlight()

		for vista in controlador_mundo.vistas_previas_activas:
			if is_instance_valid(vista):
				var celdas_vista = controlador_mundo._get_object_cells(vista)
				controlador_mundo._check_and_highlight_cells(vista, celdas_vista)

func confirmar_construccion() -> void:
	if not is_instance_valid(objeto_construccion):
		return

	if not controlador_mundo.validar_construccion(objeto_construccion):
		return

	var celdas_ocupadas = controlador_mundo._get_object_cells(
		objeto_construccion
	)

	controlador_mundo._place_placement(celdas_ocupadas)

	controlador_mundo.vistas_previas_activas.erase(
		objeto_construccion
	)

	objeto_construccion = null
	modo_construccion = false

	print("Jugador ", jugador.player_number, " - Construcción confirmada")
