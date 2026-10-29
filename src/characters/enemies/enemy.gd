extends CharacterBody2D
class_name Enemy
## Base Enemy Class.

@export var enemy_stats: EnemyStats

@export var movement_component: MovementComponent
@export var health_component: HealthComponent

@export var contact_hitbox: Hitbox
@export var attack_hitbox: Hitbox

func _ready() -> void:
	health_component.max_health = enemy_stats.max_health
	health_component.health = health_component.max_health
	movement_component.speed = enemy_stats.movement_speed
	
	match enemy_stats.enemy_behavior:
		DataTypes.EnemyBehavior.PASSIVE:
			contact_hitbox.damage = enemy_stats.contact_damage
			contact_hitbox.knockback_force = enemy_stats.knockback_force
			attack_hitbox = null
		DataTypes.EnemyBehavior.AGRESSIVE:
			contact_hitbox.damage = enemy_stats.contact_damage
			contact_hitbox.knockback_force = enemy_stats.knockback_force
			attack_hitbox.damage = enemy_stats.attack_damage
			attack_hitbox.knockback_force = enemy_stats.knockback_force
	
	health_component.took_damage.connect(_on_damage_taken)
	health_component.died.connect(_on_died)
	
	_init_enemy()

## Initializes this instance of the enemy. Called from _ready() callback.
func _init_enemy() -> void:
	pass

func _on_damage_taken(amount: int) -> void:
	pass

func _on_died() -> void:
	pass
