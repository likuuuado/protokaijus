extends Recolectable

@export var cant_madera: int

func collected(player_id: int):
	if player_id == 1:
		InventarioP1.add_resource("madera", cant_madera)
	elif player_id == 2:
		InventarioP2.add_resource("madera", cant_madera)
	queue_free()
