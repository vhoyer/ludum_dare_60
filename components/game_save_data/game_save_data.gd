class_name GameSaveData
extends SaveData


var points: int:
	get():
		return self._get_item('points', 0)
	set(value):
		self._set_item('points', value)

var dice_count: int:
	get():
		return self._get_item('dice_count', 1)
	set(value):
		self._set_item('dice_count', value)

var roll_counter: int:
	get():
		return self._get_item('roll_counter', 0)
	set(value):
		self._set_item('roll_counter', value)

var current_level: int:
	get():
		return self._get_item('current_level', 0)
	set(value):
		self._set_item('current_level', value)
