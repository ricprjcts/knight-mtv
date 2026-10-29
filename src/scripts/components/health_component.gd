extends Node
class_name HealthComponent

signal took_damage(amount: int)
signal died

@export var body: Node2D

@export var max_health := 5
var health := 0

func _ready() -> void:
	health = max_health
	_emit()

func take_damage(amount: int) -> void:
	var new_health := clampi(health - amount, 0, max_health)
	health = new_health
	
	if health <= 0:
		died.emit()
		return
	
	took_damage.emit(amount)
	_emit()

func _emit() -> void:
	print("%s Health: %d / %d" % [body.name, health, max_health])
