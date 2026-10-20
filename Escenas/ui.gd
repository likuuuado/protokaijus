extends Control

@onready var slots_1 := $Inventario/InventarioP1/HBoxContainer1.get_children()
@onready var slots_2 := $Inventario/InventarioP2/HBoxContainer2.get_children()

var visibilidad_modo_creacion_p1 : bool
var visibilidad_modo_creacion_p2 : bool

var iconos = {
	"madera": preload("res://Assets/Assets 2D/Rama.png"),
	"hierro": preload("res://Assets/Assets 2D/Hierro.png"),
	"sangre": preload("res://Assets/Assets 2D/Sangre.png"),
	"hueso": preload("res://Assets/Assets 2D/Hueso.png"),
	"piel": preload("res://Assets/Assets 2D/Piel.png"),
	"combustible": preload("res://Assets/Assets 2D/Combustible.png"),
	"pack_barco": preload("res://Assets/Assets 2D/Caja madera.png"),
	"pack_construccion": preload("res://Assets/Assets 2D/Caja metal.png"),
}


func _ready():
	InventarioP1.inventario_1_actualizado.connect(actualizar_ui_1)
	actualizar_ui_1()
	InventarioP1.indice_1_actualizado.connect(actualizar_indice_1)
	actualizar_indice_1
	
	InventarioP2.inventario_2_actualizado.connect(actualizar_ui_2)
	actualizar_ui_2()
	InventarioP2.indice_2_actualizado.connect(actualizar_indice_2)
	actualizar_indice_2
	
	var visibilidad_modo_creacion_p1 = false
	var visibilidad_modo_creacion_p2 = false


func actualizar_ui_1():
	for i in range(slots_1.size()):
		var texture_rect = slots_1[i].get_node("icono")
		var label = slots_1[i].get_node("Label")
		
		if i < InventarioP1.orden_materiales.size():
			var material = InventarioP1.orden_materiales[i]
			texture_rect.texture = iconos[material]
			label.text = str(InventarioP1.materiales[material])
			
		else:
			texture_rect.texture = null
			label.text = ""

func actualizar_ui_2():
	for i in range(slots_2.size()):
		var texture_rect = slots_2[i].get_node("icono")
		var label = slots_2[i].get_node("Label")
		
		if i < InventarioP2.orden_materiales.size():
			var material = InventarioP2.orden_materiales[i]
			texture_rect.texture = iconos[material]
			label.text = str(InventarioP2.materiales[material])
			
		else:
			texture_rect.texture = null
			label.text = ""


func actualizar_indice_1():
	if InventarioP1.orden_materiales.is_empty():
		return
	
	var slot_actual = slots_1[InventarioP1.indice]
	
	$"Inventario/InventarioP1/índice1".global_position = slot_actual.global_position - Vector2(4,4)

func actualizar_indice_2():
	if InventarioP2.orden_materiales.is_empty():
		return
	
	var slot_actual = slots_2[InventarioP2.indice]
	
	$"Inventario/InventarioP2/índice2".global_position = slot_actual.global_position - Vector2(4,4)

func _physics_process(delta: float) -> void:
	
	if visibilidad_modo_creacion_p1 == false:
		$"ModoCreación/ModoCreaciónP1".hide()
	
	if visibilidad_modo_creacion_p1 == true:
		$"ModoCreación/ModoCreaciónP1".show()
	
	
	if visibilidad_modo_creacion_p2 == false:
		$"ModoCreación/ModoCreaciónP2".hide()
	
	if visibilidad_modo_creacion_p2 == true:
		$"ModoCreación/ModoCreaciónP2".show()
	
	if Input.is_action_just_pressed("p1creacion"):
		visibilidad_modo_creacion_p1 = !visibilidad_modo_creacion_p1
	
	if Input.is_action_just_pressed("p2creacion"):
		visibilidad_modo_creacion_p2 = !visibilidad_modo_creacion_p2
