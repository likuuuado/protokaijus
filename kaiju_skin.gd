extends Recolectable # Extiende del script base Recolectable


@export var cant_piel: int = 1 # Cantidad de material que tiene el objeto


func collected(player_id: int):
	if player_id == 1: # Si la id que se le paso es esta
		InventarioP1.add_resource("piel", cant_piel) # Hay que indicar que tipo de material es, y despues darle la cantidad
		# Agrega el material al player indicado por la id
	elif player_id == 2:
		InventarioP2.add_resource("piel", cant_piel)
	queue_free()
