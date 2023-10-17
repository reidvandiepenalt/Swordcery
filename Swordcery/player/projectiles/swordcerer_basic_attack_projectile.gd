extends "res://player/projectiles/player_projectile.gd"

@export var AIR_TIME := 0.5
@export var START_END_PERCENT := 10
@export var MAX_WIDTH := 2.0
@export var MAX_DISTANCE := 10.0

@onready var path : PathFollow3D = get_parent()

var max_distance := 0
var elapsed_time := 0.0


func set_target(target):
	super.set_target(target)
	max_distance = min(global_position.distance_to(TARGET), MAX_DISTANCE)
	elapsed_time = 0

#start and returns from right left shoulder respectively then rejoins arc
func _physics_process(delta):
	elapsed_time += delta
	if(elapsed_time > AIR_TIME):
		return
		#replace with moving back to rack behind back
	
	var time_percent = elapsed_time / AIR_TIME
	var current_progress = START_END_PERCENT / 100 + (time_percent * (1 - 2 * START_END_PERCENT / 100))
	path.progress_ratio = current_progress

func _on_Projectile_area_entered(area):
	pass

func _on_Projectile_body_entered(body):
	pass
