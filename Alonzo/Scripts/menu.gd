extends CanvasLayer

@onready var iniciar = $Iniciar
@onready var salir = $Salir

func _ready() :
	iniciar.pressed.connect(inicio)
	salir.pressed.connect(salio)

func inicio():
	get_tree().change_scene_to_file("res://Alonzo/Scenes/Escena de Prueba.tscn")

func salio():
	get_tree().quit()
