# class_name LevelsManager
extends Node


var _current_index: int:
	get():
		return SaveManager.data.current_level
	set(value):
		SaveManager.data.current_level = wrapi(value, 0, _max_levels)


var _max_levels: int:
	get():
		return self.get_child_count()


var current: GameLevel:
	get():
		return self.get_child(_current_index)


func _ready() -> void:
	SaveManager.data.watch(self, ['current_level'], _current_level_updated)

	# press F3+N to go to next level
	CheatSystem.requested_stage_next.connect(func():
		_current_index += 1
		pass)

	# press F3+P to go to prev level
	CheatSystem.requested_stage_previous.connect(func():
		_current_index -= 1
		pass)


func _current_level_updated() -> void:
	SaveManager.data.dice_count = current.starting_dice_count
