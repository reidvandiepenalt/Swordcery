extends "res://resources/Hitbox.gd"
class_name EnemyProjectile

@export var SPEED := 100
@export var TARGET := Vector3.ZERO
@export var timeout := 10.0

var despawn_timer := 0

func set_target(target: Vector3):
	TARGET = target
	look_at(TARGET, Vector3.UP)

func _physics_process(delta):
	global_position -= SPEED * self.basis.z * delta
	
	despawn_timer += delta
	if (despawn_timer > timeout):
		destroy()

func destroy():
	queue_free()

func _on_Projectile_area_entered(area):
	pass

func _on_Projectile_body_entered(body):
	pass
