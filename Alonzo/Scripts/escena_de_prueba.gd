extends Node2D

@onready var marcadores = $Atico/marcadores.get_children()
@onready var trozos = $"Atico/Trozos mascara".get_children()
@onready var trozos_mascara = get_tree().get_nodes_in_group("trozos_mascara")
var contador_piezas = 0

func _ready():
	randomize()
	marcadores.shuffle()
	
	for i in trozos.size():
		if i < marcadores.size():
			trozos[i].global_position = marcadores[i].global_position
	
	for trozo in trozos_mascara:
		trozo.trozo_recogido.connect(_on_trozo_recogido)

func _on_trozo_recogido():
	contador_piezas += 1
	print("Piezas:", contador_piezas)

	if contador_piezas == 4:
		print("Lárgate de aquí")
