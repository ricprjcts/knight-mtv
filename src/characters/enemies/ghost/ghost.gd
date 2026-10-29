extends Enemy
class_name Ghost

@onready var sprite: Sprite2D = $Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var wall_ray: RayCast2D = $Raycasts/WallRay
@onready var ledge_ray: RayCast2D = $Raycasts/LedgeRay

@onready var bt_player: BTPlayer = $BTPlayer

@export var player_aggro_threshold := 120.0
var player: Player = null

@export var stun_time = 0.2
var stunned := false

func _init_enemy() -> void:
	player = get_tree().get_first_node_in_group("Player")
	bt_player.blackboard.set_var("state", "patrol")

func _process(delta: float) -> void:
	_flip_char()

func _physics_process(delta: float) -> void:
	_flip_rays()
	
	if check_player_distance() and not bt_player.blackboard.get_var("chase_cooldown"):
		bt_player.blackboard.set_var("player", player)
		bt_player.blackboard.set_var("state", "chase")
		bt_player.restart()
	
	move_and_slide()

func stop(delta: float) -> void:
	if not stunned:
		velocity.x = 0.0
		velocity.y += movement_component.gravity * delta

func move(delta: float, direction: float) -> void:
	if not stunned:
		movement_component.direction = direction
		velocity.x = movement_component.direction * movement_component.speed
		velocity.y += movement_component.gravity * delta

func _on_damage_taken(amount: int) -> void:
	stunned = true
	await get_tree().create_timer(stun_time).timeout
	stunned = false

func _on_died() -> void:
	queue_free()

func check_player_distance() -> bool:
	if player == null:
		return false
	
	var distance := global_position.distance_to(player.global_position)
	
	return distance <= player_aggro_threshold

func is_at_ledge_or_wall() -> bool:
	if wall_ray.is_colliding() or not ledge_ray.is_colliding():
		return true
	return false

func _flip_char() -> void:
	if sprite:
		if movement_component.direction > 0.0:
			sprite.flip_h = true
		if movement_component.direction < 0.0:
			sprite.flip_h = false

func _flip_rays() -> void:
	if wall_ray and ledge_ray:
		if movement_component.direction > 0.0:
			wall_ray.target_position.x = 16.0
			ledge_ray.position.x = 15.0
		if movement_component.direction < 0.0:
			wall_ray.target_position.x = -16.0
			ledge_ray.position.x = -15.0
