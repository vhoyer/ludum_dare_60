extends Resource
class_name Trigger

signal enter()
signal exit()

var paused: bool: set = set_paused, get = get_paused

func setup(_node: Node) -> void:
	pass

func on_input(_event: InputEvent) -> void:
	pass

func set_paused(value: bool) -> void:
	paused = value

func get_paused() -> bool:
	return false
