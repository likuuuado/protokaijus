extends Node3D



@onready var viewport1: SubViewport = $SplitScreen/HBoxContainer/SubViewportContainer1/SubViewport1
@onready var viewport2: SubViewport = $SplitScreen/HBoxContainer/SubViewportContainer2/SubViewport2


@export var camera1: Camera3D
@export var camera2: Camera3D


func _ready() -> void:
	AsignarViewports()
	AsignarCameras()
	var global_world = get_viewport().world_3d

func AsignarViewports() -> void:
	var main_viewport := get_viewport()

	viewport1.world_3d = main_viewport.world_3d
	viewport2.world_3d = main_viewport.world_3d


func AsignarCameras() -> void:
	camera1.current = true
	camera2.current = true
