extends "res://player/projectiles/player_projectile.gd"
class_name SwordcererMovementProj

@onready var collision := $CollisionShape3D

func _physics_process(delta):
	pass

func toggle_collision(set_to: bool):
	collision.disabled = !set_to
	visible = set_to
