## Visual test for adjacent scene file `ui_goal_within_range_of_range.tscn`.
extends Control

func _ready():
	$UiGoalWithinRangeOfRange.set_value_range(40, 60)
	$UiGoalWithinRangeOfRange.value = 35
