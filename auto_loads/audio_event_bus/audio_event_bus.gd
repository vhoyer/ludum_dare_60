class_name AudioEventBus
extends Node

# List of all events used
enum Id {
	NOOP,
	BUTTON_PRESSED,
	DICE_ROLL_REQUESTED,
	DIE_ROLLING,
	DIE_LANDED,
	HAMMER_DOWN,
	HAND_DOWN,
	HUMAN_PULL_LOSE_GRUNT,
	HUMAN_PULL_WIN_GRUNT,
}


static var instance: AudioEventBus

static func emit(event_name: Id) -> void:
	if not instance: return
	instance.audio_requested.emit(event_name)



signal audio_requested(event_name: Id)


var logger:= VHDLogger.new('AudioEventBus')

func _ready() -> void:
	if instance:
		instance.queue_free()
	instance = self
	pass
