extends SwordceryPlayer

@export var PROJECTILE : PackedScene = preload("res://player/projectiles/sub_path_swordcerer_basic_projectile.tscn")
@export var SECONDARY_PROJECTILE : PackedScene = preload("res://player/projectiles/swordcerer_secondary_attack.tscn")
@export var START_END_PERCENT := 0.05 #keep same as projectile script value
@export var DASH_DISTANCE := 15
@export var DASH_SPEED_MULT := 8
@export var BASIC_ATACK_DISTANCE : float = 18

@onready var BASIC_PROJ_PATH := $Knight/PathsParent/BasicProjectilePath
@onready var PATHS_PARENT := $Knight/PathsParent
@onready var SPECIAL_ATTACK_ANIMATOR := $Knight/PathsParent/SpecialAttackParent/SpecialAttackAnimator
@onready var MOVEMENT_PROJ_R : SwordcererMovementProj = $Knight/SwordcererMovementProjectileRight
@onready var MOVEMENT_PROJ_L : SwordcererMovementProj = $Knight/SwordcererMovementProjectileLeft
@onready var NAV_AGENT : NavigationAgent3D = $NavigationAgent3D

var projectiles = []
var cur_projectile := -1
var is_dashing := false
var dash_direction := DashDirection.forward
var dash_target := Vector3.ZERO
var dash_acceleration_magnitude = pow(SPEED * DASH_SPEED_MULT, 2) / DASH_DISTANCE
var dash_hypotenuse = sqrt(pow(DASH_DISTANCE, 2) + pow(DASH_DISTANCE, 2))
var cam_raycast_length : float
var do_reset_position := false
var position_to_set := Vector3(0, 0, 0)

enum DashDirection{
	left,
	right,
	forward
}

func _ready():
	super._ready()
	cam_raycast_length = cam_raycast.target_position.length()

func _physics_process(delta):
	if do_reset_position:
		reset()
	
	if is_dashing:
		var position_difference = dash_target - global_position
		if abs(position_difference.x) < 1 and abs(position_difference.z) < 1:
			global_position.x = dash_target.x
			global_position.z = dash_target.z
			velocity.y = 0
			if dash_direction == DashDirection.right:
				MOVEMENT_PROJ_L.toggle_collision(false)
			else:
				MOVEMENT_PROJ_R.toggle_collision(false)
			is_dashing = false
			lock_cam = false
		elif (movement_skill_timer.wait_time - movement_skill_timer.time_left) > 0.35:
			velocity.y = 0
			if dash_direction == DashDirection.right:
				MOVEMENT_PROJ_L.toggle_collision(false)
			else:
				MOVEMENT_PROJ_R.toggle_collision(false)
			is_dashing = false
			lock_cam = false
		else:
			match dash_direction:
				DashDirection.forward:
					var direction = (dash_target - global_position).normalized()
					velocity.x = direction.x * SPEED * DASH_SPEED_MULT * 1.5
					velocity.z = direction.z * SPEED * DASH_SPEED_MULT * 1.5
					velocity.y = direction.y * SPEED * DASH_SPEED_MULT * 1.5
					#twist_pivot.look_at(twist_pivot.global_position + Vector3(velocity.x, 0, velocity.z), Vector3.UP)
					PLAYER_MODEL.rotation.y = twist_pivot.rotation.y + PI
				DashDirection.right:
					var accel = calc_dash_acceleration(false)
					velocity.x += accel.x * delta
					velocity.z += accel.z * delta
					velocity.y += accel.y * delta
					twist_pivot.look_at(twist_pivot.global_position + Vector3(velocity.x, 0, velocity.z), Vector3.UP)
					PLAYER_MODEL.rotation.y = twist_pivot.rotation.y + PI
				DashDirection.left:
					var accel = calc_dash_acceleration(true)
					velocity.x += accel.x * delta
					velocity.z += accel.z * delta
					velocity.y += accel.y * delta
					twist_pivot.look_at(twist_pivot.global_position + Vector3(velocity.x, 0, velocity.z), Vector3.UP)
					PLAYER_MODEL.rotation.y = twist_pivot.rotation.y + PI
			move_and_slide()
	else:
		super._physics_process(delta)
	
	update_basic_projectiles()

func _process(delta):
	super._process(delta)
	if Input.is_action_pressed("attack_basic") and basic_attack_timer.is_stopped():
		basic_attack(get_world_3d().direct_space_state)

func update_basic_projectiles():
	PATHS_PARENT.look_at(cam_raycast.to_global(cam_raycast.target_position * (BASIC_ATACK_DISTANCE / cam_raycast_length)), Vector3.UP, true)
	var inactive_projectiles = []
	if(projectiles.size() > 0):
		for n in range(cur_projectile - 1, -1, -1):
			if !projectiles[n].active:
				inactive_projectiles.append(projectiles[n])
		for n in range(projectiles.size() - 1, cur_projectile - 1, -1):
			if !projectiles[n].active:
				inactive_projectiles.append(projectiles[n])
		var size = inactive_projectiles.size()
		if size == 1:
			inactive_projectiles[0].set_percent(0)
		else:
			for n in size:
				inactive_projectiles[n].set_percent(lerpf(-START_END_PERCENT, START_END_PERCENT, float(n) / (size - 1)))

func basic_attack(space_state):
	if PROJECTILE:
		cur_projectile += 1
		
		if (projectiles.size() < 8):
			var proj = PROJECTILE.instantiate()
			BASIC_PROJ_PATH.add_child(proj)
			var script_node = proj.get_child(0)
			projectiles.append(script_node)
			script_node.player = self
		
		if(cur_projectile >= 8):
			cur_projectile = 0
		
		projectiles[cur_projectile].set_active()
		
		basic_attack_timer.start()

func secondary_attack():
	if SECONDARY_PROJECTILE:
		var proj = SECONDARY_PROJECTILE.instantiate()
		get_tree().root.get_child(0).add_child(proj)
		proj.set_player(self)
		cam_raycast.force_raycast_update()
		if cam_raycast.is_colliding():
			proj.set_target(cam_raycast.get_collision_point())
		else:
			proj.set_target(cam_raycast.to_global(cam_raycast.target_position)) 
		
		secondary_attack_timer.start()

func special_attack():
	SPECIAL_ATTACK_ANIMATOR.play("swordcerer_special_attack")
	special_attack_timer.start()

func movement_skill():
	is_dashing = true
	lock_cam = true
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (twist_pivot.basis * Vector3(0, 0, -1)).normalized()
	var cam_target = cam_raycast.to_global(cam_raycast.target_position)
	if abs(input_dir.x) > 0 and abs(input_dir.x) >= abs(input_dir.y):
		if input_dir.x < 0:
			dash_direction = DashDirection.left
			#set initial veloctiy
			var y_component = cam_target.normalized().y
			velocity.x = direction.x * SPEED * DASH_SPEED_MULT
			velocity.z = direction.z * SPEED * DASH_SPEED_MULT
			velocity.y = y_component * SPEED * DASH_SPEED_MULT
			#calc target
			dash_target = global_position + (twist_pivot.basis * Vector3(-1, y_component, -1)).normalized() * dash_hypotenuse
			MOVEMENT_PROJ_R.toggle_collision(true)
		else:
			dash_direction = DashDirection.right
			#set initial velocity
			var y_component = cam_target.normalized().y
			velocity.x = direction.x * SPEED * DASH_SPEED_MULT
			velocity.z = direction.z * SPEED * DASH_SPEED_MULT
			velocity.y = y_component * SPEED * DASH_SPEED_MULT
			#calc target
			dash_target = global_position + (twist_pivot.basis * Vector3(1, y_component, -1)).normalized() * dash_hypotenuse
			MOVEMENT_PROJ_L.toggle_collision(true)
	else:
		dash_direction = DashDirection.forward
		dash_target = global_position + (cam_target - global_position).normalized() * DASH_DISTANCE * 1.5
		MOVEMENT_PROJ_R.toggle_collision(true)
	
	movement_skill_timer.start()

func calc_dash_acceleration(left: bool):
	if left:
		return Vector3(velocity.z, velocity.y, -velocity.x).normalized() * dash_acceleration_magnitude
	else:
		return Vector3(-velocity.z, velocity.y, velocity.x).normalized() * dash_acceleration_magnitude

func reset_location(location: Vector3):
	do_reset_position = true
	position_to_set = location

func reset():
	do_reset_position = false
	global_position = position_to_set
	velocity = Vector3(0, 0, 0)
