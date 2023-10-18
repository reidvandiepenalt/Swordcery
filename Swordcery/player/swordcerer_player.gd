extends "res://scenes/player.gd"

@export var PROJECTILE : PackedScene = preload("res://player/projectiles/sub_path_swordcerer_basic_projectile.tscn")
@export var START_END_PERCENT := 0.05 #keep same as projectile script value

@onready var PROJ_PATH := $Knight/ProjectilePath

var projectiles = []
var cur_projectile := -1

func basic_attack(space_state):
	if PROJECTILE:
		cur_projectile += 1
		
		if (projectiles.size() < 8):
			var proj = PROJECTILE.instantiate()
			PROJ_PATH.add_child(proj)
			projectiles.append(proj.get_child(0))
		
		if(cur_projectile >= 8):
			cur_projectile = 0
		
		cam_raycast.force_raycast_update()
		if cam_raycast.is_colliding():
			projectiles[cur_projectile].set_target(cam_raycast.get_collision_point())
		else:
			projectiles[cur_projectile].set_target(cam_raycast.to_global(cam_raycast.target_position)) 
		
		basic_attack_timer.start()

func _physics_process(delta):
	super._physics_process(delta)
	update_basic_projectiles()

func update_basic_projectiles():
	PROJ_PATH.look_at(cam_raycast.to_global(cam_raycast.target_position), Vector3.UP, true)
	var inactive_projectiles = []
	if(projectiles.size() > 0):
		for n in range(cur_projectile - 1, -1, -1):
			if !projectiles[n].active:
				inactive_projectiles.append(projectiles[n])
		for n in range(projectiles.size() - 1, cur_projectile - 1, -1):
			if !projectiles[n].active:
				inactive_projectiles.append(projectiles[n])
		var percent_step = 2 * START_END_PERCENT / inactive_projectiles.size()
		for n in inactive_projectiles.size():
			inactive_projectiles[n].set_percent(-START_END_PERCENT + percent_step * n)
