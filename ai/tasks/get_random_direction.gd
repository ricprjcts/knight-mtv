extends BTAction

var direction := 0.0

func _tick(delta: float) -> Status:
	if agent.is_at_ledge_or_wall():
		direction = -signf(agent.wall_ray.target_position.x)
		return SUCCESS
	else:
		direction = [-1.0, 1.0].pick_random()
		blackboard.set_var("direction", direction)
		return SUCCESS
	
	return RUNNING
