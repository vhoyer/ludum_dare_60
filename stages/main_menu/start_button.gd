extends Button

@export
var next_stage: String

func _pressed() -> void:
	StageManager.push_stage(next_stage)
	AudioEventBus.emit(AudioEventBus.BUTTON_PRESSED)
