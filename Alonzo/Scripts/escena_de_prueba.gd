extends Node2D

@onready var marcadores = $Atico/marcadores.get_children()
@onready var trozos = $"Atico/Trozos mascara".get_children()

func _ready():
	randomize()
