extends Button


func _on_pressed():
	AudioEventBus.instance.audio_requested.emit(AudioEventBus.Id.BUTTON_PRESSED)
	StageManager.push_stage("res://stages/main_menu/main_menu.tscn")
