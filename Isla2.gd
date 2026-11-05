extends StaticBody3D

signal BarcoEntraI2
var jugador1
var jugador2
var barco1
var barco2

#func _ready() -> void:
	#jugador1 = get_node("/root/Node3D/PJBase")
	#jugador2 = get_node("/root/Node3D/PJBase2")
	#barco1 = get_node("/root/Node3D/PJBase/Creador-de-Barcos/barco")
#func _on_area_3di_2_body_entered(body: Node3D) -> void:
	#if body.is_in_group("Barco"):
		#BarcoEntraI2.emit()
		#jugador1.global_position = Vector3(-13,5,-135)
		#print(body.name, " Esta dentro")
