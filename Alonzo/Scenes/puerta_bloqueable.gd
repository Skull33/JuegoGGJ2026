extends Node2D

@onready var abrir_1 = $Bisabra/Area2D
@onready var abrir_2 = $Bisabra/Area2D2
@onready var animaciones = $AnimationPlayer
var abierto = false


func _on_area_2d_body_entered(body):
	if body.is_in_group("Jugador") and not abierto:
		animaciones.play("abrir 2")
		abierto = true


func _on_area_2d_body_exited(body):
	await(get_tree().create_timer(2).timeout)
	if body.is_in_group("Jugador") and abierto:
		animaciones.play_backwards("abrir 2")
		abierto = false


func _on_area_2d_2_body_entered(body):
	if body.is_in_group("Jugador") and not abierto:
		animaciones.play("abrir")
		abierto = true


func _on_area_2d_2_body_exited(body):
	await(get_tree().create_timer(2).timeout)
	if body.is_in_group("Jugador") and abierto:
		animaciones.play_backwards("abrir")
		abierto = false
