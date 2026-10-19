class_name GameLevel
extends Node


@export
var goal_min: float = -INF

@export
var goal_max: float = INF

@export
var dice_starting_count: int = 1

@export_range(0.1, 2)
var dice_size: float = 1

@export
var max_rolls: int = 3

@export_group('visual')
@export
var item: Texture2D

@export
var alien_thumb: Texture2D

@export
var alien_whole: Texture2D


func is_goal_met() -> bool:
	var points: int = SaveManager.data.points
	return goal_min <= points and points <= goal_max
