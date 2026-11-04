extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var activada
@export var fuerza_empuje: float = 15.0
@export var fuerza_vertical: float = 8.0


func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_area_3d_body_entered(body: Node3D) -> void:
	if activada:
		return

	if not body is CharacterBody3D:
		return

	activada = true
	explotar(body)

func explotar(body: CharacterBody3D) -> void:
	animation_player.play("Bouncer_Bounce")

	var direccion = body.global_position - global_position
	direccion.y = 0
	direccion = direccion.normalized()

	body.velocity = direccion * fuerza_empuje
	body.velocity.y = fuerza_vertical

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Bouncer_Bounce":
		queue_free()
