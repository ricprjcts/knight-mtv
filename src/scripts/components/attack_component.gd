extends Node
class_name AttackComponent

@export var body: CharacterBody2D
@export var attack_damage := 1
@export var attack_duration := 0.5
@export var attack_cooldown := 0.5
var attack_debounce := false

var attack := false

func can_attack() -> bool:
	if not attack_debounce and not body.stunned:
		return true
	return false

func do_attack() -> bool:
	if attack and can_attack():
		return true
	return false

func start_cooldown() -> void:
	attack_debounce = true
	
	var timer = get_tree().create_timer(attack_cooldown)
	timer.timeout.connect(func(): attack_debounce = false)
