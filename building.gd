extends StaticBody3D

@export var size: Vector2 = Vector2(2,2)
@export var offset: Vector3 = Vector3.ZERO

var player_propiedad: int = 0 # 0 sin asignar, 1 y 2 no hace falta decirlo
var estructura_activa: bool = false
@export var tiempo_construccion: float = 10.0
@export var tiempo_procesamiento: float = 5.0
var estructura_rota: bool = false
@export var cantidad_inventario: int = 5
var inventario_estructura: Dictionary = {} 

var recetas_procesamiento := {
	"tablones": {
		"materiales": {
			"madera": 2
		},
		"producto": "tablones",
		"cantidad": 1
	},
	"lingotes": {
		"materiales": {
			"hierro": 2
		},
		"producto": "lingotes",
		"cantidad": 1
	}
}

var materiales_procesables := {
	"madera": true,
	"hierro": true,
	"hueso": true
}

var cola_procesamiento: Array[String] = []
var material_en_proceso: String = ""
var producto_terminado: String = ""
var procesando: bool = false
var jugadores_cercanos: Array[CharacterBody3D] = []

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

		if not jugadores_cercanos.has(body):
			jugadores_cercanos.append(body)

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

func retirar_materiales(material: String, cantidad: int) -> bool:
	if cantidad <= 0:
		return false 

	if not inventario_estructura.has(material):
		return false

	if inventario_estructura[material] < cantidad:
		return false

	inventario_estructura[material] -= cantidad

	if inventario_estructura[material] == 0:
		inventario_estructura.erase(material)

	return true

func consultar_material(material: String) -> int:
	return inventario_estructura.get(material, 0)

func consultar_espacioDispo() -> int:
	var total_actual = 0

	for valor in inventario_estructura.values():
		total_actual += valor

	return cantidad_inventario - total_actual

func depositar_material(jugador: CharacterBody3D) -> bool:
	if not estructura_activa or estructura_rota:
		return false

	if jugador.player_number != player_propiedad:
		return false

	var numero_jugador = jugador.player_number
	var inventario

	if numero_jugador == 1:
		inventario = InventarioP1
	elif numero_jugador == 2:
		inventario = InventarioP2
	else:
		return false

	var material = inventario.get_selected_resource()
	print("Material seleccionado para depositar: ", material)

	if material == "":
		return false

	if not materiales_procesables.has(material):
		return false

	if not inventario.tiene_material(material, 1):
		return false

	if consultar_espacioDispo() < 1:
		return false

	if not almacenar_Material(material, 1):
		return false

	if not inventario.gastar_material(material, 1):
		retirar_materiales(material, 1)
		return false

	cola_procesamiento.append(material)
	print("Material depositado: ", material)
	return true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D:
		jugadores_cercanos.erase(body)

func interactuar(jugador: CharacterBody3D) -> void:
	if not jugadores_cercanos.has(jugador):
		return

	if jugador.player_number != player_propiedad:
		return

	if producto_terminado != "":
		recoger_producto(jugador)
		return

	if procesando:
		print("La máquina está refinando: ", material_en_proceso)
		return

	depositar_material(jugador)

	var receta = buscar_receta_disponible()

	if receta != "":
		iniciar_procesamiento()
		procesar_receta()
	else:
		print("Faltan materiales para una receta")

func buscar_receta_disponible() -> String:
	for nombre_receta in recetas_procesamiento:
		var receta = recetas_procesamiento[nombre_receta]
		var materiales_suficientes = true

		for material in receta["materiales"]:
			var cantidad_necesaria = receta["materiales"][material]

			if consultar_material(material) < cantidad_necesaria:
				materiales_suficientes = false
				break

		if materiales_suficientes:
			return nombre_receta

	return ""

func iniciar_procesamiento() -> void:
	if procesando:
		return

	if producto_terminado != "":
		return

	var receta_disponible = buscar_receta_disponible()

	if receta_disponible == "":
		return

	material_en_proceso = receta_disponible
	procesando = true

	print("Iniciando refinado: ", material_en_proceso)

func procesar_receta() -> void:
	if not procesando:
		return

	var receta = recetas_procesamiento[material_en_proceso]

	for material in receta["materiales"]:
		var cantidad_necesaria = receta["materiales"][material]

		if consultar_material(material) < cantidad_necesaria:
			procesando = false
			material_en_proceso = ""
			return

	for material in receta["materiales"]:
		var cantidad_necesaria = receta["materiales"][material]
		retirar_materiales(material, cantidad_necesaria)

	print("Refinando: ", material_en_proceso)

	await get_tree().create_timer(tiempo_procesamiento).timeout

	producto_terminado = receta["producto"]
	procesando = false

	print("Producto terminado: ", producto_terminado)

func recoger_producto(jugador: CharacterBody3D) -> bool:
	if producto_terminado == "":
		return false

	var inventario

	if jugador.player_number == 1:
		inventario = InventarioP1
	elif jugador.player_number == 2:
		inventario = InventarioP2
	else:
		return false

	var recogido = inventario.agregar_material(producto_terminado, 1)

	if not recogido:
		print("No se pudo recoger el producto: inventario lleno")
		return false

	print("Producto recogido: ", producto_terminado)

	producto_terminado = ""
	material_en_proceso = ""

	return true
