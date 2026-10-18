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
