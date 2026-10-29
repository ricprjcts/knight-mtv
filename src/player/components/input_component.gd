extends Node
class_name InputComponent

var direction := 0.0
var jump_pressed := false
var jump_released := false

var attack_pressed := false

func update() -> void:
	direction = Input.get_axis("move_left", "move_right")
	jump_pressed = Input.is_action_just_pressed("action_jump")
	jump_released = Input.is_action_just_released("action_jump")
	attack_pressed = Input.is_action_just_pressed("action_attack")
