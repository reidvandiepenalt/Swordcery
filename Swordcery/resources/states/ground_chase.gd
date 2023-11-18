extends State
class_name GroundChase

@export var enemy: EnemyBase

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
		
		enemy.update_target_location(enemy.player.global_transform.origin)
		var current_location = enemy.global_transform.origin
		var next_location = enemy.nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * enemy.SPEED
	
		enemy.velocity.x = move_toward(enemy.velocity.x, new_velocity.x, enemy.SPEED)
		enemy.velocity.z = move_toward(enemy.velocity.z, new_velocity.z, enemy.SPEED)
