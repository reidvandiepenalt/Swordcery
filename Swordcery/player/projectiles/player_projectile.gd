extends "res://resources/Hitbox.gd"

@export var SPEED := 100
@export var TARGET := Vector3.ZERO
@export var timeout := 20.0

var despawn_timer := 0
var has_target := false

func set_target(target: Vector3):
	has_target = true
	TARGET = target
	look_at(TARGET, Vector3.UP)

func _physics_process(delta):
	if !has_target:
		return
	
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

#add delete timeout
