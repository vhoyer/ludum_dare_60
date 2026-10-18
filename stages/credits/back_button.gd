extends Button


func _on_pressed():
	AudioEventBus.instance.audio_requested.emit(AudioEventBus.Id.BUTTON_PRESSED)
	get_tree().change_scene_to_file("res://stages/main_menu/main_menu.tscn")
