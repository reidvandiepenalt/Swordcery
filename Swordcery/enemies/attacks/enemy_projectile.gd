extends "res://resources/Hitbox.gd"
class_name EnemyProjectile

@export var SPEED := 100
@export var TARGET := Vector3.ZERO
@export var timeout := 10.0

@export var startupAnim := "Startup"
@export var attackAnim := "Attack"

@onready var animPlayer : AnimationPlayer = $AnimationPlayer

var attackBase: EnemyAttack

var despawn_timer := 0
var has_target := false

func _ready():
	if animPlayer:
		animPlayer.play(startupAnim)

func set_target(target: Vector3, _base: EnemyAttack = null):
	if animPlayer:
		animPlayer.play(attackAnim)
	has_target = true
	TARGET = target
	look_at(TARGET, Vector3.UP)
	if _base:
		attackBase = _base

func _physics_process(delta):
	if !has_target:
		return
	
	global_position -= SPEED * self.basis.z * delta
	
	despawn_timer += delta
	if (despawn_timer > timeout):
		destroy()

func destroy():
	if attackBase:
		attackBase.EndAttack()
	queue_free()

func _on_Projectile_area_entered(area):
	pass

func _on_Projectile_body_entered(body):
	pass
