class_name basura_atico
extends Node2D

@onready var spaws_llave = [
	$Marker2D,
	$Marker2D2
]
@onready var anims = $AnimationPlayer

var abierto = false

func _process(delta):
	var i = spaws_llave.pick_random()
