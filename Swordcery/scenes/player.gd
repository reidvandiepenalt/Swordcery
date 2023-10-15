extends CharacterBody3D

@export var hp_max := 40
@export var hp := hp_max

@export var PROJECTILE : PackedScene = preload("res://player/projectiles/player_projectile.tscn")

var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0

@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot

@onready var basic_attack_timer := $BasicAttackTimer

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

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
	
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, 
	deg_to_rad(-30), 
	deg_to_rad(30))
	twist_input = 0.0
	pitch_input = 0.0
	#rotate character model
	$Knight.rotation.y = twist_pivot.rotation.y + PI
	
	if Input.is_action_just_pressed("attack_basic") and basic_attack_timer.is_stopped():
		basic_attack()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity

func _on_hurtbox_area_entered(hitbox):
	var damage = hitbox.damage
	self.hp -= damage
	print(hitbox.get_parent().name + " hitbox touched " + name + " hurtbox and dealt " + str(damage))

func basic_attack():
	if PROJECTILE:
		var proj = PROJECTILE.instantiate()
		get_tree().current_scene.add_child(proj)
		proj.global_position = self.global_position
		
		proj.TARGET = self.global_position + self.basis.z * 10
		basic_attack_timer.start()
