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
	self.pivot_offset = Vector2(70, 70)

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	if not esta_revelada: animar_escala(Vector2(1.05, 1.05), 0.1)

func _on_mouse_exited():
	if not esta_revelada: animar_escala(Vector2(1.0, 1.0), 0.1)

func _pressed():
	if not esta_revelada:
		animar_escala(Vector2(0.95, 0.95), 0.05)
		emit_signal("seleccionada", self)

func animar_escala(objetivo: Vector2, tiempo: float):
	if tween: tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", objetivo, tiempo).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func revelar():
	esta_revelada = true
	var tween_flip = create_tween()
	tween_flip.tween_property(self, "scale:x", 0.0, 0.05)
	tween_flip.tween_callback(func(): texture_normal = imagen_frontal)
	tween_flip.tween_property(self, "scale:x", 1.0, 0.05)

func ocultar():
	esta_revelada = false
	var tween_flip = create_tween()
	tween_flip.tween_property(self, "scale:x", 0.0, 0.05)
	tween_flip.tween_callback(func(): texture_normal = imagen_reverso)
	tween_flip.tween_property(self, "scale:x", 1.0, 0.05)

func destello_acierto():
	var tween_brillo = create_tween()
	self.modulate = Color(2.5, 2.5, 2.5) 
	tween_brillo.tween_property(self, "modulate", Color.WHITE, 0.3)
	animar_escala(Vector2(1.1, 1.1), 0.1)
	await get_tree().create_timer(0.1).timeout
	animar_escala(Vector2(1.0, 1.0), 0.1)
