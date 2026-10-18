class_name CursorOnParent
extends Node

@export
var cursor: CursorResource

var _previous_cursor: CursorResource


var parent: Node


func _ready() -> void:
	parent = self.get_parent()
	if parent is Control:
		parent.mouse_entered.connect(_enable_cursor)
		parent.mouse_exited.connect(_disable_cursor)


func _enable_cursor() -> void:
	_previous_cursor = GameCursor.instance.cursor
	GameCursor.instance.cursor = cursor


func _disable_cursor() -> void:
	GameCursor.instance.cursor = _previous_cursor
	_previous_cursor = null
