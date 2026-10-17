extends CanvasLayer

signal cancel
signal ok

var value: String:
	get():
		return $CenterContainer/PanelContainer/VBoxContainer/TextEdit.text
	set(value):
		$CenterContainer/PanelContainer/VBoxContainer/TextEdit.text = value

func _on_cancel_button_down() -> void:
	cancel.emit()

func _on_ok_button_down() -> void:
	ok.emit(value)

func _on_text_edit_text_submitted(new_text: String) -> void:
	ok.emit(new_text)
