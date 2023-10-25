extends Timer

class_name SkillTimer

signal max_time_updated(new_max_time: float)
signal current_time_updated(time_left: float)

var stopped := false

func on_ui_ready():
	max_time_updated.emit(wait_time)

func set_max_time(new_max_time: float):
	wait_time = max(0.00001, new_max_time)
	max_time_updated.emit(wait_time)

func _process(delta):
	if !is_stopped():
		stopped = true
		current_time_updated.emit(time_left)
	else: if stopped:
		stopped = false
		current_time_updated.emit(0)
