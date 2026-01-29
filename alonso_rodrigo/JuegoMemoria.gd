extends Control

signal minijuego_finalizado(victoria)

var clase_carta = preload("res://alonso_rodrigo/Carta.gd")
var cartas_elegidas = []
var contenedor_grid: GridContainer
var pares_encontrados = 0
var label_tiempo: Label


var tiempo_restante: float = 60.0
var juego_activo: bool = true
var total_pares_objetivo: int = 8 

func _ready():
	configurar_interfaz()
	generar_tablero(4)

func _process(delta):
	if juego_activo:
		tiempo_restante -= delta
		label_tiempo.text = "ESTABILIDAD DEL SISTEMA: %d%%" % [int((tiempo_restante/60.0)*100)]
		
		if tiempo_restante <= 10:
			label_tiempo.modulate = Color.RED if Engine.get_frames_drawn() % 10 < 5 else Color.WHITE
			
		if tiempo_restante <= 0:
			finalizar_juego(false)

func configurar_interfaz():
	var centro = CenterContainer.new()
	centro.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(centro)
	
	contenedor_grid = GridContainer.new()
	contenedor_grid.columns = 4
	contenedor_grid.add_theme_constant_override("h_separation", 15)
	contenedor_grid.add_theme_constant_override("v_separation", 15)
	centro.add_child(contenedor_grid)
	
	label_tiempo = Label.new()
	label_tiempo.position = Vector2(40, 40)
	add_child(label_tiempo)

func generar_tablero(dimension: int):
	var mazo = []
	total_pares_objetivo = (dimension * dimension) / 2
	
	for i in range(total_pares_objetivo):
		mazo.append(i); mazo.append(i)
	mazo.shuffle()

	for card_id in mazo:
		var frontal = load("res://assets/img_" + str(card_id) + ".png")
		var reverso = load("res://assets/reverso.png")
		var nueva_carta = clase_carta.new(card_id, frontal, reverso)
		nueva_carta.seleccionada.connect(_on_carta_tocada)
		contenedor_grid.add_child(nueva_carta)
	
	
	vistazo_rapido(1.0)

func _on_carta_tocada(carta):
	if juego_activo and cartas_elegidas.size() < 2 and not carta.esta_revelada:
		carta.revelar()
		cartas_elegidas.append(carta)
		if cartas_elegidas.size() == 2:
			verificar_par()

func verificar_par():
	var c1 = cartas_elegidas[0]
	var c2 = cartas_elegidas[1]
	
	if c1.id == c2.id:
		pares_encontrados += 1
		
	
		if pares_encontrados % 2 == 0:
			vistazo_rapido(0.5)
		
		c1.destello_acierto()
		c2.destello_acierto()
		sacudir_tablero(10.0, 0.1)
		cartas_elegidas.clear()
		
		if pares_encontrados == total_pares_objetivo:
			finalizar_juego(true)
	else:

		tiempo_restante -= 2.0 
		pista_glitch_triple()
		
		await get_tree().create_timer(0.3).timeout
		c1.ocultar()
		c2.ocultar()
		cartas_elegidas.clear()

func vistazo_rapido(tiempo: float):
	for carta in contenedor_grid.get_children():
		if not carta.esta_revelada:
			carta.revelar()
			carta.esta_revelada = false
	
	await get_tree().create_timer(tiempo).timeout
	
	for carta in contenedor_grid.get_children():
		if not carta.esta_revelada:
			carta.ocultar()

func pista_glitch_triple():
	var candidatas = contenedor_grid.get_children().filter(func(c): return !c.esta_revelada)
	candidatas.shuffle()
	var seleccion = candidatas.slice(0, 3)
	
	for c in seleccion:
		var t = create_tween()
		t.tween_callback(func(): 
			c.texture_normal = c.imagen_frontal
			c.modulate.a = 0.3 
		)
		t.tween_interval(1.0) 
		t.tween_callback(func(): 
			if !c.esta_revelada:
				c.texture_normal = c.imagen_reverso
				c.modulate.a = 1.0
		)

func sacudir_tablero(intensidad: float, tiempo: float):
	var original_pos = position
	var t = create_tween()
	for i in range(8):
		var offset = Vector2(randf_range(-intensidad, intensidad), randf_range(-intensidad, intensidad))
		t.tween_property(self, "position", original_pos + offset, tiempo / 8)
	t.tween_property(self, "position", original_pos, 0.05)

func finalizar_juego(victoria: bool):
	juego_activo = false
	label_tiempo.text = "SISTEMA RESTAURADO" if victoria else "ERROR CRÍTICO"
	
	
	emit_signal("minijuego_finalizado", victoria)
	
	
	await get_tree().create_timer(2.0).timeout
	
	
	get_tree().change_scene_to_file("res://escenas/MundoPrincipal.tscn")
