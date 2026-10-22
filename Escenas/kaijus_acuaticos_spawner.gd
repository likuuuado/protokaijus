extends Node3D

@export var escena_kaiju: PackedScene
@export var contador: float = 5.0
@export var kaijus_maximos: int = 10
@export var puntos_de_aparicion: Array[Marker3D] = []
var temporizador: float = 0.0
var cantidad_kaijus: int = 0

func _process(delta: float) -> void:
	temporizador += delta
	if temporizador >= contador:
		temporizador = 0.0
		generar_kaiju()
	
func generar_kaiju():
	var indice = randi_range(0, puntos_de_aparicion.size() - 1)
	var punto = puntos_de_aparicion[indice]
	var kaiju = escena_kaiju.instantiate()
	
	if cantidad_kaijus >= kaijus_maximos:
		return
	
	if escena_kaiju == null:
		return
	
	if not is_instance_valid(punto):
		return
	
	get_tree().current_scene.add_child(kaiju)
	kaiju.global_position = punto.global_position
	cantidad_kaijus += 1
	kaiju.tree_exited.connect(func(): cantidad_kaijus -= 1 )
	
