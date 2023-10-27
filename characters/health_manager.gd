extends Node3D


signal dead
signal hurt
signal healed
signal health_changed
signal gibbed

var cur_health: int;

@export var max_health = 100
@export var gib_at = -10


func _ready() -> void:
	init()


func init() -> void:
	cur_health = max_health
	emit_signal("health_changed", cur_health)


func take_damage(damage: int, dir: Vector3) -> void:
	if cur_health <= 0:
		return

	cur_health -= damage
	if cur_health <= gib_at:
		pass #TODO: Make gibs
		emit_signal("gibbed")

	if cur_health <= 0:
		emit_signal("dead")
		print("dead")
	else:
		emit_signal("hurt")

	emit_signal("health_changed", cur_health)
	print("hurt", damage, "current health", cur_health)


func heal(amount: int) -> void:
	if cur_health <= 0:
		return

	cur_health += amount

	if cur_health > max_health:
		cur_health = max_health

	emit_signal("healed")
	emit_signal("health_changed", cur_health)
