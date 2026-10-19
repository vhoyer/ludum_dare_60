extends HBoxContainer


func _ready() -> void:
	%OptionButton.select(SaveManager.config.screen_shake)

func _on_option_button_item_selected(index: int) -> void:
	SaveManager.config.screen_shake = index
