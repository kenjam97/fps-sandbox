extends CharacterBody3D


@export var mouse_sensitivity_h = 0.15
@export var mouse_sensitivity_v = 0.15

@onready var camera_3d: Camera3D = $Camera3D
@onready var character_mover: Node3D = $CharacterMover
@onready var health_manager: Node3D = $HealthManager
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var shoot_sound: AudioStreamPlayer = $ShootSound

var dead = false


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	health_manager.init()
	health_manager.connect("dead", kill.bind())


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity_h
		camera_3d.rotation_degrees.x -= event.relative.y * mouse_sensitivity_v
		camera_3d.rotation_degrees.x = clamp(camera_3d.rotation_degrees.x, -90, 90)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		quit()

	if Input.is_action_just_pressed("restart"):
		restart()

	if Input.is_action_just_pressed("fullscreen"):
		toggleFullscreen()

	if dead:
		return

	var input_dir := Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	var move_dir := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	character_mover.set_move_dir(move_dir)

	if Input.is_action_just_pressed("jump"):
		character_mover.jump()

	if Input.is_action_just_pressed("shoot"):
		shoot()


func take_damage(damage: int, dir: Vector3):
	health_manager.take_damage(damage, dir)


func heal(amount: int):
	health_manager.heal(amount)


func kill() -> void:
	dead = true
	character_mover.freeze()


func shoot() -> void:
	shoot_sound.play()

	if ray_cast_3d.is_colliding() and ray_cast_3d.get_collider().has_method("kill"):
		ray_cast_3d.get_collider().kill()


func toggleFullscreen() -> void:
	var is_fullscreen = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN

	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func quit() -> void:
	get_tree().quit()


func restart() -> void:
	get_tree().reload_current_scene()
