extends "res://player/projectiles/player_projectile.gd"

@export var PLAYER : Node3D
@export var HANG_TIME := 1.5
@export var ROTATION_RATE_DPS := 12 * PI

var reached_target := false
var current_hang_time := 0.0

func set_player(player_transform:  Node3D):
	PLAYER = player_transform

func _physics_process(delta):
	if !reached_target and global_position.distance_squared_to(TARGET) < 2:
		reached_target = true
		rotation = Vector3(0, 0, 0)
	
	if reached_target:
		if current_hang_time <= HANG_TIME:
			current_hang_time += delta
			rotate_y(ROTATION_RATE_DPS * delta)
		else:
			if global_position.distance_squared_to(PLAYER.global_position) < 6:
				destroy()
			else:
				look_at(PLAYER.global_position, Vector3.UP)
				global_position -= SPEED * self.basis.z * delta
	else:
		super._physics_process(delta)
