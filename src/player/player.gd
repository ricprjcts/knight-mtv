extends CharacterBody2D
class_name Player

@export var state_machine: StateMachine

@export var input: InputComponent
@export var health: HealthComponent
@export var movement: PlayerMovement

@export var hitbox: Hitbox

@onready var sprite: AnimatedSprite2D = $Sprite
var facing_right := true
var can_flip := true

@onready var wall_ray: RayCast2D = $Raycasts/WallRay
@onready var ground_ray: RayCast2D = $Raycasts/GroundRay


var states := {
	idle = "Idle",
	move = "Move",
	jump = "Jump",
	fall = "Fall",
	dash = "Dash",
	attack = "Attack",
	wall = "Wall",
	stun = "Stun",
}

var jump_buffer := 0.15
var jump_buffer_counter := 0.0

var stunned := false

func _ready() -> void:
	hitbox.damage = movement.attack_damage
	
	health.took_damage.connect(_on_damage_taken)
	health.died.connect(_on_died)
	
	state_machine.init(self, movement)

func _process(delta: float) -> void:
	input.update()
	
	_flip_char()
	_set_anim()
	
	if not stunned:
		movement.direction = input.direction
		movement.jump = input.jump_pressed
		movement.fall = input.jump_released
		movement.dash = input.dash_pressed
		movement.attack = input.attack_pressed
	
	state_machine.process(delta)

func _physics_process(delta: float) -> void:
	_flip_collisions()
	_check_jump_buffer(delta)
	
	state_machine.physics_process(delta)

func is_facing_right() -> bool:
	return facing_right

func can_wall_grab() -> bool:
	if is_on_wall_only() and wall_ray.is_colliding() and not ground_ray.is_colliding():
		return true
	return false

func _on_damage_taken(amount: int) -> void:
	state_machine.change_state(state_machine.get_node(states.stun))
	health.set_invincibility(1.0)
	
	sprite.play("hurt")

func _on_died() -> void:
	pass

func _check_jump_buffer(delta: float) -> void:
	if not is_on_floor() and movement.jump:
		jump_buffer_counter = jump_buffer
	else:
		jump_buffer_counter -= delta
	
	if is_on_floor() and jump_buffer_counter > 0.0:
		jump_buffer_counter = 0.0
		state_machine.change_state(state_machine.get_node(states.jump))

func _set_anim() -> void:
	match state_machine.active_state.name:
		states.idle:
			sprite.play("idle")
		states.move:
			sprite.play("run")
		states.jump:
			sprite.play("jump")
		states.fall:
			sprite.play("fall")
		states.attack:
			sprite.play("attack")
		states.dash:
			sprite.play("dash")
		states.wall:
			sprite.play("wall")

func _flip_char() -> void:
	if sprite and can_flip:
		if movement.direction > 0.0:
			sprite.flip_h = false
			facing_right = true
		if movement.direction < 0.0:
			sprite.flip_h = true
			facing_right = false

func _flip_collisions() -> void:
	if facing_right:
		wall_ray.target_position.x = 28.0
		hitbox.collision.position.x = 17.0
	if not facing_right:
		wall_ray.target_position.x = -28.0
		hitbox.collision.position.x = -17.0
