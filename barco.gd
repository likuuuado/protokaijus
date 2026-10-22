extends CharacterBody3D

@export var player_number: int
@export var red: PackedScene
@onready var punto_disparo = $PuntoDisparo
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

func disparar():
	var municion = red.instantiate()
	
	if red == null:
		return
	
	get_tree().current_scene.add_child(municion)
	municion.global_transform = punto_disparo.global_transform
