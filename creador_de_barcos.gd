extends Node

var barco1 = preload("res://barco.tscn")
var barco2 = preload("res://barco_2.tscn")
var cantidad_barcos_j1 = 0
var cantidad_barcos_j2 = 0
var jugador_entra = false
@onready var jugador1 = get_node("/root/Node3D/PJBase")
@onready var jugador2 = get_node("/root/Node3D/PJBase2")

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if jugador_entra:
		if (Input.is_action_just_pressed("p1interactuar") or JoystickControlManager.player_just_pressed(1, "interactuar")) and cantidad_barcos_j1 == 0 and jugador1.player_number == 1 and InventarioP1.materiales.get("pack_barco", 0):
			InventarioP1.gastar_material("pack_barco", 1)
			var barco_jugador1 = barco1.instantiate()
			barco_jugador1.name = "barco"
			add_child(barco_jugador1)
			barco_jugador1.position = Vector3(-6,2,-2)
			jugador1.barco_actual = barco_jugador1
			barco_jugador1.jugador_entra.connect(_on_barco_cerca)
			barco_jugador1.jugador_sale.connect(_on_barco_lejos)
			cantidad_barcos_j1 += 1

		if (Input.is_action_just_pressed("p2interactuar") or JoystickControlManager.player_just_pressed(2, "interactuar")) and cantidad_barcos_j2 == 0 and jugador2.player_number == 2 and InventarioP2.materiales.get("pack_barco", 0):
			InventarioP2.gastar_material("pack_barco", 1)
			var barco_jugador2 = barco2.instantiate()
			add_child(barco_jugador2)
			barco_jugador2.position = Vector3(-7,2,-3)
			barco_jugador2.rotate(Vector3(0,1,0),110)
			jugador2.barco_actual = barco_jugador2
			barco_jugador2.jugador_entra.connect(_on_barco_cerca)
			barco_jugador2.jugador_sale.connect(_on_barco_lejos)
			cantidad_barcos_j2 += 1
		
func _on_barco_cerca():
	jugador1.j1_puede_conducir_barco = true
	jugador2.j2_puede_conducir_barco = true
	
func _on_barco_lejos():
	jugador1.j1_puede_conducir_barco = false
	jugador2.j2_puede_conducir_barco = false


func _on_area_spawn_barco_1_body_entered(body: Node3D) -> void:
	if body.is_in_group("Jugador1"):
		jugador_entra = true
		print("E")

func _on_area_spawn_barco_1_body_exited(body: Node3D) -> void:
	if body.is_in_group("Jugador1"):
		jugador_entra = false


func _on_area_spawn_barco_2_body_entered(body: Node3D) -> void:
	if body.is_in_group("Jugador2"):
		jugador_entra = true


func _on_area_spawn_barco_2_body_exited(body: Node3D) -> void:
	if body.is_in_group("Jugador2"):
		jugador_entra = false
