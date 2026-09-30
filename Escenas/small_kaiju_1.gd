extends Recolectable

@export var Mat_Sangre: int
@export var Mat_Hueso: int

func collected(player_id: int):
	
	queue_free()
