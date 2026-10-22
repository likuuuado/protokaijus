extends Node3D

var vel = 20

func _physics_process(delta: float) -> void:
	global_position += global_basis.x * vel * delta

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("kaijus"):
		print("Esta dentro")
		capturar_kaiju(body)
		
func capturar_kaiju(kaiju: Node3D):
		InventarioP1.agregar_material("hueso", 1)
		InventarioP1.agregar_material("piel", 1)
		kaiju.queue_free()
		queue_free()
