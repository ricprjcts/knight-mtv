extends Node
class_name HealthComponent

signal took_damage(amount: int)
signal died

@export var body: Node2D

@export var max_health := 5
var health := 0

var invincibility := false

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

func get_health() -> int:
	return health

func set_invincibility(duration: float) -> void:
	if not invincibility:
		invincibility = true
		var timer := get_tree().create_timer(duration)
		timer.timeout.connect(func():
			invincibility = false
			)

func get_invincibility() -> bool:
	return invincibility

func _emit() -> void:
	print("%s Health: %d / %d" % [body.name, health, max_health])
