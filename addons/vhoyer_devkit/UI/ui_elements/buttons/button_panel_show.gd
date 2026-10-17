class_name ButtonPanelShow
extends Button

@export var panel: Control:
	set(value):
		panel = value
		update_configuration_warnings()


@export var toggle_behavior: bool = false

func _ready() -> void:
	panel.hide()

func _pressed() -> void:
	if toggle_behavior:
		panel.visible = !panel.visible
	else:
		panel.show()


func _get_configuration_warnings() -> PackedStringArray:
	var warns = PackedStringArray()

	if not panel:
		warns.push_back('Needs a panel set')

	return warns
