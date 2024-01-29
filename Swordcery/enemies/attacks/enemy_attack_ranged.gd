extends EnemyAttack
class_name EnemyRangedAttack

@export var PROJECTILE_SCENE : PackedScene = preload("res://enemies/attacks/crystal_golem_projectiles/crystal_golem_projectile.tscn")
@export var enemy: EnemyBase

@onready var tempTimer : Timer = $TempAttackTimer
var spawnLocationRight : BoneAttachment3D
var spawnLocationLeft : BoneAttachment3D

var proj : CrystalGolemProjectile

func _ready():
	super._ready()

func BeginAttack():
	super.BeginAttack()
	
	proj = PROJECTILE_SCENE.instantiate()
	get_tree().root.get_child(0).add_child(proj)
	proj.global_position = spawnLocationRight.global_position if spawnLocationRight else enemy.global_position
	proj.set_aiming_at(enemy.player)
	
	#temp for testing; call from animation
	tempTimer.connect("timeout", EndAttack)
	tempTimer.start()

func EndAttack():
	super.EndAttack()
	proj.set_target(enemy.player.global_position, self)
	proj = null

func EndDelay():
	super.EndDelay()

func _on_right_hand_spawn_node_ready(spawnNode):
	spawnLocationRight = spawnNode


func _on_left_hand_spawn_node_ready(spawnNode):
	spawnLocationLeft = spawnNode
