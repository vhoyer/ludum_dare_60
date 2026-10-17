extends Node

# List of all events used
const BUTTON_PRESSED = 'BUTTON_PRESSED'
const DIE_ROLLING = 'DIE_ROLLING'
const DIE_LANDED = 'DIE_LANDED'


signal audio_requested(event_name: String)

func emit(event_name: String) -> void:
	audio_requested.emit(event_name)
