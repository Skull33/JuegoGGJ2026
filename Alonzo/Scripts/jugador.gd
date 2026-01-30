extends CharacterBody2D

const SPEED := 100.0

@onready var anims = $AnimationPlayer

enum  Estados
{
	IDLE,
	WALK
}
var estado_actual:Estados = Estados.IDLE

func _process(delta):
	var direction = Vector2.ZERO
	var mouse_pos = get_global_mouse_position()
	var mouse_dir = (mouse_pos - global_position).normalized()
	rotation = mouse_dir.angle()

	# Entrada WASD (Recien antes eran las direccionales)
	if Input.is_action_pressed("Izquierda"):
		direction.x -= 1
	if Input.is_action_pressed("Derecha"):
		direction.x += 1
	if Input.is_action_pressed("Adelante"):
		direction.y -= 1
	if Input.is_action_pressed("Atras"):
		direction.y += 1
	
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * SPEED
		move_and_slide()
		cambiar_estado(Estados.WALK)
	else:
		velocity = Vector2.ZERO
		move_and_slide()
		cambiar_estado(Estados.IDLE)
	
	# Normalizar para que no vaya más rápido en diagonal
	direction = direction.normalized()

	# Aplicar velocidad
	velocity = direction * SPEED

	move_and_slide()

func cambiar_estado(nuevo_estado:Estados):
	if estado_actual == nuevo_estado:
		return
	
	estado_actual = nuevo_estado
	match estado_actual:
		Estados.IDLE:
			anims.play("RESET")
		Estados.WALK:
			anims.play("caminar")
