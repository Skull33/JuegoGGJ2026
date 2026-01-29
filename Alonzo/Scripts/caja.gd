class_name basura_atico
extends StaticBody2D

signal interactuable
@onready var anims = $"../../AnimationPlayer"
@onready var colisiones = $CollisionShape2D

var abierto = false

func abrir():
	emit_signal("interactuable")
	if Input.is_action_just_pressed("Interactuar") and not abierto:
		anims.play("abrir")
		colisiones.disabled = true
		abierto = true
