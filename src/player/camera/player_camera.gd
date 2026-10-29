extends Camera2D
class_name PlayerCamera

var target: Node2D

func _process(delta: float) -> void:
	global_position = target.global_position
