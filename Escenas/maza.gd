extends Recolectable # Extiende del script base Recolectable

@export var cant_maza: int = 1 # Cantidad de material que tiene el objeto

func collected(player_id: int):
	var recogido := false
	if player_id == 1:
		recogido = InventarioP1.agregar_material("maza", cant_maza)
	
	elif player_id == 2:
		recogido = InventarioP2.agregar_material("maza", cant_maza)

	if recogido:
		queue_free()
