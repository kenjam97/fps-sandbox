extends Node3D


@export var jump_force = 15.0
@export var gravity = 30.0
@export var max_speed = 15.0
@export var move_accel = 4.0
@export var stop_drag = 0.9

var character_body: CharacterBody3D
var move_drag = 0.0
var move_dir: Vector3
var frozen = false


func _ready() -> void:
	character_body = get_parent()
	move_drag = float(move_accel) / max_speed


func set_move_dir(new_move_dir: Vector3) -> void:
	move_dir = new_move_dir


func jump() -> void:
	if character_body.is_on_floor():
		character_body.velocity.y = jump_force


func _physics_process(delta: float) -> void:
	if frozen:
		return

	if character_body.velocity.y > 0.0 and character_body.is_on_ceiling():
		character_body.velocity.y = 0.0

	if not character_body.is_on_floor():
		character_body.velocity.y -= gravity * delta

	var drag = move_drag
	if move_dir.is_zero_approx():
		drag = stop_drag

	var flat_velocity = character_body.velocity
	flat_velocity.y = 0.0
	character_body.velocity += move_accel * move_dir - flat_velocity * drag

	character_body.move_and_slide()


func freeze() -> void:
	frozen = true


func unfreeze() -> void:
	frozen = false
