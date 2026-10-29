extends BaseLevel

@export var player_spawn: Marker2D
@export var player_camera: PlayerCamera

func get_player_default_spawn() -> Vector2:
	return player_spawn.global_position

func get_player_camera() -> PlayerCamera:
	return player_camera
