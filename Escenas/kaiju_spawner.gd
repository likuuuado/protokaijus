extends Node3D

# Escenas empaquetadas
@export var small_kaiju_1: PackedScene
@export var small_kaiju_2: PackedScene
@export var medium_kaiju: PackedScene

# Para variar el tiempo
@export var tiempo_minimo: float = 5.0
@export var tiempo_maximo: float = 15.0

##########################
# Además se podría agregar un máximo que se pueda generar
# para que no se sobreproduzca
##########################

@onready var path_follow: PathFollow3D = $Path3D/PathFollow3D
@onready var timer: Timer = $Timer

func _ready() -> void:
	randomize()
	# Conecatar y empezar timer
	timer.timeout.connect(_on_timer_timeout)
	timer.wait_time = randf_range(tiempo_minimo, tiempo_maximo)
	timer.start()


func _on_timer_timeout() -> void:
	# Elegir punto aleatorio del path
	path_follow.progress_ratio = randf()
	
	# Selector de tipo de kaiju a spawnear
	var peces = [
	small_kaiju_1,
	small_kaiju_2,
	medium_kaiju
	]
	# Elije un tipo de kaiju aleatorio
	var pez_scene: PackedScene = peces.pick_random()
	
	# Crear al kaiju
	var pez = pez_scene.instantiate()
	
	# Y lo añade a la escena
	get_parent().add_child(pez)
	
	# Lo coloca donde está el pathfollow
	pez.global_position = path_follow.global_position

	# Ve cuanto tiempo tiene aleatorio tiene que esperar ahora
	timer.wait_time = randf_range(tiempo_minimo, tiempo_maximo)
	timer.start()
