extends Area2D
const MY_DIALOGUE = preload("res://Rony/Dialogos/DialogosPrueba.dialogue")

var is_player_close = false
var is_dialogue_active = false

func _ready():
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _process(delta):
	if is_player_close and Input.is_action_just_pressed("ui_accept") and not is_dialogue_active:
		DialogueManager.show_dialogue_balloon(MY_DIALOGUE)
		print("Iniciar Dialogo")
func _on_body_entered(body):
	is_player_close = true
	# Verificamos si el que entró es el NPC
	if body.is_in_group("NPC"):
		print(true)
	
func _on_body_exited(body):
	is_player_close = false
	if body.is_in_group("NPC"):
		print(false)  # imprime False cuando sale


func _on_dialogue_started(dialogue):
	is_dialogue_active = true
	
func _on_dialogue_ended(dialogue):
	await get_tree().create_timer(0.2).timeout
	is_dialogue_active = false
