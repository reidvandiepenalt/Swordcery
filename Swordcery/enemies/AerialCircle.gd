extends State
class_name AerialCircle

@export var enemy: EnemyBase
@export var outer_radius := 12.5
@export var inner_radius := 7.5
@export var squared_distance_to_reach_target := 1.0

var circling := false
var target_position : Vector3

func Enter_State():
	super.Enter_State()

func Exit_State():
	super.Exit_State()

func Update_State(_delta: float):
	super.Update_State(_delta)

func Physics_Update_State(_delta: float):
	if enemy:
		var xyDistToPlayer = Vector2(enemy.global_position.x, enemy.global_position.x).distance_to(Vector2(enemy.player.global_position.x, enemy.player.global_position.z))
		if xyDistToPlayer > enemy.chase_range:
			Transitioned.emit(self, transitionState.name)
			return
		
		if xyDistToPlayer <= outer_radius:
			if circling:
				if enemy.global_position.distance_squared_to(target_position) <= squared_distance_to_reach_target:
					GetNewCirclePoint()
			else:
				GetNewCirclePoint()
				circling = true
		else:
			circling = false
			target_position = enemy.player.global_position + Vector3.UP * AerialWander.AERIAL_HEIGHT
		
		var new_velocity = (target_position - enemy.global_position).normalized() * enemy.SPEED * enemy.speed_modifier
	
		enemy.velocity.x = move_toward(enemy.velocity.x, new_velocity.x, enemy.SPEED * enemy.speed_modifier)
		enemy.velocity.y = move_toward(enemy.velocity.y, new_velocity.y, enemy.SPEED * enemy.speed_modifier)
		enemy.velocity.z = move_toward(enemy.velocity.z, new_velocity.z, enemy.SPEED * enemy.speed_modifier)

func GetNewCirclePoint():
	var angle_from_player = Vector2(enemy.player.global_position.x, enemy.player.global_position.z).angle_to(Vector2(enemy.global_position.x, enemy.global_position.z))
	var rand_angle = randf_range(0, TAU)
	var circle_radius = randf_range(inner_radius, outer_radius)
	var circle_offset = Vector3(cos(angle_from_player + rand_angle), AerialWander.AERIAL_HEIGHT, sin(angle_from_player + rand_angle)) * circle_radius
	target_position = enemy.player.global_position + circle_offset
