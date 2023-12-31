extends EnemyAttack
class_name EnemyRangedAttack

@export var PROJECTILE_SCENE : PackedScene = preload("res://enemies/attacks/crystal_golem_projectile.tscn")
@export var enemy: EnemyBase

func _ready():
	super._ready()

func BeginAttack():
	super.BeginAttack()
	var proj : EnemyProjectile = PROJECTILE_SCENE.instantiate()
	get_tree().root.get_child(0).add_child(proj)
	proj.set_target(enemy.player.global_position)

func EndAttack():
	super.EndAttack()

func EndDelay():
	super.EndDelay()
