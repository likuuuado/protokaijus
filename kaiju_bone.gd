extends Recolectable

@export var cant_hueso: int = 1

func collected(player_id: int):
	if player_id == 1:
		InventarioP1.add_resource("hueso", cant_hueso)
	elif player_id == 2:
		InventarioP2.add_resource("hueso", cant_hueso)
	queue_free()
