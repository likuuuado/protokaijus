extends Area3D

@export var jugador_ganador := 1

@export var cartel_victoria: CanvasLayer

func _ready():
	cartel_victoria.hide()
	

func _on_body_entered(body):
	if body is CharacterBody3D and body.player_number == jugador_ganador:
		print("alguien gano")
		cartel_victoria.show()
