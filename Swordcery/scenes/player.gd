class_name SwordceryPlayer extends EntityBase

@export var TEST_SPHERE : PackedScene = preload("res://resources/test_sphere.tscn")

signal health_updated(new_health: int)
signal died
signal max_health_updated(new_max_health: int)

var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0
var lock_cam := false

@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot
@onready var cam_raycast := $TwistPivot/PitchPivot/Camera3D/CameraRaycast
@onready var PLAYER_MODEL := $Knight

@onready var basic_attack_timer := $BasicAttackTimer
@onready var secondary_attack_timer := $SecondaryAttackTimer
@onready var movement_skill_timer := $MovementSkillTimer
@onready var special_attack_timer := $SpecialAttackTimer

const SPEED = 9.0
const JUMP_VELOCITY = 7.5

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (twist_pivot.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if !lock_cam:
		twist_pivot.rotate_y(twist_input)
		pitch_pivot.rotate_x(pitch_input)
		pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, 
		deg_to_rad(-60), 
		deg_to_rad(60))
		twist_input = 0.0
		pitch_input = 0.0
		#rotate character model
		PLAYER_MODEL.rotation.y = twist_pivot.rotation.y + PI
	
	if Input.is_action_just_pressed("attack_basic") and basic_attack_timer.is_stopped():
		basic_attack(get_world_3d().direct_space_state)
	
	if Input.is_action_pressed("attack_secondary") and secondary_attack_timer.is_stopped():
		secondary_attack()
	
	if Input.is_action_pressed("attack_movement") and movement_skill_timer.is_stopped():
		movement_skill()
	
	if Input.is_action_pressed("attack_special") and special_attack_timer.is_stopped():
		special_attack()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity

func basic_attack(space_state):
	#save this code for other character type; fires a straight projectile
	"""
	if PROJECTILE:
		var proj = PROJECTILE.instantiate()
		get_tree().current_scene.add_child(proj)
		proj.global_position = self.global_position
		
		cam_raycast.force_raycast_update()
		if cam_raycast.is_colliding():
			proj.set_target(cam_raycast.get_collision_point())
		else:
			proj.set_target(cam_raycast.to_global(cam_raycast.target_position))
		
		basic_attack_timer.start()
	"""

func secondary_attack():
	#override in child
	pass

func movement_skill():
	#override in child
	pass

func special_attack():
	#override in child
	pass

func _on_hurtbox_area_entered(hitbox):
	super._on_hurtbox_area_entered(hitbox)
	if(hp < 0):
		died.emit()
	else:
		health_updated.emit(hp)

func on_ui_ready():
	health_updated.emit(hp)
	max_health_updated.emit(hp_max)
