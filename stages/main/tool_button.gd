extends Button


@export
var cursor: CursorResource


func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		GameCursor.instance.cursor = cursor
	else:
		GameCursor.instance.reset()

