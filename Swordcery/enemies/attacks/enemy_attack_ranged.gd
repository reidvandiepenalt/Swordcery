extends EnemyAttack
class_name EnemyRangedAttack

@export var PROJECTILE_SCENE : PackedScene = preload("res://enemies/attacks/crystal_golem_projectiles/crystal_golem_projectile.tscn")
@export var enemy: EnemyBase

@onready var tempTimer : Timer = $TempAttackTimer

var proj : EnemyProjectile

func _ready():
	super._ready()

func BeginAttack():
	super.BeginAttack()
	proj = PROJECTILE_SCENE.instantiate()
	get_tree().root.get_child(0).add_child(proj)
	proj.position = enemy.position
	
	#temp for testing; call from animation
	tempTimer.connect("timeout", EndAttack)
	tempTimer.start()

func EndAttack():
	super.EndAttack()
	proj.set_target(enemy.player.global_position, self)
	proj = null

func EndDelay():
	super.EndDelay()
