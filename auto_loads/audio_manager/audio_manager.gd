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
			match SaveManager.data.current_level:
				3:
					$SFXVoicePlayerAgainstAlienBirdWin.play()
					return
				4:
					$SFXVoicePlayerAgainstAlienBirdWin.play()
					return
				5:
					$SFXVoicePlayerAgainstAlienBirdLastWin.play()
					return
				6:
					$SFXVoicePlayerAgainstAlienKindWin.play()
					return
				7:
					$SFXVoicePlayerAgainstAlienKindWin.play()
					return
				8:
					$SFXVoicePlayerAgainstAlienKindLastWin.play()
					return
				9:
					$SFXVoicePlayerAgainstAlienEvilWin.play()
					return
				10:
					$SFXVoicePlayerAgainstAlienEvilWin.play()
					return
				11:
					$SFXVoicePlayerAgainstAlienEvilLastWin.play()
					return
			## Default grunt when specific alien not found.
			$SFXVoiceGruntAstronaut.play()
			return
		AudioEventBus.Id.HUMAN_PULL_LOSE_GRUNT:
			match SaveManager.data.current_level:
				3:
					$SFXVoicePlayerAgainstAlienBirdLose.play()
					return
				4:
					$SFXVoicePlayerAgainstAlienBirdLose.play()
					return
				5:
					$SFXVoicePlayerAgainstAlienBirdLose.play()
					return
				6:
					$SFXVoicePlayerAgainstAlienKindLose.play()
					return
				7:
					$SFXVoicePlayerAgainstAlienKindLose.play()
					return
				8:
					$SFXVoicePlayerAgainstAlienKindLose.play()
					return
				9:
					$SFXVoicePlayerAgainstAlienEvilLose.play()
					return
				10:
					$SFXVoicePlayerAgainstAlienEvilLose.play()
					return
				11:
					$SFXVoicePlayerAgainstAlienEvilLose.play()
					return
			## Default grunt when specific alien not found.
			$SFXVoiceGruntAstronaut.play()
			return

	push_warning("SFX not found for audio event %s (%s)." % [AudioEventBus.Id.find_key(event_name), event_name])
