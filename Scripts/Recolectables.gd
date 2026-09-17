extends RigidBody3D

var player_in_range: bool = false 

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("Players"):
		player_in_range = true

func _on_area_exited(area: Area3D) -> void:
	if area.is_in_group("Players"):
		player_in_range = false


func collected_p1() -> void:
	pass

func collected_p2() -> void:
	pass

func _physics_process(delta: float) -> void:
	
	if player_in_range == true:
		if Input.is_action_just_pressed("p1interact"):
			collected_p1()
	
	if player_in_range == true:
		if Input.is_action_just_pressed("p2interact"):
			collected_p2()
