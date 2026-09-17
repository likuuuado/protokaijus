extends Node

var Barco = preload("res://barco.tscn")
@onready var jugador = get_parent()

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("p1interaction"):
		var NuevoBarco = Barco.instantiate()
		add_child(NuevoBarco)
		NuevoBarco.position = Vector3(-13,2,7)
		
	if Input.is_action_just_pressed("p2interaction"):
		var NuevoBarco = Barco.instantiate()
		add_child(NuevoBarco)
		NuevoBarco.position = Vector3(20,2,7)
