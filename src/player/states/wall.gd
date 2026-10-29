extends BaseState

@export var wall_gravity := 0.25
@export var max_wall_gravity := 0.5
var wall_gravity_multi := 0.0

@export var wall_jump_velocity := 100.0
@export var leave_wall_delay := 0.5

@export var sprite_offset := 1.0

func enter() -> void:
	wall_gravity_multi = wall_gravity
	
	if body.is_facing_right():
		body.sprite.offset.x = -sprite_offset
	else:
		body.sprite.offset.x = sprite_offset
	
	body.velocity.x = 0.0
	body.velocity.y = 0.0
	body.can_flip = false

func exit() -> void:
	body.sprite.offset.x = 0.0
	body.can_flip = true

func physics_process(delta: float) -> void:
	body.velocity.y += (movement.gravity * wall_gravity_multi) * delta
	body.move_and_slide()
	
	wall_gravity_multi = minf(wall_gravity_multi + (wall_gravity_multi * delta), max_wall_gravity)
	
	if not body.is_on_wall():
		if body.is_on_floor():
			if not movement.is_moving():
				change_state.emit(states[body.states.idle])
			elif movement.is_moving():
				change_state.emit(states[body.states.move])
		else:
			change_state.emit(states[body.states.fall])
	
	elif movement.wants_wall_jump():
		_wall_jump()
		change_state.emit(states[body.states.jump])

func _wall_jump() -> void:
	if body.is_facing_right():
		body.velocity.x = -wall_jump_velocity
	else:
		body.velocity.x = wall_jump_velocity
	
	body.velocity.y = movement.jump_velocity
