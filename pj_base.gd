extends CharacterBody3D

@export var player_number: int
@export var move_vel : float = 5.0
@export var material: StandardMaterial3D
@export var mesh: MeshInstance3D
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var conduciendo_barco = false
var puede_conducir_barco = false
var barco_actual = null

func _ready() -> void:
	if material:
		mesh.material_override = material

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if puede_conducir_barco:
		if Input.is_action_just_pressed("p1interaction"):
			conduciendo_barco = true
			$"../PJBase".visible = false
	if conduciendo_barco:
		controlador_barco(delta)
	else:
		controlador_jugador(delta)
	
	

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
