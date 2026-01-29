extends RayCast2D

func _ready():
	add_exception(owner)

func _physics_process(delta):
	if is_colliding():
		var detection = get_collider()
		if detection is basura_atico:
			if Input.is_action_just_pressed("Interactuar"):
				detection.abrir()
