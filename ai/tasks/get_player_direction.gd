extends BTAction

var direction: float
var player: Player

func _enter() -> void:
	player = blackboard.get_var("player")
	direction = -1.0 if player.global_position.x - agent.global_position.x < 0.0 else 1.0
	blackboard.set_var("direction", direction)

func _tick(delta: float) -> Status:
	if player and direction != 0.0:
		return SUCCESS
	
	return RUNNING
