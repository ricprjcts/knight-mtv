extends Node
class_name MainGame


const PLAYER_SCENE_UID: String = "uid://r188evn2vwhw"
var player: Player = null

@export var initial_scene_uid: String = ""

## Contains world related things. Ex: Tilemap, spawners, etc.
@onready var level_root: Node2D = %LevelRoot
## Contains entities, such as the player, npc's, etc.
@onready var entities_root: Node2D = %EntitiesRoot
## Root for effects.
@onready var effects_root: Node2D = %EffectsRoot

#The game hud root.
@onready var hud_root: Control = %HudRoot
## The pause root. Only runs when the game tree is paused.
@onready var pause_root: Control = %PauseRoot
## The transition root , for scene changes.
@onready var transition_root: Control = %TransitionRoot


var _current_scene: BaseLevel = null

func _ready() -> void:
	load_scene(initial_scene_uid)
	
	await get_tree().physics_frame
	
	_init_player(PLAYER_SCENE_UID)

## Intantiates a scene from its UID and loads it in the level root.
func load_scene(scene_uid: String) -> void:
	if is_instance_valid(_current_scene):
		_current_scene.queue_free()
		_current_scene = null
	
	var new_level_packed: PackedScene = ResourceLoader.load(scene_uid, "PackedScene")
	
	if new_level_packed == null:
		push_error("Could not load scene as PackedScene", scene_uid)
		return
	
	var new_level: Node = new_level_packed.instantiate()
	if new_level == null:
		push_error("Could not instantiate level", scene_uid)
		return
	
	if new_level is not BaseLevel:
		push_error("Scene is not BaseLevel", scene_uid)
		new_level.free()
		return
	
	_current_scene = new_level
	level_root.add_child(_current_scene)

## Returns one of the game roots
func get_game_root(root: DataTypes.GameRoots) -> Node:
	match root:
		DataTypes.GameRoots.LEVEL:
			return level_root
		DataTypes.GameRoots.ENTITIES:
			return entities_root
		DataTypes.GameRoots.EFFECTS:
			return effects_root
		DataTypes.GameRoots.HUD:
			return hud_root
		DataTypes.GameRoots.PAUSE:
			return pause_root
		DataTypes.GameRoots.TRANSITION:
			return transition_root
	
	push_error("Could not get root: ", DataTypes.GameRoots.keys()[root].to_lower().capitalize())
	return null

func _init_player(player_scene_uid: String) -> void:
	if _current_scene == null:
		return
	
	var player_scene: PackedScene = ResourceLoader.load(player_scene_uid, "PackedScene")
	if player_scene == null:
		push_error("Could not load player scene", player_scene_uid)
		return
	
	var player_instance: Node = player_scene.instantiate()
	if player_instance == null:
		push_error("Could not instantiate player scene", player_scene_uid)
		return
	
	if player_instance is not Player:
		return
	
	player = player_instance
	
	_place_player_at_spawn()
	_set_player_camera()
	
	entities_root.add_child(player)

func _place_player_at_spawn() -> void:
	if player == null or _current_scene == null:
		return
	
	var spawn_pos: Vector2 = _current_scene.get_player_default_spawn()
	player.global_position = spawn_pos

func _set_player_camera() -> void:
	if player == null or _current_scene == null:
		return
	
	var player_camera: PlayerCamera = _current_scene.get_player_camera()
	player_camera.target = player
