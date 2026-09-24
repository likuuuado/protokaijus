extends Node

var Barco = preload("res://barco.tscn")
var cantidad_barcos = 0
@onready var jugador = get_parent()

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("p1interaction") && cantidad_barcos == 0:
		var NuevoBarco = Barco.instantiate()
		add_child(NuevoBarco)
		NuevoBarco.position = Vector3(-13,2,7)
		jugador.barco_actual = NuevoBarco
		NuevoBarco.jugador_entra.connect(_on_barco_cerca)
		NuevoBarco.jugador_sale.connect(_on_barco_lejos)
		cantidad_barcos += 1

	if Input.is_action_just_pressed("p2interaction"):
		var NuevoBarco = Barco.instantiate()
		add_child(NuevoBarco)
		NuevoBarco.position = Vector3(20,2,7)
		
func _on_barco_cerca():
	jugador.puede_conducir_barco = true
	print("Presiona E")

func _on_barco_lejos():
	jugador.puede_conducir_barco = false
