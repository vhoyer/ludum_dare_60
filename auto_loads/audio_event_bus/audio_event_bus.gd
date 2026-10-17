extends Node

# List of all events used
const BUTTON_PRESSED = 'BUTTON_PRESSED'


signal audio_requested(event_name: String)

func emit(event_name: String) -> void:
	audio_requested.emit(event_name)
