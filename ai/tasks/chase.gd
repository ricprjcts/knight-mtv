extends BTAction

var direction := 0.0

var player: Player

func _enter() -> void:
	player = blackboard.get_var("player")

func _tick(delta: float) -> Status:
	direction = blackboard.get_var("direction")
	if agent.is_at_wall():
		return FAILURE
	
	if direction:
		agent.move(delta, direction)
		
	if (absf(player.global_position.x - agent.global_position.x) < 12.0):
		return FAILURE
	
	if player.global_position.y < agent.global_position.y and (absf(player.global_position.x - agent.global_position.x) < 8.0):
		return FAILURE
	
	if not agent.check_player_distance():
		return FAILURE
	
	return RUNNING
