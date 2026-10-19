## Play audio for the game.
## SFX are triggered by listening to signals from the AudioEventBus.
extends Node

func _ready():
	AudioEventBus.instance.audio_requested.connect(_play_sfx)

func _play_sfx(event_name: AudioEventBus.Id):
	match event_name:
		AudioEventBus.Id.HAMMER_DOWN:
			$SFXPoundHammer.play()
			return
		AudioEventBus.Id.HAND_DOWN:
			$SFXPoundHand.play()
			return
		AudioEventBus.Id.BUTTON_PRESSED:
			$SFXButtonPressed.play()
			return
		AudioEventBus.Id.HUMAN_PULL_WIN_GRUNT:
			$SFXVoiceGruntAstronaut.play()
			return
		AudioEventBus.Id.HUMAN_PULL_LOSE_GRUNT:
			$SFXVoiceGruntAstronaut.play()
			return

	push_warning("SFX not found for audio event %s (%s)." % [AudioEventBus.Id.find_key(event_name), event_name])
