extends Node3D
class_name EnemyAttackManager

@export var attacks: Array[EnemyAttack] = []
@export var enemy: EnemyBase

var isAttacking := false

signal RotationLock(rot_lock: bool)

func _ready():
	for attack in attacks:
		attack.connect("AttackEnded", AttackDidEnd)
	
	RotationLock.connect(Callable(enemy.toggle_rotation_lock))

func _process(delta):
	for attack in attacks:
		if !isAttacking && enemy.dist_to_player <= attack.attack_range:
			enemy.look_at(enemy.player.global_position, Vector3.UP, true)
			attack.BeginAttack()
			isAttacking = true
			RotationLock.emit(true)
			enemy.set_speed_modifier(attack.speed_mod)
			return

func AttackDidEnd():
	isAttacking = false
	RotationLock.emit(false)
	enemy.set_speed_modifier(1)
