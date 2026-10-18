extends Control

signal buttonBackPressed();

func _on_button_back_mouse_entered():
	pass

func _on_button_back_pressed():
	AudioEventBus.instance.audio_requested.emit(AudioEventBus.Id.BUTTON_PRESSED)
	buttonBackPressed.emit()
