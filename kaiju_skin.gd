extends Recolectable

@export var cant_piel: int = 1

func collected(player_id: int):
	if player_id == 1:
		InventarioP1.add_resource("piel", cant_piel)
	elif player_id == 2:
		InventarioP2.add_resource("piel", cant_piel)
	queue_free()
