extends BaseState

func enter() -> void:
	movement.dashing = true
	body.can_flip = false
	
	var timer := get_tree().create_timer(movement.dash_duration)
	timer.timeout.connect(_on_dash_ended)
	
	if body.facing_right:
		body.velocity.x = movement.dash_velocity
	elif not body.facing_right:
		body.velocity.x = -movement.dash_velocity

func physics_process(delta: float) -> void:
	body.velocity.y = movement.dash_gravity
	body.move_and_slide()

func _on_dash_ended() -> void:
	movement.dashing = false
	body.can_flip = true
	
	movement.start_dash_cooldown()
	
	if state_machine.active_state == self:
		if body.is_on_floor():
			if movement.is_moving():
				change_state.emit(states[body.states.move])
			elif not movement.is_moving():
				change_state.emit(states[body.states.idle])
		else:
			change_state.emit(states[body.states.fall])
