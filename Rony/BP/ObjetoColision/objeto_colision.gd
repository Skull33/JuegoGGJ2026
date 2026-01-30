extends Area2D
const MY_DIALOGUE = preload("res://Rony/Dialogos/DialogosPrueba.dialogue")

var is_player_close = false
var is_dialogue_active = false
@export var start_texture: Texture
@export var start_sound: AudioStream
var continue_sound: AudioStream = preload("res://Rony/Sound/click-2-384920.mp3")

func _ready():
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	if start_texture:
		$Sprite2D.texture = start_texture
		$AudioPlayer.stream = start_sound
		$ContinuePlayer.stream = continue_sound
		_rescale_sprite()

func _rescale_sprite():
	var sprite = $Sprite2D
	var tex_size = sprite.texture.get_size()
	# ejemplo: escalar para que siempre mida 64x64
	var target_size = Vector2(32, 32)
	sprite.scale = target_size / sprite.texture.get_size()

func _process(delta):
	if is_player_close and Input.is_action_just_pressed("ui_accept"):
		if not is_dialogue_active:
			# Primer sonido al iniciar
			$AudioPlayer.play()
			DialogueManager.show_dialogue_balloon(MY_DIALOGUE)
			print("Iniciar Dialogo")
		else:
			# Segundo sonido al continuar
			$ContinuePlayer.play()
			print("Continuar Dialogo")
			
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
