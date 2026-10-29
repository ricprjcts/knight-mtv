extends MovementComponent
class_name PlayerMovement

@export_category("Dash")
@export var dash_velocity := 200.0
@export var dash_duration := 0.3
@export var dash_gravity := 0.0
@export var dash_cooldown := 0.5
var dash_debounce := false
var dashing := false

@export_category("Attack")
@export var attack_damage := 1
@export var attack_duration := 0.5
@export var attack_cooldown := 0.5
var attack_debounce := false
var attacking := false

var dash := false
var attack := false

func can_dash() -> bool:
	if not dash_debounce and not attacking and not body.stunned:
		return true
	return false

func do_dash() -> bool:
	if dash and can_dash():
		return true
	return false

func start_dash_cooldown() -> void:
	dash_debounce = true
	
	var timer = get_tree().create_timer(dash_cooldown)
	timer.timeout.connect(func(): dash_debounce = false)

func can_attack() -> bool:
	if not attack_debounce and not dashing and not body.stunned:
		return true
	return false

func do_attack() -> bool:
	if attack and can_attack():
		return true
	return false

func start_attack_cooldown() -> void:
	attack_debounce = true
	
	var timer = get_tree().create_timer(attack_cooldown)
	timer.timeout.connect(func(): attack_debounce = false)
