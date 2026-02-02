extends Node2D

@onready var escena = get_tree().get_first_node_in_group("escena")
@onready var jugador = get_tree().get_first_node_in_group("Jugador")
@onready var anims = $AnimationPlayer


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == jugador and escena.contador_piezas < 4:
		return
	if body == jugador and escena.contador_piezas == 4:
		anims.play("abrir")
