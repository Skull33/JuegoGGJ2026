extends Control


var clase_carta = preload("res://alonso_rodrigo/Carta.gd")

var cartas_elegidas = []
var contenedor_grid: GridContainer
var pares_encontrados = 0

func _ready():
	configurar_interfaz()
	generar_tablero(4) 

func configurar_interfaz():
	var centro = CenterContainer.new()
	centro.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(centro)
	
	contenedor_grid = GridContainer.new()
	contenedor_grid.columns = 4
	contenedor_grid.add_theme_constant_override("h_separation", 15)
	contenedor_grid.add_theme_constant_override("v_separation", 15)
	centro.add_child(contenedor_grid)

func generar_tablero(dimension: int):
	var mazo = []
	for i in range((dimension * dimension) / 2):
		mazo.append(i); mazo.append(i)
	mazo.shuffle()

	for card_id in mazo:
		var frontal = load("res://alonso_rodrigo/assets/img_%d.png" % card_id)
		var reverso = load("res://alonso_rodrigo/assets/reverso.png")
		
		
		var nueva_carta = clase_carta.new(card_id, frontal, reverso)
		nueva_carta.seleccionada.connect(_on_carta_tocada)
		contenedor_grid.add_child(nueva_carta)

func _on_carta_tocada(carta):
	if cartas_elegidas.size() < 2:
		carta.revelar()
		cartas_elegidas.append(carta)
		if cartas_elegidas.size() == 2:
			validar_par()

func validar_par():
	var c1 = cartas_elegidas[0]
	var c2 = cartas_elegidas[1]
	
	if c1.id == c2.id:
		pares_encontrados += 1
		cartas_elegidas.clear()
		if pares_encontrados == 8:
			print("¡Victoria!")
	else:
		await get_tree().create_timer(0.8).timeout
		c1.ocultar()
		c2.ocultar()
		cartas_elegidas.clear()
