extends BaseState

func physics_process(delta: float) -> void:
	body.velocity.x = movement.direction * movement.speed
	body.velocity.y += movement.gravity * delta
	body.move_and_slide()
	
	if body.is_on_floor():
		if not movement.is_moving():
			change_state.emit(states[body.states.idle])
		elif movement.is_moving():
			change_state.emit(states[body.states.move])
	
	elif movement.do_dash():
		change_state.emit(states[body.states.dash])
	
	elif movement.do_attack():
		change_state.emit(states[body.states.attack])
	
	elif body.can_wall_grab():
		change_state.emit(states[body.states.wall])
