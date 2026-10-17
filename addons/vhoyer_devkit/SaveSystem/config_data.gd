class_name ConfigData
extends MemoryData

const SAVE_ID:= 'config'

const DEFAULT_META:= {
	'default': null,
}

var _meta: Dictionary[String, Dictionary] = {}
var _subscriptions: Dictionary = {}


var resolution_default: Vector2i:
	get():
		return Vector2i(
			ProjectSettings.get('display/window/size/viewport_width'),
			ProjectSettings.get('display/window/size/viewport_height'))

var window_size_default: Vector2i:
	get():
		var override:= Vector2i(
			ProjectSettings.get('display/window/size/window_width_override'),
			ProjectSettings.get('display/window/size/window_height_override'))
		if override: return override
		return Vector2i(
			ProjectSettings.get('display/window/size/viewport_width'),
			ProjectSettings.get('display/window/size/viewport_height'))

var fullscreen: int:
	get(): return get_config('fullscreen')
	set(value): set_config('fullscreen', value)

var vsync: int:
	get(): return get_config('vsync')
	set(value): set_config('vsync', value)

var resolution: Vector2i:
	get(): return get_config('resolution')
	set(value): set_config('resolution', value)

var max_fps: int:
	get(): return get_config('max_fps')
	set(value): set_config('max_fps', value)

var window_size: Vector2i:
	get(): return get_config('window_size')
	set(value): set_config('window_size', value)

var language: String:
	get(): return get_config('language')
	set(value): set_config('language', value)

var screen_shake: float:
	get(): return get_config('screen_shake')
	set(value): set_config('screen_shake', value)

var volume_master: float:
	get(): return get_config('volume_master')
	set(value): set_config('volume_master', value)

var volume_sfx: float:
	get(): return get_config('volume_sfx')
	set(value): set_config('volume_sfx', value)

var volume_music: float:
	get(): return get_config('volume_music')
	set(value): set_config('volume_music', value)

var volume_ambience: float:
	get(): return get_config('volume_ambience')
	set(value): set_config('volume_ambience', value)

var volume_voice: float:
	get(): return get_config('volume_voice')
	set(value): set_config('volume_voice', value)

var controller_rumble: float:
	get(): return get_config('controller_rumble')
	set(value): set_config('controller_rumble', value)




func _init() -> void:
	super(-1)
	# override base memory objects with a new better key for configurations
	_long_term = JSONStorage.new('', SAVE_ID)
	_short_term = InMemoryStorage.new('', SAVE_ID)
	_short_term._override_with(_long_term)

	# video
	register_config('fullscreen', ProjectSettings.get(&"display/window/size/mode"))
	register_config('vsync', ProjectSettings.get(&"display/window/vsync/vsync_mode"))
	register_config('max_fps', ProjectSettings.get(&"application/run/max_fps"))

	register_config('resolution', resolution_default)
	register_config('window_size', window_size_default)
	register_config('language', 'en')
	register_config('screen_shake', 1.0)

	# audio
	register_config('volume_master', 1.0)
	register_config('volume_sfx', 0.5)
	register_config('volume_music', 0.5)
	register_config('volume_ambience', 0.5)
	register_config('volume_voice', 0.8)

	# gameplay
	register_config('controller_rumble', 0.8)

## override config is always not empty
func empty() -> bool:
	return false


func register_config(key: String, default: Variant) -> void:
	_meta.set(key, {
		'default': default,
		})

func get_config(key: String) -> Variant:
	var meta:= _meta.get(key, DEFAULT_META) as Dictionary
	var default_value = meta.get('default', DEFAULT_META['default'])
	return _short_term.get_item(key, default_value)

func set_config(key: String, value: Variant) -> void:
	if _short_term.get_item(key, null) == value:
		return
	_short_term.set_item(key, value)
	_subscriptions.get(key, _dummy_listener.unbind(1)).call(value)
	changed.emit(key)

func _dummy_listener() -> void:
	pass


func set_on_config(key: String, fn: Callable) -> void:
	_subscriptions.set(key, fn)
	fn.call(get_config(key))
