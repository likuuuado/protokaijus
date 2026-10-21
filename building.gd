extends StaticBody3D

@export var size: Vector2 = Vector2(2,2)
@export var offset: Vector3 = Vector3.ZERO

var player_propiedad: int = 0 # 0 sin asignar, 1 y 2 no hace falta decirlo
var estructura_activa: bool = false
@export var tiempo_construccion: float = 10.0



func _ready() -> void:
	for child in get_children():
		child.position -= offset


func get_rect():
	var objectPosition = Vector2(
		global_position.x - int(size.x / 2),
		global_position.z - int(size.y / 2)
	)
	return Rect2(objectPosition, size)

func iniciar_construccion() -> void:
	estructura_activa = false
	await get_tree().create_timer(tiempo_construccion).timeout
	estructura_activa = true
	print("La estructura terminó de construirse")


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		var numero_jugador = body.get("player_number")

		if numero_jugador == null:
			return

		if numero_jugador == player_propiedad:
			# Aquí irá la interacción del propietario
			pass
		else:
			# Aquí irá la interacción del rival
			pass
