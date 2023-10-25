extends Control

@onready var health_bar := $AspectRatioContainer/VBoxContainer/MarginContainer2/HealthBar
@onready var basic_attack_icon := $AspectRatioContainer/VBoxContainer/MarginContainer/SkillsGridContainer/MarginContainer/BasicAttack
@onready var secondary_attack_icon := $AspectRatioContainer/VBoxContainer/MarginContainer/SkillsGridContainer/MarginContainer2/SecondaryAttack
@onready var movement_attack_icon := $AspectRatioContainer/VBoxContainer/MarginContainer/SkillsGridContainer/MarginContainer3/MovementAttack
@onready var special_attack_icon := $AspectRatioContainer/VBoxContainer/MarginContainer/SkillsGridContainer/MarginContainer4/SpecialAttack

func set_new_health_value(new_health: int):
	pass

func set_new_max_health_value(new_max_health: int):
	pass

func set_new_basic_attack_value(new_time: float):
	pass

func set_new_basic_attack_max_value(new_max_time: float):
	pass

func set_new_secondary_attack_value(new_time: float):
	pass

func set_new_secondary_attack_max_value(new_max_time: float):
	pass

func set_new_movement_attack_value(new_time: float):
	pass

func set_new_movement_attack_max_value(new_max_time: float):
	pass

func set_new_special_attack_value(new_time: float):
	pass

func set_new_special_attack_max_value(new_max_time: float):
	pass
