extends EnemyAttack
class_name EnemyRangedAttack

@export var PROJECTILE_SCENE : PackedScene = preload("res://enemies/attacks/crystal_golem_projectiles/crystal_golem_projectile.tscn")
@export var enemy: EnemyBase
@export var spawnLocationRightPath : NodePath
@export var spawnLocationLeftPath : NodePath

@onready var tempTimer : Timer = $TempAttackTimer
@onready var spawnLocationRight := get_node_or_null(spawnLocationRightPath)
@onready var spawnLocationLeft := get_node_or_null(spawnLocationLeftPath)

var proj : CrystalGolemProjectile

func _ready():
	super._ready()

func _physics_process(delta):
	print(spawnLocationRightPath)
	print(get_node_or_null(spawnLocationRightPath))
	pass

func BeginAttack():
	super.BeginAttack()
	
	proj = PROJECTILE_SCENE.instantiate()
	get_tree().root.get_child(0).add_child(proj)
	proj.position = spawnLocationRight.position if spawnLocationRight else enemy.position
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
