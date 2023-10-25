extends Control

@onready var health_bar := $AspectRatioContainer/VBoxContainer/MarginContainer2/HealthBar
@onready var basic_attack_icon := $AspectRatioContainer/VBoxContainer/MarginContainer/SkillsGridContainer/MarginContainer/BasicAttack
@onready var secondary_attack_icon := $AspectRatioContainer/VBoxContainer/MarginContainer/SkillsGridContainer/MarginContainer2/SecondaryAttack
@onready var movement_attack_icon := $AspectRatioContainer/VBoxContainer/MarginContainer/SkillsGridContainer/MarginContainer3/MovementAttack
@onready var special_attack_icon := $AspectRatioContainer/VBoxContainer/MarginContainer/SkillsGridContainer/MarginContainer4/SpecialAttack

func set_new_health_value(new_health: int):
	health_bar.value = new_health

func set_new_max_health_value(new_max_health: int):
	health_bar.max_value = new_max_health

func set_new_basic_attack_value(new_time: float):
	basic_attack_icon.value = new_time

func set_new_basic_attack_max_value(new_max_time: float):
	basic_attack_icon.max_value = new_max_time

func set_new_secondary_attack_value(new_time: float):
	secondary_attack_icon.value = new_time

func set_new_secondary_attack_max_value(new_max_time: float):
	secondary_attack_icon.max_value = new_max_time

func set_new_movement_attack_value(new_time: float):
	movement_attack_icon.value = new_time

func set_new_movement_attack_max_value(new_max_time: float):
	movement_attack_icon.max_value = new_max_time

func set_new_special_attack_value(new_time: float):
	special_attack_icon.value = new_time

func set_new_special_attack_max_value(new_max_time: float):
	special_attack_icon.max_value = new_max_time
