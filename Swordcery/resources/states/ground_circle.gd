extends State
class_name GroundCircle

@export var enemy: EnemyBase
@export var circle_radius := 15.0
@export var circle_degree_range := 15

var circling := false

func Enter_State():
	super.Enter_State()

func Exit_State():
	super.Exit_State()

func Update_State(_delta: float):
	super.Update_State(_delta)

func Physics_Update_State(_delta: float):
	if enemy:
		if enemy.dist_to_player > enemy.chase_range:
			Transitioned.emit(self, transitionState)
			return
		
		if enemy.dist_to_player <= circle_radius:
			if circling:
				if enemy.nav_agent.is_navigation_finished():
					GetNewCirclePoint()
			else:
				GetNewCirclePoint()
				circling = true
		else:
			circling = false
			enemy.update_target_location(enemy.player.global_position)
		
		var current_location = enemy.global_position
		var next_location = enemy.nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * enemy.SPEED
	
		enemy.velocity.x = move_toward(enemy.velocity.x, new_velocity.x, enemy.SPEED)
		enemy.velocity.z = move_toward(enemy.velocity.z, new_velocity.z, enemy.SPEED)

func GetNewCirclePoint():
	var angle_from_player = Vector2(enemy.player.global_position.x, enemy.player.global_position.z).angle_to(Vector2(enemy.global_position.x, enemy.global_position.z))
	var rand_deg = randf_range(-circle_degree_range, circle_degree_range)
	var circle_offset = Vector3(cos(deg_to_rad(angle_from_player + rand_deg)), 0, sin(deg_to_rad(angle_from_player + rand_deg))) * circle_radius
	enemy.update_target_location(enemy.player.global_position + circle_offset)
