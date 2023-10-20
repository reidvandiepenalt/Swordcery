extends "res://resources/Hitbox.gd"

@export var SPEED := 100
@export var TARGET := Vector3.ZERO

func set_target(target: Vector3):
	TARGET = target
	look_at(TARGET, Vector3.UP)

func _physics_process(delta):
	global_position -= SPEED * self.basis.z * delta

func destroy():
	queue_free()

#add delete timeout
