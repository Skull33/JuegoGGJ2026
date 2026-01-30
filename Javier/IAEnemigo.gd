extends CharacterBody2D

@export var velocidad: float = 120.0
var VelocidadDetectada: float = 30.0
@export var waypoint: Array[Marker2D] = []
@export var distancia_llegada: float = 6.0

@onready var vision_area: Area2D = $Area2D
@onready var segunda_area: Area2D = $AreaMinijuego

var actualwAYPOINT: int = 0
var _direccion: int = 1 # 1 = adelante, -1 = atrás

var objetivo_personaje: CharacterBody2D = null
var persiguiendo: bool = false

var minijuego_escena = preload("res://alonso_rodrigo/JuegoMemoria.tscn")
var instancia_puzle: Control = null

func _ready() -> void:
	vision_area.body_entered.connect(_on_vision_body_entered)
	vision_area.body_exited.connect(_on_vision_body_exited)
	segunda_area.body_entered.connect(_on_segunda_area_entered)
	segunda_area.body_exited.connect(_on_segunda_area_exited)

func _physics_process(delta: float) -> void:
	if persiguiendo and is_instance_valid(objetivo_personaje):
		_perseguir()
	else:
		_patrullar()

	if velocity.length() > 0.1:
		vision_area.rotation = velocity.angle()

	move_and_slide()

func _patrullar() -> void:
	persiguiendo = false
	objetivo_personaje = null

	if waypoint.is_empty():
		velocity = Vector2.ZERO
		return

	actualwAYPOINT = clamp(actualwAYPOINT, 0, waypoint.size() - 1)

	var objetivo: Vector2 = waypoint[actualwAYPOINT].global_position
	var to_obj: Vector2 = objetivo - global_position

	if to_obj.length() <= distancia_llegada:
		if actualwAYPOINT == waypoint.size() - 1:
			_direccion = -1
		elif actualwAYPOINT == 0:
			_direccion = 1

		actualwAYPOINT += _direccion
		actualwAYPOINT = clamp(actualwAYPOINT, 0, waypoint.size() - 1)

		objetivo = waypoint[actualwAYPOINT].global_position
		to_obj = objetivo - global_position

	velocity = to_obj.normalized() * velocidad

func _perseguir() -> void:
	var to_target: Vector2 = objetivo_personaje.global_position - global_position
	velocity = to_target.normalized() * velocidad

func _on_vision_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		objetivo_personaje = body as CharacterBody2D
		persiguiendo = true
		velocidad = velocidad + VelocidadDetectada

func _on_vision_body_exited(body: Node) -> void:
	if body == objetivo_personaje:
		objetivo_personaje = null
		persiguiendo = false
		velocidad = velocidad - VelocidadDetectada

# ---------------- SEGUNDA ÁREA (MINIJUEGO) ----------------

func _on_segunda_area_entered(body: Node) -> void:
	if body.is_in_group("player") and instancia_puzle == null:
		instancia_puzle = minijuego_escena.instantiate()
		get_tree().root.add_child(instancia_puzle)
		instancia_puzle.minijuego_finalizado.connect(_on_puzle_terminado)

func _on_segunda_area_exited(body: Node) -> void:
	if body.is_in_group("player") and instancia_puzle != null:
		instancia_puzle.queue_free()
		instancia_puzle = null

func _on_puzle_terminado(victoria: bool) -> void:
	if victoria:
		
		queue_free()
	else:
		
		get_tree().reload_current_scene()
	
	instancia_puzle = null
