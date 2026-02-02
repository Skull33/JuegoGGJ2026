extends TextureRect

@onready var trozos := {
	1: $"../trozo_1",
	2: $"../trozo_2",
	3: $"../trozo_3",
	4: $"../trozo_4"
}

func _ready():
	for t in trozos.values():
		t.visible = false

	var jugador = get_tree().get_first_node_in_group("Jugador")
	jugador.trozo_conseguido.connect(_on_trozo_conseguido)

func _on_trozo_conseguido(id):
	if trozos.has(id):
		trozos[id].visible = true
