extends Area2D
class_name Hurtbox

@export var body: Node2D
@export var collision: CollisionShape2D

@export var health_component: HealthComponent

func _ready() -> void:
	_set_collision()
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		var hitbox = area as Hitbox
		if _cancel_damage(hitbox):
			return
		
		health_component.take_damage(hitbox.damage)
		_apply_knockback(hitbox.body.global_position, hitbox.knockback_force)

func _apply_knockback(souce_position: Vector2, force: Vector2) -> void:
	if body.global_position > souce_position:
		body.velocity.x = force.x
	if body.global_position < souce_position:
		body.velocity.x = -force.x
	
	body.velocity.y = force.y

func _cancel_damage(hitbox: Hitbox) -> bool:
	if body == hitbox.body or health_component.get_invincibility() or (body is Enemy and hitbox.body is Enemy):
		return true
	return false

func _set_collision() -> void:
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
	set_collision_mask_value(3, true)
