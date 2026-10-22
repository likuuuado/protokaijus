extends CharacterBody3D

@export var player_number: int
@export var red1: PackedScene
@export var red2: PackedScene
@onready var punto_disparo = $PuntoDisparo
@onready var zona_alm = $Almacenamiento
var isla
var jugador1
var jugador2
signal jugador_entra
signal jugador_sale

func _ready() -> void:
	isla = get_node("/root/Node3D/Isla")
	jugador1 = get_node("/root/Node3D/PJBase")
	jugador2 = get_node("/root/Node3D/PJBase2")
	isla.barco_entra.connect(_on_control_jugador)

func _on_control_jugador():
	jugador1.j1_puede_salir_del_barco = true
	jugador2.j2_puede_salir_del_barco = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Jugador1"):
		jugador_entra.emit()
	if body.is_in_group("Jugador2"):
		jugador_entra.emit()

func _on_area_3d_body_exited(body: Node3D) -> void:
	jugador_sale.emit()

func disparar_j1():
	var municion1 = red1.instantiate()
	
	if red1 == null:
		return
		
	get_tree().current_scene.add_child(municion1)
	municion1.global_transform = punto_disparo.global_transform

func disparar_j2():
	var municion2 = red2.instantiate()
	
	if red2 == null:
		return
	
	get_tree().current_scene.add_child(municion2)
	municion2.global_transform = punto_disparo.global_transform
