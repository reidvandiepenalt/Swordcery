extends CharacterBody3D

class_name EntityBase

@export var hp_max := 40
@export var hp := hp_max

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _on_hurtbox_area_entered(hitbox):
	var damage = hitbox.damage
	hp -= damage
	if hp < 0:
		hp = 0
	print(hitbox.get_parent().name + " hitbox touched " + name + " hurtbox and dealt " + str(damage))
