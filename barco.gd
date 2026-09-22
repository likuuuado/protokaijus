extends CharacterBody3D

@export var player_number: int
signal jugador_entra
signal jugador_sale

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Jugador1"):
		jugador_entra.emit()


func _on_area_3d_body_exited(body: Node3D) -> void:
	jugador_sale.emit()
