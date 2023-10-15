extends "res://resources/Hitbox.gd"

@export var SPEED := 100
@export var TARGET := Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	look_at(global_transform.origin + TARGET, Vector3.UP)

func _physics_process(delta):
	global_position += SPEED * self.basis.z * delta

func destroy():
	queue_free()

func _on_Projectile_area_entered(area):
	destroy()

func _on_Projectile_body_entered(body):
	destroy()

#add delete timeout
