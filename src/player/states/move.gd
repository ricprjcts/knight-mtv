extends BaseState

@export var coyote_jump := 0.2
var coyote_jump_counter := 0.0

func physics_process(delta: float) -> void:
	body.velocity.x = movement.direction * movement.speed
	body.velocity.y += movement.gravity * delta
	body.move_and_slide()
	
	if not movement.is_moving():
		change_state.emit(states[body.states.idle])
	
	elif movement.wants_jump():
		change_state.emit(states[body.states.jump])
	
	elif movement.do_dash():
		change_state.emit(states[body.states.dash])
	
	elif movement.do_attack():
		change_state.emit(states[body.states.attack])
	
	elif not body.is_on_floor():
		_check_coyote_jump(delta)

func _check_coyote_jump(delta: float) -> void:
	coyote_jump_counter += delta
	if movement.jump and coyote_jump_counter < coyote_jump:
		coyote_jump_counter = 0.0
		change_state.emit(states[body.states.jump])
	elif coyote_jump_counter >= coyote_jump:
		coyote_jump_counter = 0.0
		change_state.emit(states[body.states.fall])
