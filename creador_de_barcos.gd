extends Node

var barco1 = preload("res://barco.tscn")
var barco2 = preload("res://barco_2.tscn")
var cantidad_barcos_j1 = 0
var cantidad_barcos_j2 = 0
@onready var jugador = get_parent()

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("p1interaction") and cantidad_barcos_j1 == 0 and jugador.player_number == 1:
		var barco_jugador1 = barco1.instantiate()
		add_child(barco_jugador1)
		barco_jugador1.position = Vector3(-13,2,7)
		jugador.barco_actual = barco_jugador1
		barco_jugador1.jugador_entra.connect(_on_barco_cerca)
		barco_jugador1.jugador_sale.connect(_on_barco_lejos)
		cantidad_barcos_j1 += 1

	if Input.is_action_just_pressed("p2interaction") and cantidad_barcos_j2 == 0 and jugador.player_number == 2:
		var barco_jugador2 = barco2.instantiate()
		add_child(barco_jugador2)
		barco_jugador2.position = Vector3(20,2,7)
		barco_jugador2.rotate(Vector3(0,1,0),110)
		jugador.barco_actual = barco_jugador2
		barco_jugador2.jugador_entra.connect(_on_barco_cerca)
		barco_jugador2.jugador_sale.connect(_on_barco_lejos)
		cantidad_barcos_j2 += 1
		
func _on_barco_cerca():
	jugador.j1_puede_conducir_barco = true
	jugador.j2_puede_conducir_barco = true
	
func _on_barco_lejos():
	jugador.j1_puede_conducir_barco = false
	jugador.j2_puede_conducir_barco = false
