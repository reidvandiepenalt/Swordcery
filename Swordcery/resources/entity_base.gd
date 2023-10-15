extends CharacterBody3D

@export var hp_max := 40
@export var hp := hp_max

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _on_hurtbox_area_entered(hitbox):
	var damage = hitbox.damage
	self.hp -= damage
	print(hitbox.get_parent().name + " hitbox touched " + name + " hurtbox and dealt " + str(damage))
