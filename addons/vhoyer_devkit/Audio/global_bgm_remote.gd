class_name GlobalBGMRemote
extends AudioStreamPlayer


func _ready() -> void:
	if Engine.has_singleton('GlobalBGM'):
		Engine.get_singleton('GlobalBGM').push_bgm(self)
	self.playing = false
