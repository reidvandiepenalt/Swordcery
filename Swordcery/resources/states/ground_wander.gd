extends State
class_name GroundWander

@export var enemy: EnemyBase

var level : Level
var set_first_node = false

func Enter_State():
	level = get_tree().get_first_node_in_group("Level")

func Exit_State():
	super.Exit_State()

func Update_State(_delta: float):
	if !set_first_node:
		set_first_node = true
		Get_New_Wander_Node()

func Physics_Update_State(_delta: float):
	if enemy:
		if (enemy.player.global_position - enemy.global_position).length()  < enemy.chase_range:
			Transitioned.emit(self, transitionState.name)
			return

		var current_location = enemy.global_transform.origin
		var next_location = enemy.nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * enemy.SPEED * 0.75
	
		enemy.velocity.x = move_toward(enemy.velocity.x, new_velocity.x, enemy.SPEED)
		enemy.velocity.z = move_toward(enemy.velocity.z, new_velocity.z, enemy.SPEED)

func Get_New_Wander_Node():
	var random_index = randi()%level.nav_mesh.get_vertices().size()
	enemy.update_target_location(level.nav_mesh.get_vertices()[random_index])

func _on_navigation_agent_3d_navigation_finished():
	Get_New_Wander_Node()
