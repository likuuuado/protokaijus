extends Area3D

@export var spawn_ps : Vector3 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		if body.player_number == 1:
			InventarioP1.perder_objetos_aleatorios()
			body.global_position = spawn_ps
		elif body.player_number == 2:
			InventarioP2.perder_objetos_aleatorios()
			body.global_position = spawn_ps

	body.velocity = Vector3.ZERO
