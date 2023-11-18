extends Node3D
class_name EnemyAttackManager

@export var attacks: Array[EnemyAttack] = []
@export var enemy: EnemyBase

var isAttacking := false

func _ready():
	for attack in attacks:
		attack.connect("AttackEnded", AttackDidEnd)

func _process(delta):
	for attack in attacks:
		if !isAttacking && enemy.dist_to_player <= attack.attack_range:
			attack.BeginAttack()
			isAttacking = true
			return

func AttackDidEnd():
	isAttacking = false
