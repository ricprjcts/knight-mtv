extends Node
class_name MovementComponent

@export_category("Body")
@export var body: CharacterBody2D

@export_category("Base Movement")
@export var speed := 100.0
@export var jump_velocity := -200.0
@export var gravity := 500.0

var direction := 0.0
var jump := false
var fall := false

func is_moving() -> bool:
	if direction != 0.0:
		return true
	return false

func wants_jump() -> bool:
	if body.is_on_floor() and jump:
		return true
	return false
