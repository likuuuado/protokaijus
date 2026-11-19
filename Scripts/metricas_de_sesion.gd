extends Node

var recurso_metricas = preload("res://local_metrics/config_metrics.tres")

var tiempo_jugado: float = 0.0
var sesion_iniciada: bool = false


func _ready() -> void:
	Metrics.register_metrics(recurso_metricas)
	
	iniciar_nueva_sesion()


func iniciar_nueva_sesion() -> void:
	tiempo_jugado = 0.0
	sesion_iniciada = true

func sesion_finalizada() -> void:
	if sesion_iniciada:
		Metrics.export_to_csv()
		sesion_iniciada = false


func _physics_process(delta: float) -> void:
	if not sesion_iniciada:
		return
	else:
		#tiempo_jugado += delta
		Metrics.record_add("tiempo_de_sesion", delta)
	
	#if Input.is_action_just_pressed("prueba de input"):
	#	sesion_finalizada()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		sesion_finalizada()
