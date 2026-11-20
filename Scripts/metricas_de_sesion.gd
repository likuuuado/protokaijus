extends Node

var recurso_metricas = preload("res://local_metrics/config_metrics.tres")

var tiempo_jugado: float = 0.0
var sesion_iniciada: bool = false

var _primer_procesador_registrado: Dictionary = {1: false, 2: false}
var _primer_barco_registrado: Dictionary = {1: false, 2: false}

var creaciones_por_jugador: Dictionary = {
	1: {},
	2: {}
}

func _ready() -> void:
	Metrics.register_metrics(recurso_metricas)
	iniciar_nueva_sesion()


func iniciar_nueva_sesion() -> void:
	tiempo_jugado = 0.0
	sesion_iniciada = true

	_primer_procesador_registrado = {1: false, 2: false}
	_primer_barco_registrado = {1: false, 2: false}

	creaciones_por_jugador[1].clear()
	creaciones_por_jugador[2].clear()
	Metrics.record_set("creaciones_p1", "")
	Metrics.record_set("creaciones_p2", "")

	Metrics.record_set("tiempo_hasta_procesador_p1", 0.0)
	Metrics.record_set("tiempo_hasta_procesador_p2", 0.0)
	Metrics.record_set("tiempo_hasta_barco_p1", 0.0)
	Metrics.record_set("tiempo_hasta_barco_p2", 0.0)


func sesion_finalizada() -> void:
	if sesion_iniciada:
		Metrics.record_set("tiempo_de_sesion", tiempo_jugado)
		Metrics.export_to_csv()
		sesion_iniciada = false


func registrar_creacion(player_id: int, receta_id: String, nombre_legible: String = "") -> void:
	if not creaciones_por_jugador.has(player_id):
		return

	var etiqueta := nombre_legible.to_lower() if nombre_legible != "" else receta_id.replace("_", " ")
	var dict_player: Dictionary = creaciones_por_jugador[player_id]
	dict_player[etiqueta] = dict_player.get(etiqueta, 0) + 1

	var partes: Array[String] = []
	for item in dict_player:
		partes.append("%s x%d" % [item, dict_player[item]])

	var contenido := " - ".join(partes) if not partes.is_empty() else "ninguno"
	var prefijo := "P1: " if player_id == 1 else "P2: "
	var metric_id := "creaciones_p1" if player_id == 1 else "creaciones_p2"

	Metrics.record_set(metric_id, prefijo + contenido)


func registrar_primer_procesador(player_id: int) -> void:
	if not sesion_iniciada or not _primer_procesador_registrado.has(player_id):
		return
	if _primer_procesador_registrado[player_id]:
		return

	_primer_procesador_registrado[player_id] = true
	var metric_id := "tiempo_hasta_procesador_p1" if player_id == 1 else "tiempo_hasta_procesador_p2"
	Metrics.record_set(metric_id, tiempo_jugado)


func registrar_primer_barco(player_id: int) -> void:
	if not sesion_iniciada or not _primer_barco_registrado.has(player_id):
		return
	if _primer_barco_registrado[player_id]:
		return

	_primer_barco_registrado[player_id] = true
	var metric_id := "tiempo_hasta_barco_p1" if player_id == 1 else "tiempo_hasta_barco_p2"
	Metrics.record_set(metric_id, tiempo_jugado)


func _physics_process(delta: float) -> void:
	if not sesion_iniciada:
		return

	tiempo_jugado += delta
	Metrics.record_set("tiempo_de_sesion", tiempo_jugado)


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		sesion_finalizada()
