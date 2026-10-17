class_name AudioEventBus
extends Node

# List of all events used
const BUTTON_PRESSED = 'BUTTON_PRESSED'
const DICE_ROLL_REQUESTED = 'DICE_ROLL_REQUESTED'
const DIE_ROLLING = 'DIE_ROLLING'
const DIE_LANDED = 'DIE_LANDED'


static var instance: AudioEventBus

static func emit(event_name: String) -> void:
	if not instance: return
	instance.audio_requested.emit(event_name)



signal audio_requested(event_name: String)


func _ready() -> void:
	if instance:
		instance.queue_free()
	instance = self
	pass
