extends CharacterBody3D


@export var move_speed := 2.0
@export var attack_range := 2.0

var dead = false

@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("player")


func _physics_process(delta: float) -> void:
	if dead:
		return

	if player == null:
		return

	var direction_to_player = player.global_position - global_position
	direction_to_player.y = 0.0
	direction_to_player = direction_to_player.normalized()

	velocity = direction_to_player * move_speed
	move_and_slide()
	attempt_to_kill_player()


func attempt_to_kill_player() -> void:
	var distance_to_player = global_position.distance_to(player.global_position)

	if distance_to_player > attack_range:
		return

	var eye_line = Vector3.UP * 1.6
	var query = PhysicsRayQueryParameters3D.create(global_position + eye_line, player.global_position + eye_line, 1)
	var result = get_world_3d().direct_space_state.intersect_ray(query)

	if result.is_empty():
		player.kill()


func kill() -> void:
	dead = true
	$DeathSound.play()
	$AnimatedSprite3D.play("death")
	$CollisionShape3D.disabled = true
