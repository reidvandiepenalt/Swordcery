extends "res://player/projectiles/player_projectile.gd"

@export var AIR_TIME := 5
@export var START_END_ANGLE_OFFSET := deg_to_rad(10)
@export var MAX_WIDTH := 2.0
@export var MAX_DISTANCE := 10.0
@export var STARTING_ROTATION := deg_to_rad(-90)

var max_distance := 0
var elapsed_time := 0.0
var total_angle := 0.0
var center_point := Vector3.ZERO

func _ready():
	total_angle = 2 * PI - 2 * START_END_ANGLE_OFFSET

func set_target(target):
	super.set_target(target)
	max_distance = min(global_position.distance_to(TARGET), MAX_DISTANCE)
	BASIS = make_rotation_basis((TARGET - global_position).normalized(), Vector3.UP)
	center_point = TARGET - (global_position / 2)

#start and returns from right left shoulder respectively then rejoins arc
func _physics_process(delta):
	elapsed_time += delta
	if(elapsed_time > AIR_TIME):
		destroy()
		return
		#replace with moving back to rack behind back
	
	var time_percent = elapsed_time / AIR_TIME
	var current_angle = STARTING_ROTATION + START_END_ANGLE_OFFSET + (time_percent * total_angle)
	#rotation.y = -current_angle / 2
	position = center_point +  Vector3(cos(current_angle) * MAX_WIDTH, 1 , sin(current_angle) * max_distance) * BASIS

func _on_Projectile_area_entered(area):
	pass

func _on_Projectile_body_entered(body):
	pass

func make_rotation_basis(direction: Vector3, axis: Vector3):
	var xaxis = axis.cross(direction)
	xaxis = xaxis.normalized()
	var yaxis = direction.cross(xaxis)
	yaxis = yaxis.normalized()
	return Basis(Vector3(xaxis.x, yaxis.x, direction.x), Vector3(xaxis.y, yaxis.y, direction.y), Vector3(xaxis.z, yaxis.z, direction.z))
