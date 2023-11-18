extends Node3D
class_name EnemyAttack

signal AttackEnded

@onready var hitbox := $Hitbox
@onready var model := $Model
@onready var attack_length_timer := $EndAttackTimer
@onready var attack_delay_timer := $AttackDelayTimer

@export var attack_length := 0.3
@export var delay := 1.0
@export var attack_range := 2.0

func _ready():
	#probably manage hitbox stuff from animation
	hitbox.monitorable = false
	model.visible = false
	attack_length_timer.wait_time = attack_length
	attack_length_timer.connect("timeout", EndAttack)
	attack_delay_timer.wait_time = delay + attack_length
	attack_delay_timer.connect("timeout", EndDelay)

func BeginAttack():
	hitbox.monitorable = true
	model.visible = true
	attack_length_timer.start()
	attack_delay_timer.start()

func EndAttack():
	hitbox.monitorable = false
	model.visible = false

func EndDelay():
	AttackEnded.emit()
