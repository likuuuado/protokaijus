extends Control

@onready var slots_1 := $Inventario/InventarioP1/HBoxContainer1.get_children()
@onready var slots_2 := $Inventario/InventarioP2/HBoxContainer2.get_children()

@onready var p1 = $"../../PJBase"
@onready var p2 = $"../../PJBase2"

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
	InventarioP1.inventario_1_actualizado.connect(actualizar_receta_p1)
	actualizar_ui_1()
	InventarioP1.indice_1_actualizado.connect(actualizar_indice_1)
	actualizar_indice_1
	
	InventarioP2.inventario_2_actualizado.connect(actualizar_ui_2)
	InventarioP2.inventario_2_actualizado.connect(actualizar_receta_p2)
	actualizar_ui_2()
	InventarioP2.indice_2_actualizado.connect(actualizar_indice_2)
	actualizar_indice_2
	
	
	p1.receta_p1_actualizada.connect(actualizar_receta_p1)
	p2.receta_p2_actualizada.connect(actualizar_receta_p2)
	
	
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


func actualizar_receta_p1():
	var indice = p1.indice_receta_p1
	var receta_id = CreaciónP1.orden_recetas[indice]
	var receta = CreaciónP1.recetas[receta_id]
	
	# Imagen
	$ModoCreación/ModoCreaciónP1/Receta1/Objeto1.texture = receta["icono"]
	
	# Nombre
	$ModoCreación/ModoCreaciónP1/Receta1/Nombre1.text = receta["nombre"]
	
	# Ingredientes
	var texto := ""
	
	for material in receta["coste"]:
		var cantidad_requerida = receta["coste"][material]
		var tiene_material = InventarioP1.tiene_material(material, cantidad_requerida)
		
		if tiene_material:
			texto += "[color=white]"
		else:
			texto += "[color=red]"
		
		texto += (
			"• "
			+ material.capitalize()
			+ " x"
			+ str(cantidad_requerida)
			+ "[/color]\n"
		)
	
	$ModoCreación/ModoCreaciónP1/Receta1/Ingredientes1.text = texto


func actualizar_receta_p2():
	var indice = p2.indice_receta_p2
	var receta_id = CreaciónP2.orden_recetas[indice]
	var receta = CreaciónP2.recetas[receta_id]
	
	# Imagen
	$ModoCreación/ModoCreaciónP2/Receta2/Objeto2.texture = receta["icono"]
	
	# Nombre
	$ModoCreación/ModoCreaciónP2/Receta2/Nombre2.text = receta["nombre"]
	
	# Ingredientes
	var texto := ""
	
	for material in receta["coste"]:
		var cantidad_requerida = receta["coste"][material]
		var tiene_material = InventarioP1.tiene_material(material, cantidad_requerida)
		
		if tiene_material:
			texto += "[color=white]"
		else:
			texto += "[color=red]"
		
		texto += (
			"• "
			+ material.capitalize()
			+ " x"
			+ str(cantidad_requerida)
			+ "[/color]\n"
		)
	
	$ModoCreación/ModoCreaciónP2/Receta2/Ingredientes2.text = texto


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
