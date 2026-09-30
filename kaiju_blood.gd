extends Recolectable

@export var cant_sangre: int

func collected(player_id: int):
	if player_id == 1:
		InventarioP1.add_resource("sangre", cant_sangre)
	elif player_id == 2:
		InventarioP2.add_resource("sangre", cant_sangre)
	queue_free()
