## class_name GlobalBGM
extends AudioStreamPlayer

var tween: Tween


func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS

	# Make available as a singleton
	if not Engine.has_singleton("GlobalBGM"):
		Engine.register_singleton("GlobalBGM", self)


func push_bgm(remote: GlobalBGMRemote) -> void:
	const PROP_LIST = [
		'pitch_scale',
		'stream_paused',
		'mix_target',
		'max_polyphony',
		'bus',
		'playback_type',
	]

	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()

	if self.stream == remote.stream:
		tween.set_parallel(true)
		for prop in PROP_LIST:
			tween.tween_property(self, prop, remote.get(prop), 0.2)
		tween.tween_property(self, 'volume_linear', remote.volume_linear, 0.2)
	else:
		tween.tween_property(self, 'volume_linear', 0, 0.15)
		tween.tween_callback(func():
			for prop in PROP_LIST:
				self.set(prop, remote.get(prop))
			self.stream = remote.stream
			self.play())
		tween.tween_property(self, 'volume_linear', remote.volume_linear, 0.15)
