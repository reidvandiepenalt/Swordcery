extends "res://resources/entity_base.gd"
class_name EnemyBase

@export var chase_range := 20.0

@onready var nav_agent = $NavigationAgent3D
var player : SwordceryPlayer
#pass in from spawning director instead

const SPEED := 7.0

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	move_and_slide()


func update_target_location(target_location):
	nav_agent.target_position = target_location



func _on_navigation_agent_3d_target_reached():
	print("In range")
	#add attack in here
