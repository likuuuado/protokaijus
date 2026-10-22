extends StaticBody3D

@export var size: Vector2 = Vector2(2,2)
@export var offset: Vector3 = Vector3.ZERO

var player_propiedad: int = 0 # 0 sin asignar, 1 y 2 no hace falta decirlo
var estructura_activa: bool = false
@export var tiempo_construccion: float = 10.0
var estructura_rota: bool = false
@export var cantidad_inventario: int = 5
var inventario_estructura: Dictionary = {} 


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

	if estructura_rota:
		return

	estructura_activa = true
	print("La estructura terminó de construirse")

func reparar_estructura() -> void:
	if not estructura_rota:
		return

	estructura_rota = false
	estructura_activa = true
	print("La estructura ha sido reparada")


func romper_estructura() -> void:
	estructura_rota = true
	estructura_activa = false
	print("La estructura está rota")


func _on_area_3d_body_entered(body: Node3D) -> void:
	if not estructura_activa or estructura_rota:
		return


	if body is CharacterBody3D:
		var numero_jugador = body.get("player_number")

		if numero_jugador == null:
			return

		if numero_jugador == player_propiedad:
				
			pass
		else:
			
			pass

func almacenar_Material(material: String, cantidad: int) -> bool:
	if cantidad <= 0:
		return false

	var total_actual = 0

	for valor in inventario_estructura.values():
		total_actual += valor

	if total_actual + cantidad > cantidad_inventario:
		return false

	if inventario_estructura.has(material):
		inventario_estructura[material] += cantidad
	else:
		inventario_estructura[material] = cantidad

	return true
