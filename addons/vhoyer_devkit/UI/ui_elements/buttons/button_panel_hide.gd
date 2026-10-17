extends BaseButton

@export var panel: Control

func _pressed() -> void:
	panel.hide()
