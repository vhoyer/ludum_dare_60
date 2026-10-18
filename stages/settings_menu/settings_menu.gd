extends Control

func _on_settings_menu_content_button_back_pressed():
	StageManager.push_stage("res://stages/main_menu/main_menu.tscn")
