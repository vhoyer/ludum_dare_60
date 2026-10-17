extends Node
class_name MakeParentControllerFocusStart

var parent: Control

var using_ui_direction: bool = false
var was_visible = true
var old_focused: Control

func _ready() -> void:
	parent = self.get_parent()
	if parent is TabContainer:
		parent = parent.get_tab_bar()


func _input(event: InputEvent) -> void:
	using_ui_direction = false
	for action in ['ui_left', 'ui_right', 'ui_up', 'ui_down']:
		if event.is_action(action):
			using_ui_direction = true
	if not using_ui_direction: return

	if not parent.is_visible_in_tree(): return

	var focused_control = get_viewport().gui_get_focus_owner()
	if focused_control: return

	parent.accept_event()
	parent.grab_focus()


func _process(_delta: float) -> void:
	var focused_control = get_viewport().gui_get_focus_owner()
	var is_visible = parent.is_visible_in_tree()

	if not was_visible and is_visible:
		old_focused = focused_control
		parent.grab_focus()
	elif was_visible and not is_visible and old_focused:
		old_focused.grab_focus()

	was_visible = is_visible
