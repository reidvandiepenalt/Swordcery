extends Node3D
class_name Level

@onready var nav_region = $NavigationRegion3D

@export var RESET_Y_LEVEL = -70

var player : SwordceryPlayer
var nav_mesh : NavigationMesh
var thread: Thread

func _ready():
	randomize()
	player = get_tree().get_first_node_in_group("Player")
	nav_mesh = nav_region.navigation_mesh

func _physics_process(delta):
	if player.global_transform.origin.y < RESET_Y_LEVEL:
		set_player_to_closest_nav_vert()

func set_player_to_closest_nav_vert():
	var initial_player_pos: Vector3 = player.global_transform.origin
	var closest_vert: Vector3 = nav_mesh.get_vertices()[0]
	var smallest_distance = initial_player_pos.distance_to(closest_vert)
	for vert in nav_mesh.get_vertices():
		var distance = initial_player_pos.distance_to(vert)
		if(distance < smallest_distance):
			smallest_distance = distance
			closest_vert = vert
	player.reset_location(closest_vert - Vector3(0, nav_mesh.cell_height, 0))
