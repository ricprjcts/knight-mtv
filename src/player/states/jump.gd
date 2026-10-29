extends BaseState

@export var movement: MovementComponent
@export var attack: AttackComponent

func enter() -> void:
	body.velocity.y = movement.jump_velocity

func physics_process(delta: float) -> void:
	body.velocity.x = movement.direction * movement.speed
	body.velocity.y += movement.gravity * delta
	body.move_and_slide()
	
	if body.velocity.y > 10.0:
		change_state.emit(states[body.states.fall])
	
	elif movement.fall:
		body.velocity.y = 0.0
		change_state.emit(states[body.states.fall])
	
	elif attack.do_attack():
		change_state.emit(states[body.states.attack])
