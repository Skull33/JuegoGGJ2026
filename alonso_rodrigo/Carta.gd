class_name Carta
extends TextureButton

signal seleccionada(nodo)

var id: int
var imagen_frontal: Texture2D
var imagen_reverso: Texture2D
var esta_revelada: bool = false
var tween: Tween

func _init(_id: int, _frontal: Texture2D, _reverso: Texture2D):
	self.id = _id
	self.imagen_frontal = _frontal
	self.imagen_reverso = _reverso
	self.texture_normal = _reverso
	self.ignore_texture_size = true
	self.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	self.custom_minimum_size = Vector2(140, 140)
	self.pivot_offset = Vector2(70, 70) # Centro del pivote para transformaciones simétricas

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	# Escala más agresiva y rápida para feedback inmediato
	if not esta_revelada: animar_escala(Vector2(1.1, 1.1), 0.05)

func _on_mouse_exited():
	if not esta_revelada: animar_escala(Vector2(1.0, 1.0), 0.05)

func _pressed():
	if not esta_revelada:
		# Contracción rápida al clickear
		animar_escala(Vector2(0.9, 0.9), 0.03)
		emit_signal("seleccionada", self)

func animar_escala(objetivo: Vector2, tiempo: float):
	if tween: tween.kill()
	tween = create_tween()
	# Uso de TRANS_BACK para un ligero efecto de rebote sutil pero rápido
	tween.tween_property(self, "scale", objetivo, tiempo).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func revelar():
	esta_revelada = true
	var tween_flip = create_tween()
	# Reducción de tiempo a 0.04s por lado (Total 0.08s) para máxima fluidez
	tween_flip.tween_property(self, "scale:x", 0.0, 0.04).set_trans(Tween.TRANS_SINE)
	tween_flip.tween_callback(func(): texture_normal = imagen_frontal)
	tween_flip.tween_property(self, "scale:x", 1.0, 0.04).set_trans(Tween.TRANS_SINE)

func ocultar():
	esta_revelada = false
	var tween_flip = create_tween()
	tween_flip.tween_property(self, "scale:x", 0.0, 0.04).set_trans(Tween.TRANS_SINE)
	tween_flip.tween_callback(func(): texture_normal = imagen_reverso)
	tween_flip.tween_property(self, "scale:x", 1.0, 0.04).set_trans(Tween.TRANS_SINE)

func destello_acierto():
	var tween_brillo = create_tween().set_parallel(true)
	# Brillo extremo momentáneo (Sobrecarga de color)
	self.modulate = Color(4.0, 4.0, 4.0) 
	tween_brillo.tween_property(self, "modulate", Color.WHITE, 0.2)
	# Pulso de escala rápido
	tween_brillo.tween_property(self, "scale", Vector2(1.2, 1.2), 0.1).set_trans(Tween.TRANS_ELASTIC)
	
	await get_tree().create_timer(0.1).timeout
	animar_escala(Vector2(1.0, 1.0), 0.05)
