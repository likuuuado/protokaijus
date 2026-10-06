extends CharacterBody3D

@export var player_number: int
@export var move_vel : float = 5.0
@export var material: StandardMaterial3D
@export var mesh: MeshInstance3D

var modo_creacion_p1 := false
var indice_receta_p1 := 0
var modo_creacion_p2 := false
var indice_receta_p2 := 0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var conduciendo_barco = false
var j1_puede_conducir_barco = false
var j1_puede_salir_del_barco = false
var j2_puede_conducir_barco = false
var j2_puede_salir_del_barco = false
var barco_actual = null
var rSpeed = 3.0

func _ready() -> void:
	if material:
		mesh.material_override = material

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if j1_puede_conducir_barco:
		if Input.is_action_just_pressed("p1interaction") and player_number == 1:
			conduciendo_barco = true
			$"../PJBase".visible = false
	if j2_puede_conducir_barco:
		if Input.is_action_just_pressed("p2interaction") and player_number == 2:
			conduciendo_barco = true
			$".".visible = false
	if j1_puede_salir_del_barco:
		if Input.is_action_just_pressed("p1interaction") and player_number == 1:
			salir_del_barco()
			$"../PJBase".visible = true
	if j2_puede_salir_del_barco:
		if Input.is_action_just_pressed("p2interaction") and player_number == 2:
			salir_del_barco()
			$".".visible = true
	if conduciendo_barco:
		controlador_barco(delta)
	else:
		controlador_jugador(delta)
	
	if Input.is_key_pressed(KEY_A):
		rotate_y(rSpeed * delta)
	
	if Input.is_key_pressed(KEY_D):
		rotate_y(-rSpeed * delta)
		
	if Input.is_key_pressed(KEY_LEFT):
		rotate_y(rSpeed * delta)
		
	if Input.is_key_pressed(KEY_RIGHT):
		rotate_y(-rSpeed * delta)
		
func salir_del_barco():
	conduciendo_barco = false
	j1_puede_salir_del_barco = false
	j2_puede_salir_del_barco = false
	
func controlador_jugador(delta):
	if conduciendo_barco == true:
		return
	var input_dir
	if player_number == 2:
		input_dir = Input.get_vector("p2left", "p2right", "p2up", "p2down")
	else:
		input_dir = Input.get_vector("p1left", "p1right", "p1up", "p1down")

	
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * move_vel
		velocity.z = direction.z * move_vel
	else:
		velocity.x = move_toward(velocity.x, 0, move_vel)
		velocity.z = move_toward(velocity.z, 0, move_vel)
		
	if not is_on_floor(): 
		velocity.y -= gravity * delta 
	else: 
		velocity.y = 0
	
	
	if player_number == 1:
		if Input.is_action_just_pressed("p1creacion"):
			# Cambia el modo
			modo_creacion_p1 = !modo_creacion_p1
		
		if modo_creacion_p1: # Si está en modo creación tiene estos controles
			if Input.is_action_just_pressed("p1avanzar"):
				indice_receta_p1 += 1
				if indice_receta_p1 >= CreaciónP1.orden_recetas.size():
					indice_receta_p1 = 0
				print(indice_receta_p1, CreaciónP1.orden_recetas)
				# Recorrer la lista de recetas
			if Input.is_action_just_pressed("p1retroceder"):
				indice_receta_p1 -= 1
				if indice_receta_p1 < 0:
					indice_receta_p1 = CreaciónP1.orden_recetas.size() - 1
				print(indice_receta_p1, CreaciónP1.orden_recetas)
			
			if Input.is_action_just_pressed("p1interact"):
				# Si tiene los materiales en el inventario los crea sino no
				var receta = CreaciónP1.orden_recetas[indice_receta_p1]
				CreaciónP1.fabricar(receta, InventarioP1, get_parent(), global_position)
		
		
		else: # Si no está en modo creación tiene estos controles
			if player_number == 1:
				# Si es P1
				if Input.is_action_just_pressed("p1retroceder"):
					# Avanza en 1 el índice
					InventarioP1.indice_retroceder()
			
				if Input.is_action_just_pressed("p1avanzar"):
					# Retrocede en 1 el índice
					InventarioP1.indice_avanzar()
			
				if Input.is_action_just_pressed("p1soltar"):
					# Se fija si está ese material
					if InventarioP1.hay_material_seleccionado():
						# Asigna ese material a la escena empaquetada
						var scene = InventarioP1.get_selected_scene()
						if InventarioP1.soltar_material_seleccionado():
							# Al soltarlo lo instancia y lo pone en la escena en la posición del player
							var objeto = scene.instantiate()
							get_parent().add_child(objeto)
							objeto.global_position = global_position
	
	
	
	
	if player_number == 2:
		if Input.is_action_just_pressed("p2creacion"):
			# Cambia el modo
			modo_creacion_p2 = !modo_creacion_p2
		
		if modo_creacion_p2: # Si está en modo creación tiene estos controles
			if Input.is_action_just_pressed("p2avanzar"):
				indice_receta_p2 += 1
				if indice_receta_p2 >= CreaciónP2.orden_recetas.size():
					indice_receta_p2 = 0
				print(indice_receta_p2, CreaciónP2.orden_recetas)
				# Recorrer la lista de recetas
			if Input.is_action_just_pressed("p2retroceder"):
				indice_receta_p2 -= 1
				if indice_receta_p2 < 0:
					indice_receta_p2 = CreaciónP2.orden_recetas.size() - 1
				print(indice_receta_p2, CreaciónP2.orden_recetas)
			
			if Input.is_action_just_pressed("p2interact"):
				# Si tiene los materiales en el inventario los crea sino no
				var receta = CreaciónP2.orden_recetas[indice_receta_p2]
				CreaciónP2.fabricar(receta, InventarioP2, get_parent(), global_position)
		
		
		else: # Si no está en modo creación tiene estos controles
			if player_number == 1:
				# Si es P1
				if Input.is_action_just_pressed("p2retroceder"):
					# Avanza en 1 el índice
					InventarioP2.indice_retroceder()
			
				if Input.is_action_just_pressed("p2avanzar"):
					# Retrocede en 1 el índice
					InventarioP2.indice_avanzar()
			
				if Input.is_action_just_pressed("p2soltar"):
					# Se fija si está ese material
					if InventarioP2.hay_material_seleccionado():
						# Asigna ese material a la escena empaquetada
						var scene = InventarioP2.get_selected_scene()
						if InventarioP2.soltar_material_seleccionado():
							# Al soltarlo lo instancia y lo pone en la escena en la posición del player
							var objeto = scene.instantiate()
							get_parent().add_child(objeto)
							objeto.global_position = global_position
	
	move_and_slide()

func controlador_barco(delta):
	var input_dir
	if player_number == 2:
		input_dir = Input.get_vector("p2left", "p2right", "p2up", "p2down")
	else:
		input_dir = Input.get_vector("p1left", "p1right", "p1up", "p1down")
	
	var aceleracion = (barco_actual.transform.basis.x).normalized()
	var rotacion = input_dir.x
	if aceleracion:
		barco_actual.velocity.x = aceleracion.x * -input_dir.y * move_vel
		barco_actual.velocity.z = aceleracion.z * -input_dir.y * move_vel
		barco_actual.rotation.y -= rotacion * 2.0 * delta
	
	barco_actual.move_and_slide()
