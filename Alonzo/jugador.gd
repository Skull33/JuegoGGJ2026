extends CharacterBody2D

const SPEED := 100.0

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

	# Normalizar para que no vaya más rápido en diagonal
	direction = direction.normalized()

	# Aplicar velocidad
	velocity = direction * SPEED

	move_and_slide()
