## Quit Button behavior.
## Hidden from web builds.
extends Button

func _ready() -> void:
	if OS.get_name() == "Web":
		self.visible = false


func _on_pressed():
	get_tree().quit()
