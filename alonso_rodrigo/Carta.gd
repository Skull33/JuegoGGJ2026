class_name Carta
extends TextureButton

signal seleccionada(nodo)

var id: int
var imagen_frontal: Texture2D
var imagen_reverso: Texture2D
var esta_revelada: bool = false

func _init(_id: int, _frontal: Texture2D, _reverso: Texture2D):
	self.id = _id
	self.imagen_frontal = _frontal
	self.imagen_reverso = _reverso
	self.texture_normal = _reverso
	
	self.ignore_texture_size = true
	self.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	self.custom_minimum_size = Vector2(140, 140)

func _pressed():
	if not esta_revelada:
		emit_signal("seleccionada", self)

func revelar():
	esta_revelada = true
	texture_normal = imagen_frontal

func ocultar():
	esta_revelada = false
	texture_normal = imagen_reverso
