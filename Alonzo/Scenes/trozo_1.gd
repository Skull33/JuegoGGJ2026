extends Node2D
signal trozo_recogido
@onready var area_entraada = $Area2D
@onready var colision = $Area2D/CollisionShape2D
@onready var sprite = $Sprite2D
@onready var Jugador = get_tree().get_first_node_in_group("Jugador")
@export var trozo_1 = false
@export var trozo_2 = false
@export var trozo_3 = false
@export var trozo_4 = false
@onready var tomar_trozo = false

func _on_area_2d_body_entered(body):
	if body == Jugador:
		emit_signal("trozo_recogido")
		tomar_trozo = true
		queue_free()
