extends BaseState

@export var hitbox: Hitbox

func enter() -> void:
	var timer := get_tree().create_timer(movement.attack_duration)
	timer.timeout.connect(_on_attack_ended)
	
	movement.attacking = true
	body.can_flip = false
	hitbox.collision.disabled = false

func physics_process(delta: float) -> void:
	body.velocity.x = movement.direction * movement.speed
	body.velocity.y += movement.gravity * delta
	body.move_and_slide()
	
	if movement.fall and body.velocity.y < 0.0:
		body.velocity.y = 0.0

func _on_attack_ended() -> void:
	movement.attacking = false
	body.can_flip = true
	
	movement.start_attack_cooldown()
	hitbox.collision.set_deferred("disabled", true)
	
	if state_machine.active_state == self:
		if body.is_on_floor():
			if movement.is_moving():
				change_state.emit(states[body.states.move])
			elif not movement.is_moving():
				change_state.emit(states[body.states.idle])
		else:
			change_state.emit(states[body.states.fall])
