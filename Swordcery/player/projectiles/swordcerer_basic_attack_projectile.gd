extends "res://player/projectiles/player_projectile.gd"

@export var AIR_TIME := 0.6
@export var START_END_ANGLE_OFFSET := deg_to_rad(10)
@export var MAX_WIDTH := 2.0
@export var MAX_DISTANCE := 10.0

var max_distance := 0
var elapsed_time := 0.0
var y_angle := 0.0

func set_target(target):
	super.set_target(target)
	max_distance = min(global_position.distance_to(TARGET), MAX_DISTANCE)
	y_angle = Vector3(TARGET.x, global_position.y, TARGET.z).angle_to(TARGET)
	if(global_position.y > target.y):
		y_angle *= -1

#start and returns from right left shoulder respectively then rejoins arc
func _physics_process(delta):
	elapsed_time += delta
	if(elapsed_time > AIR_TIME):
		destroy()
		return
		#replace with moving back to rack behind back
	
	#need to align with plane of direction
	#add 1 to y to account for player center offset (get real value later)
	var current_angle = START_END_ANGLE_OFFSET + ((elapsed_time / AIR_TIME) * 2 *(PI - START_END_ANGLE_OFFSET))
	position = Vector3(cos(current_angle) * MAX_WIDTH, 1 , sin(current_angle) * max_distance)

func _on_Projectile_area_entered(area):
	pass

func _on_Projectile_body_entered(body):
	pass
