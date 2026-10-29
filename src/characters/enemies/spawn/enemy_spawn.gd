extends Marker2D
class_name EnemySpawn
## Enemy spawner base class. Spawns a given enemy when the spawner is rendered in the viewport.

## The scene to be instantiated.
@export var enemy_scene: PackedScene
## Won't work if unchecked.
@export var enabled := true

@onready var screen_notifier: VisibleOnScreenNotifier2D = %ScreenNotifier

var _main_game: MainGame

func _ready() -> void:
	if enabled:
		_main_game = get_tree().get_first_node_in_group("MainGame")
		
		screen_notifier.screen_entered.connect(_on_screen_entered)
	else:
		push_warning("Spawner Disabled: ", self)


func _on_screen_entered() -> void:
	load_enemy(enemy_scene)

## Instantiates the enemy's scene at the Marker position.
func load_enemy(scene: PackedScene) -> void:
	var enemy_instance: Node2D = scene.instantiate() as Node2D
	if enemy_instance == null:
		return
	
	var _entities_root := _main_game.get_game_root(DataTypes.GameRoots.ENTITIES) as Node2D
	if _entities_root == null:
		return
	
	enemy_instance.global_position = global_position
	_entities_root.add_child(enemy_instance)
	queue_free()
