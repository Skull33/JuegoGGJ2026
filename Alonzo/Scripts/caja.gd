class_name basura_atico
extends StaticBody2D

signal interactuable
@onready var anims = $"../../AnimationPlayer"
@onready var colisiones = $CollisionShape2D
@export var radio_revelacion = 10.0

var abierto = false

func abrir():
	emit_signal("interactuable")
	if abierto:
		return

	anims.play("abrir")
	colisiones.disabled = true
	abierto = true
	revelar_pieza()

func revelar_pieza():
	for pieza in get_tree().get_nodes_in_group("trozos_mascara"):
		if pieza.visible:
			continue
		
		if pieza.global_position.distance_to(global_position) < radio_revelacion:
			pieza.visible = true
			return
