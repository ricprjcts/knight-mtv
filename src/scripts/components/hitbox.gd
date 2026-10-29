extends Area2D
class_name Hitbox

@export var body: CharacterBody2D
@export var collision: CollisionShape2D

@export var damage := 1
@export var knockback_force := Vector2(100.0, -150.0)

func _ready() -> void:
	_set_collision()

func _set_collision() -> void:
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
	set_collision_layer_value(3, true)
