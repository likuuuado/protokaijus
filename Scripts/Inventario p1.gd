extends Node
#inventario p1

# Máximo de tipos de materiables, ejemplo madera - hierro - sangre
const TIPO_MATERIALES_MAXIMO := 6
# Máximo de la cantidad de materiables apilados por tipo, ejemplo madera(8) - hierro(10)
const MAXIMO_MATERIALES_STACKEABLES := 10

# Diccionario de escenas para que al soltar un objeto cree una instacia del mismo
var escenas_materiales= {
	"madera": preload("res://Escenas/branch.tscn"),
	"hierro": preload("res://Escenas/iron.tscn"),
	"sangre": preload("res://Escenas/kaiju_blood.tscn"),
	"hueso": preload("res://Escenas/kaiju_bone.tscn"),
	"piel": preload("res://Escenas/kaiju_skin.tscn"),
}

# Materiales almacenados en un diccionario
# Guarda los materiales con su tipo y su cantidad
var materiales := {}

# Orden de los materiales recolectados para navegar con Q y E
# Guarda en orden solo los tipos de materiales
var orden_materiales: Array[String] = []

# Índice para recorrer el orden de los materiales
var indice := 0

func agregar_material(tipo: String, cantidad: int) -> bool: # Bool para decir se puede o no se puede
	# Si el tipo de material ya existe
	if materiales.has(tipo):
		# Y si ya están la máximo entonces false, no se puede
		if materiales[tipo] >= MAXIMO_MATERIALES_STACKEABLES:
			print("P1 Stack lleno de ", tipo)
			return false
			
		else: # Sino lo agrega y devuelve true para decir que sí se pudo
			materiales[tipo] += cantidad
			print("P1: ", materiales)
			return true
		
	# Si el tipo de material es nuevo
	if orden_materiales.size() >= TIPO_MATERIALES_MAXIMO:
		# Chekea si hay espacio para agregar un nuevo tipo de material
		print("Inventario p1 lleno")
		return false
	
	# Si hay espacio lo suma y ademas agrega el nuevo tipo al orden de materiales
	materiales[tipo] = cantidad
	orden_materiales.append(tipo)
	print("P1: ", materiales)
	return true


func soltar_material(tipo: String, cantidad: int) -> bool:
	# Se fija si tengo el tipo de material
	if !materiales.has(tipo):
		return false
	
	# Se asegura que no quite mas cantidad de la que hay
	if materiales[tipo] < cantidad:
		return false
	
	print("P1 va a soltar: ", tipo)
	
	# Entonces quita el material
	materiales[tipo] -= cantidad
	
	# Si al quitarlo llega a 0
	if materiales[tipo] <= 0:
		materiales.erase(tipo) # Se elimina el tipo del diccionario
		orden_materiales.erase(tipo) # Se elimina su nombre del orden

	if orden_materiales.is_empty():
		# Si al eliminarlo el orden queda vacío, reinicar el índice
		indice = 0 
	else:
		# Sino acomodar el índice en el valor mas cercano
		indice = clamp(indice, 0, orden_materiales.size() - 1)

	print("P1 solto un material: ", materiales)
	return true


func soltar_material_seleccionado() -> bool:
	# Si no hay materiales ignorar
	if orden_materiales.is_empty():
		return false
	# Dice cual es el material seleccionado del orden
	var material = orden_materiales[indice]
	# Y lo suelta
	return soltar_material(material, 1)


func gastar_material(tipo: String, cantidad: int) -> bool:
	if !materiales.has(tipo):
		return false
	
	if materiales[tipo] < cantidad:
		return false
	
	materiales[tipo] -= cantidad
	
	# Lo borra pero no lo suelta
	if materiales[tipo] <= 0:
		materiales.erase(tipo)
		orden_materiales.erase(tipo)
	
	if orden_materiales.is_empty():
		indice = 0
	else:
		indice = clamp(indice, 0, orden_materiales.size() - 1)
	
	print("P1 gastó: ", materiales)
	
	return true


func hay_material_seleccionado() -> bool:
	# Se asegura que exista ese material
	return !orden_materiales.is_empty()


func get_selected_scene() -> PackedScene:
	# Si no hay materiales ignorar
	if orden_materiales.is_empty():
		return null
	# Busca en lista ese material
	var material = orden_materiales[indice]
	# Y luego busca el material dentro de las escena empaquetadas
	return escenas_materiales[material] 


func indice_avanzar():
	# Si no hay materiales, no hagas nada
	if orden_materiales.is_empty():
		return
	
	# Sino aumenta el índice en 1
	indice += 1
	
	# Si el índice es mas grande que el tamaño de la lista, que vuelva al 0
	if indice >= orden_materiales.size():
		indice = 0
	print("índice avanza p1 = ", indice, " de ", orden_materiales)


func indice_retroceder():
	# Si no hay materiales, no hagas nada
	if orden_materiales.is_empty():
		return
	
	# Sino reduce el índice en 1
	indice -= 1
	
	# Si el índice es menor al tamaño de la lista, ir al máximo índice posible de la lista
	if indice < 0:
		indice = orden_materiales.size() - 1
	
	print("índice retrocede p1 = ", indice, " de ", orden_materiales)


func tiene_material(tipo: String, cantidad: int) -> bool:
	if !materiales.has(tipo):
		return false
	return materiales[tipo] >= cantidad


func get_selected_resource() -> String:
	if orden_materiales.is_empty():
		return ""
	
	return orden_materiales[indice]


func get_selected_amount() -> int:
	if orden_materiales.is_empty():
		return 0
	
	var recurso = orden_materiales[indice]
	return materiales[recurso]
