extends BTAction

var direction := 0.0
var move_time = 0.0
var timer := 0.0

func _enter() -> void:
	move_time = randf_range(0.5, 3.0)

func _exit() -> void:
	timer = 0.0

func _tick(delta: float) -> Status:
	direction = blackboard.get_var("direction")
	if agent.is_at_ledge_or_wall():
		direction = -signf(agent.wall_ray.target_position.x)
		blackboard.set_var("direction", direction)
	
	if direction:
		agent.move(delta, direction)
	
	if move_time != 0.0:
		timer += delta
		
		if timer >= move_time:
			return SUCCESS
	
	return RUNNING
