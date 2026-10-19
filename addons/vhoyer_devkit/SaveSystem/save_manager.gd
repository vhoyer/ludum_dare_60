# class_name SaveManager
extends Node


var data: SaveData:
	get():
		if !data: data = VHDSettings.empty_save_type.new()
		return data

func load_data(_data: SaveData) -> void:
	var new_data: SaveData = _data if _data else VHDSettings.empty_save_type.new()

	for conn: Dictionary in data.changed.get_connections():
		new_data.changed.connect(conn.get('callable'), conn.get('flags'))

	data = new_data



var config: ConfigData = ConfigData.new()

func _init() -> void:
	if VHDSettings.auto_save_config_on_change:
		# auto save on every change
		config.changed.connect(config.consolidate_memory.unbind(1))

	_register_volume_handlers()
	_register_language_handlers()


func _ready() -> void:
	_register_screen_handlers()
	_register_resolution_handlers()


func _process(delta: float) -> void:
	data.file_time += delta


func _register_language_handlers() -> void:
	if Engine.is_editor_hint(): return

	config.set_on_config('language', func set_locale_from_config(locale: String):
		TranslationServer.set_locale(locale))



var _window_mode_change_ownership:= false

func _register_screen_handlers() -> void:
	if Engine.is_editor_hint(): return

	config.set_on_config('fullscreen', func set_window_mode_from_config(mode: int):
		_window_mode_change_ownership = true
		DisplayServer.window_set_mode(mode))
	config.set_on_config('vsync', func set_from_config(mode: int):
		DisplayServer.window_set_vsync_mode(mode))
	config.set_on_config('max_fps', func set_from_config(max_fps: int):
		Engine.max_fps = max_fps)

	# to access viewport, we need to wait ready
	if not self.is_node_ready():
		await self.ready

	get_viewport().size_changed.connect(func update_resolution_setting_on_resize():
		if _window_mode_change_ownership:
			_window_mode_change_ownership = false
		else:
			config.fullscreen = DisplayServer.window_get_mode()
		pass)



var _window_size_change_ownership:= false

func _register_resolution_handlers() -> void:
	config.set_on_config('window_size', func set_window_resolution_from_config(res: Vector2i):
		if res == Vector2i.ZERO: return
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN: return
		if OS.has_feature('web'): return
		_window_size_change_ownership = true
		get_tree().root.size = res)

	get_viewport().size_changed.connect(func update_resolution_setting_on_resize():
		if _window_size_change_ownership:
			_window_size_change_ownership = false
		else:
			config.window_size = Vector2i.ZERO)


func _register_volume_handlers() -> void:
	if Engine.is_editor_hint(): return

	const search:= {
		'Master': 'volume_master',
		'BGM': 'volume_bgm',
		'SFX': 'volume_sfx',
		'Ambience': 'volume_ambience',
		'Voice': 'volume_voice',
	}

	var actuator:= func set_volume_from_config(volume: float, id: int):
		AudioServer.set_bus_volume_linear(id, volume)

	for id: int in AudioServer.bus_count:
		var bus_name:= AudioServer.get_bus_name(id)
		var mapped_config:= search.get(bus_name, '') as String
		if not mapped_config: continue
		config.set_on_config(mapped_config, actuator.bind(id))
