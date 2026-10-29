extends Resource
class_name EnemyStats

@export var enemy_behavior: DataTypes.EnemyBehavior
@export var enemy_movement: DataTypes.EnemyMovement

@export var movement_speed := 100.0

@export var max_health := 3
@export var contact_damage := 1
@export var attack_damage := 1
@export var knockback_force: Vector2
