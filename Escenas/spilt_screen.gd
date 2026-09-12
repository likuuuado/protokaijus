extends Control


@export var viewport1: SubViewport
@export var viewport2: SubViewport


@export var camera1: Camera3D
@export var camera2: Camera3D


func _ready() -> void:
	AsignarViewports()
	AsignarCameras()


func AsignarViewports() -> void:
	var main_viewport := get_viewport()

	viewport1.world_3d = main_viewport.world_3d
	viewport2.world_3d = main_viewport.world_3d


func AsignarCameras() -> void:
	camera1.current = true
	camera2.current = true
