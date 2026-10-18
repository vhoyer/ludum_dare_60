extends Control

func _on_settings_menu_content_button_back_pressed():
	get_tree().change_scene_to_file("res://stages/main_menu/main_menu.tscn")
