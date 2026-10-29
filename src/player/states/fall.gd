extends BaseState

@export var movement: MovementComponent
@export var attack: AttackComponent

func physics_process(delta: float) -> void:
	body.velocity.x = movement.direction * movement.speed
	body.velocity.y += movement.gravity * delta
	body.move_and_slide()
	
	if body.is_on_floor():
		if not movement.is_moving():
			change_state.emit(states[body.states.idle])
		elif movement.is_moving():
			change_state.emit(states[body.states.move])
	
	elif attack.do_attack():
		change_state.emit(states[body.states.attack])
