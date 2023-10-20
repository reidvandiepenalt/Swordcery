extends "res://player/projectiles/player_projectile.gd"

@onready var collision := $CollisionShape3D

func _physics_process(delta):
	pass

func _on_Projectile_area_entered(area):
	pass

func _on_Projectile_body_entered(body):
	pass

func toggle_collision(collision_state: bool):
	collision.disabled = collision_state
