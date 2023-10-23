extends "res://player/projectiles/player_projectile.gd"

@export var AIR_TIME := 0.5
@export var START_END_PERCENT := 0.1
@export var MAX_WIDTH := 2.0

@onready var path : PathFollow3D = get_parent()

var max_distance := 0
var elapsed_time := 0.0
var active = false


func set_active():
	elapsed_time = 0
	active = true
	rotation = Vector3(0, -90, 0)

#start and returns from right left shoulder respectively then rejoins arc
func _physics_process(delta):
	if !active:
		look_at(global_position + Vector3.UP, Vector3.FORWARD)
		return
	
	elapsed_time += delta
	if(elapsed_time > AIR_TIME):
		active = false
		return
	
	var time_percent = elapsed_time / AIR_TIME
	var current_progress = START_END_PERCENT + ((1 - (2 * START_END_PERCENT)) * time_percent)
	path.progress_ratio = current_progress

func _on_Projectile_area_entered(area):
	pass

func _on_Projectile_body_entered(body):
	pass

func set_percent(percent):
	path.progress_ratio = percent
