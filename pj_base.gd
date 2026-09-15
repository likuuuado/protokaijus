extends CharacterBody3D

@export var player_number: int
@export var move_vel : float = 5.0
@export var material: StandardMaterial3D
@export var mesh: MeshInstance3D


func _ready() -> void:
	if material:
		mesh.material_override = material

func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	
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
	
	
	move_and_slide()
