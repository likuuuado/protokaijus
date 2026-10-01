extends StaticBody3D

signal barco_entra

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Barco"):
		barco_entra.emit()
		print(body.name, " Esta dentro")
