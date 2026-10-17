extends Button

@export
var next_stage: String


func _on_button_down() -> void:
	AudioEventBus.emit(AudioEventBus.Id.BUTTON_PRESSED)
	StageManager.push_stage(next_stage)
