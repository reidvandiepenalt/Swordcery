extends State
class_name AerialWander

@export var enemy: EnemyBase
@export var squared_distance_to_reach_target := 1.0
@export var wander_range := 10.0

var home : Vector3
var target_position : Vector3

func Enter_State():
	Get_New_Home_Position()
	Get_New_Wander_Target()

func Exit_State():
	super.Exit_State()

func Update_State(_delta: float):
	super.Update_State(_delta)

func Physics_Update_State(_delta: float):
	if enemy:
		if (enemy.player.global_position - enemy.global_position).length()  < enemy.chase_range:
			Transitioned.emit(self, transitionState.name)
			return
		
		var current_location = enemy.global_transform.origin
		if(current_location.distance_squared_to(target_position) <= squared_distance_to_reach_target):
			Get_New_Wander_Target()
		
		var new_velocity = (target_position - current_location).normalized() * enemy.SPEED * 0.75 * enemy.speed_modifier
	
		enemy.velocity.x = move_toward(enemy.velocity.x, new_velocity.x, enemy.SPEED * enemy.speed_modifier)
		enemy.velocity.z = move_toward(enemy.velocity.z, new_velocity.z, enemy.SPEED * enemy.speed_modifier)
		enemy.velocity.y = move_toward(enemy.velocity.y, new_velocity.y, enemy.SPEED * enemy.speed_modifier)

func Get_New_Wander_Target():
	var random_radian1 = randf_range(0, TAU)
	var random_radian2 = randf_range(0, TAU)
	var random_dist = randf_range(0.25 * wander_range, wander_range)
	target_position = home + Vector3(cos(random_radian1), sin(random_radian2), sin(random_radian1)) * random_dist

func Get_New_Home_Position():
	home = enemy.global_position
