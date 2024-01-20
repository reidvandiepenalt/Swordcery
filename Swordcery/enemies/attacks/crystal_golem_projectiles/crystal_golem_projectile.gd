extends EnemyProjectile
class_name CrystalGolemProjectile

@export var spinDegreesPerSecond := 1800
@export var startupSpinMod := 0.2

@onready var model := $crystalSpear

var aiming_at : Node3D

func set_aiming_at(target: Node3D):
	aiming_at = target

func set_target(target: Vector3, _base: EnemyAttack = null):
	if animPlayer:
		animPlayer.play(attackAnim)
	has_target = true
	TARGET = target
	model.look_at(TARGET, Vector3.UP)
	if _base:
		attackBase = _base

func _physics_process(delta):
	model.rotate(model.basis.z, delta * spinDegreesPerSecond * (1 if has_target else startupSpinMod))
	
	if !has_target:
		if(aiming_at):
			model.look_at(aiming_at.position, Vector3.UP)
		return
	
	global_position -= SPEED * model.basis.z * delta
	
	despawn_timer += delta
	if (despawn_timer > timeout):
		destroy()
