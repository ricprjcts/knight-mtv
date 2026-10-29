extends BTAction

var move_time = 0.0
var timer := 0.0

func _enter() -> void:
	move_time = randf_range(0.5, 3.0)

func _exit() -> void:
	timer = 0.0

func _tick(delta: float) -> Status:
	agent.stop(delta)
	
	if move_time != 0.0:
		timer += delta
		
		if timer >= move_time:
			return SUCCESS
	
	return RUNNING
