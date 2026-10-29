extends BaseState

@export var movement: MovementComponent
@export var attack: AttackComponent

func physics_process(delta: float) -> void:
	body.velocity.x = 0.0
	body.velocity.y += movement.gravity * delta
	body.move_and_slide()
	
	if movement.is_moving():
		change_state.emit(states[body.states.move])
	
	elif movement.wants_jump():
		change_state.emit(states[body.states.jump])
	
	elif attack.do_attack():
		change_state.emit(states[body.states.attack])
	
	elif not body.is_on_floor():
		change_state.emit(states[body.states.fall])
