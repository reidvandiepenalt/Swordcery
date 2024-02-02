extends Node3D
class_name EnemyAttack

signal AttackEnded
signal DelayEnded

@onready var animation : AnimationTree = $AnimationTree
@onready var attack_delay_timer := $AttackDelayTimer

@export var delay := 1.0
@export var attack_range := 2.0
@export var animation_name := "crystal_golem_melee_crystal_wave"
@export var speed_mod := 0.15

var player

func _ready():
	if animation:
		animation.set("parameters/Transition/transition_request", "Idle")
	attack_delay_timer.wait_time = delay
	attack_delay_timer.connect("timeout", EndDelay)

func BeginAttack():
	if animation:
		animation.set("parameters/Transition/transition_request", "Attacking")

func EndAttack():
	if animation:
		animation.set("parameters/Transition/transition_request", "Idle")
	attack_delay_timer.start()
	AttackEnded.emit()

func EndDelay():
	DelayEnded.emit()
