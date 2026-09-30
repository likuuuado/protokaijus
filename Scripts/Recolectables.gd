extends RigidBody3D
class_name Recolectable

@onready var area: Area3D = $Area3D

var player_1_in_range: bool = false 
var player_2_in_range: bool = false 

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("P1_body"):
		player_1_in_range = true
		
	if body.is_in_group("P2_body"):
		player_2_in_range = true


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("P1_body"):
		player_1_in_range = false
		
	if body.is_in_group("P2_body"):
		player_2_in_range = false


func collected(player_id: int) -> void:
	pass


func _physics_process(delta: float) -> void:
	
	if player_1_in_range == true and Input.is_action_just_pressed("p1interact"):
		collected(1)
	
	if player_2_in_range == true and Input.is_action_just_pressed("p2interact"):
		collected(2) 
