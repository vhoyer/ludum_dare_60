class_name AudioEventBus
extends Node

# List of all events used
# don't reorder keys after the fact, their value is based on the list position
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
	DIE_DESTROY,
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
