extends Button


func _on_pressed():
	get_tree().change_scene_to_file("res://stages/settings_menu/settings_menu.tscn")
