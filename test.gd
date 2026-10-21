extends Node3D

@onready var grid: Node3D = $Grid
const BUILDING = preload("res://building.tscn")

var object
var isValid = false
var objectCells
@export var currentCamera: Camera3D

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("click") and not object:
		var buildings = [BUILDING]
		var newPlacement = buildings.pick_random().instantiate()
		add_child(newPlacement)
		object = newPlacement
	elif Input.is_action_just_pressed("click") and isValid:
		_place_placement(objectCells)



func _process(delta: float) -> void:
	if not object: return
	var mouseGridPosition = _get_grid_position()
	if mouseGridPosition:
		object.global_position = mouseGridPosition
		_reset_highlight()
		objectCells = _get_object_cells()
		isValid = _check_and_highlight_cells(object, objectCells)

func _get_grid_position():
	var mousePositionDepth = 100
	var mousePosition := get_viewport().get_mouse_position()
	var params := PhysicsRayQueryParameters3D.new()
	
	params.from = currentCamera.project_ray_origin(mousePosition)
	params.to = currentCamera.project_position(mousePosition,mousePositionDepth)
	params.collide_with_bodies = false
	params.collide_with_areas = true
	
	var worldspace := get_world_3d().direct_space_state
	var intersect := worldspace.intersect_ray(params)
	
	if not intersect: return
	
	if intersect.collider.get_parent().name == "Grid":
		return intersect.collider.global_position
	else:
		return

func _reset_highlight():
	for child in grid.get_children():
		child.change_color(grid.defaultColor)

func _get_object_cells():
	var cells = []
	for child in grid.get_children():
		if child.get_rect().intersects(object.get_rect()):
			cells.append(child)
	return cells

func _check_and_highlight_cells(estructura: Node3D, objectCells: Array):
	var isValid = true
	var objectCellCount = (
		(estructura.get_rect().size.x / grid.cellSize.x)
		* (estructura.get_rect().size.y / grid.cellSize.y)
	)

	if objectCellCount != objectCells.size():
		isValid = false

	for cell in objectCells:
		if cell.full:
			isValid = false
			cell.change_color(Color.RED)
		else:
			cell.change_color(Color.GREEN)

	return isValid

func _place_placement(objectCells):
	object = null
	isValid = null
	for cell in objectCells:
		cell.full = true
	_reset_highlight()
	
func crear_vista_previa() -> Node3D:
	var buildings = [BUILDING]
	var new_placement = buildings.pick_random().instantiate()
	add_child(new_placement)
	return new_placement


func estructura_dentro_de_grilla(estructura: Node3D) -> bool:
	var rect_estructura = estructura.get_rect()

	if grid.get_child_count() == 0:
		return false

	var primera_celda = grid.get_child(0)
	var ultima_celda = grid.get_child(grid.get_child_count() - 1)

	var limite_min_x = primera_celda.global_position.x
	var limite_min_z = primera_celda.global_position.z

	var limite_max_x = limite_min_x + grid.gridWidth * grid.cellSize.x
	var limite_max_z = limite_min_z + grid.gridHeight * grid.cellSize.y

	return (
		rect_estructura.position.x >= limite_min_x
		and rect_estructura.position.y >= limite_min_z
		and rect_estructura.end.x <= limite_max_x
		and rect_estructura.end.y <= limite_max_z
	)
