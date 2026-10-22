extends Node

signal p1_joined
signal p2_joined

signal p1_left
signal p2_left

var p1_device := -1
var p2_device := -1

var previous_states := {}

func _ready():
	Input.joy_connection_changed.connect(_on_joy_connection_changed)

	print(Input.get_connected_joypads())


func _on_joy_connection_changed(device, connected):
	if !connected:
		if device == p1_device:
			p1_device = -1
			p1_left.emit()
		
		elif device == p2_device:
			p2_device = -1
			p2_left.emit()
	
	print(
		"Joystick ",
		device,
		" conectado: ",
		connected
	)


func _input(event):
	if event is InputEventJoypadButton:
		if !event.pressed:
			return
		
		# Si no hay P1 asignado
		if p1_device == -1:
			p1_device = event.device
			p1_joined.emit()
			print("Joystick asignado a P1: ", event.device)
			return
		
		# Si no hay P2 asignado
		if p2_device == -1 and event.device != p1_device:
			p2_device = event.device
			p2_joined.emit()
			print("Joystick asignado a P2: ", event.device)


func player_just_pressed(player_number:int, accion:String) -> bool:
	var device := p1_device
	
	if player_number == 2:
		device = p2_device
	
	if device == -1:
		return false
	
	var button := -1
	
	match accion:
		"recoger":
			button = JOY_BUTTON_A
		
		"soltar":
			button = JOY_BUTTON_X
		
		"avanzar":
			button = JOY_BUTTON_RIGHT_SHOULDER
		
		"retroceder":
			button = JOY_BUTTON_LEFT_SHOULDER
		
		"creacion":
			button = JOY_BUTTON_B
	
	if button == -1:
		return false
	
	var key = str(device) + "_" + str(button)
	
	var current: bool = Input.is_joy_button_pressed(device, button)
	
	var previous: bool = previous_states.get(key, false)
	
	previous_states[key] = current
	
	return current and !previous


func get_player_vector(player_number:int) -> Vector2:
	var device := p1_device
	
	if player_number == 2:
		device = p2_device
	
	if device == -1:
		return Vector2.ZERO
	
	var vector := Vector2(
		Input.get_joy_axis(device, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(device, JOY_AXIS_LEFT_Y)
	)
	
	# Deadzone
	if vector.length() < 0.2:
		return Vector2.ZERO
	
	return vector


#func player_pressed(player_number:int, accion:String) -> bool:
#	
#	var device := -1
#	
#	if player_number == 1:
#		device = p1_device
#	
#	elif player_number == 2:
#		device = p2_device
#	
#	if device == -1:
#		return false
#	
#	match accion:
#		"creacion":
#			return Input.is_joy_button_pressed(device, JOY_BUTTON_B)
#		
#		#"creacion":
#			#return Input.is_joy_button_pressed(device, JOY_BUTTON_B)
#		
#	return false
