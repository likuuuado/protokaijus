extends RigidBody3D
class_name Recolectable

# Para conecatar las señales
@onready var area: Area3D = $Area3D

# Saber si el jugador está en rango para poder interactuar con él
var player_1_in_range: bool = false 
var player_2_in_range: bool = false 

# Conectar señales para la detección de body_entered
func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

# Si el cuerpo al que se entró está en el grupo P1/2_body están en rango
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("P1_body"): 
		player_1_in_range = true
		# El grupo global P1/2_body es distinto de los grupos P1 y P2
		# Para que no haya errores
	if body.is_in_group("P2_body"):
		player_2_in_range = true

# Para saber si ya no está en rango para interactuar
func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("P1_body"):
		player_1_in_range = false
		
	if body.is_in_group("P2_body"):
		player_2_in_range = false

# Función virtual cuando se colecta que se overrideara según cada objeto
# Espera una id del jugador para saber quién recolecto el objeto
func collected(player_id: int) -> void:
	pass


func _physics_process(delta: float) -> void:
	
	# Se fija si algún player está en rango
	# Si lo está y además se presiona la tecla ahí sabrá quién lo recoleto
	if player_1_in_range == true and Input.is_action_just_pressed("p1recoger"):
		collected(1)
		# Activa collected() y le da la id del player
		# Que la sabe por el grupo y la tecla presionada
	
	if player_2_in_range == true and Input.is_action_just_pressed("p2recoger"):
		collected(2) 
