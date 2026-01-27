extends CharacterBody2D

const SPEED := 300.0

func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO

	# Entrada WASD
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1

	# Normalizar para que no vaya más rápido en diagonal
	direction = direction.normalized()

	# Aplicar velocidad
	velocity = direction * SPEED

	move_and_slide()
