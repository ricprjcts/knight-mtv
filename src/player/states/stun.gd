extends BaseState

@export var stun_time := 0.5

func enter() -> void:
	var timer := get_tree().create_timer(stun_time)
	timer.timeout.connect(_on_stun_ended)
	
	body.stunned = true
	movement.direction = 0.0

func physics_process(delta: float) -> void:
	body.velocity.y += movement.gravity * delta
	body.move_and_slide()

func _on_stun_ended() -> void:
	body.stunned = false
	
	if state_machine.active_state == self:
		if body.is_on_floor():
			if movement.is_moving():
				change_state.emit(states[body.states.move])
			elif not movement.is_moving():
				change_state.emit(states[body.states.idle])
		else:
			change_state.emit(states[body.states.fall])
