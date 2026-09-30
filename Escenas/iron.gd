extends Recolectable

@export var cant_hierro: int

func collected(player_id: int):
	if player_id == 1:
		InventarioP1.add_resource("hierro", cant_hierro)
	elif player_id == 2:
		InventarioP2.add_resource("hierro", cant_hierro)
	queue_free()
