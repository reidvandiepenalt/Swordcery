extends "res://resources/entity_base.gd"
class_name EnemyBase

@export var chase_range := 20.0

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

var player : SwordceryPlayer
#pass in from spawning director instead
var dist_to_player = 20.0

const SPEED := 5.0
var speed_modifier := 1.0

var rot_lock := false

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	dist_to_player = (player.global_position - global_position).length()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if !rot_lock && (velocity.x > 0 or velocity.z > 0):
		look_at(global_position + Vector3(velocity.x, 0, velocity.z), Vector3.UP, true)
	
	move_and_slide()


func update_target_location(target_location):
	nav_agent.target_position = target_location

func toggle_rotation_lock(_lock_rotation: bool):
	rot_lock = _lock_rotation

func set_speed_modifier(_s_mod: float):
	speed_modifier = maxf(0, _s_mod)
