extends HBoxContainer


func _ready() -> void:
	%OptionButton.select(SaveManager.config.controller_rumble)

func _on_option_button_item_selected(index: int) -> void:
	SaveManager.config.controller_rumble = index
