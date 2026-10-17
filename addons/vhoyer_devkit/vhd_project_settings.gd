class_name VHDSettings
extends RefCounted

const ROOT = 'vhoyer_devkit'
const CONFIG:= {
	'auto_save_config_on_change': {
		'category': 'save_manager',
		'basic': false,
		'default': true,
		'type': TYPE_BOOL,
	},
	'custom_empty_save_data_type': {
		'category': 'save_manager',
		'basic': false,
		'default': '',
		'type': TYPE_STRING,
		'hint': PROPERTY_HINT_TYPE_STRING,
		'hint_string': 'SaveData',
	},
	'transition_scene': {
		'category': 'stage_manager',
		'basic': true,
		'default': 'res://addons/vhoyer-devkit/StageManager/transition/stage_manager_transition.tscn',
		'type': TYPE_STRING,
		'hint': PROPERTY_HINT_FILE,
		'hint_string': '*.tscn,*.scn',
	},
}


static func _get_key(name: String) -> String:
	return '%s/%s/%s' % [
		ROOT,
		CONFIG[name].category,
		name]


static func setup_settings() -> void:
	const OPTIONAL_PROPERTY_INFO = [
		'hint',
		'hint_string',
	];

	for name: String in CONFIG.keys():
		var config:= CONFIG[name] as Dictionary
		var key = _get_key(name)

		ProjectSettings.set_setting(key, _get_config(name))
		ProjectSettings.set_initial_value(key, config.default)
		ProjectSettings.set_as_basic(key, config.basic)

		var property_info:= {
			"name": key,
			"type": config.type,
		}
		for info: String in OPTIONAL_PROPERTY_INFO:
			if config.has(info):
				property_info.merge({ info: config.get(info) })
		ProjectSettings.add_property_info(property_info)


static func _get_config(name: String) -> Variant:
	var key = _get_key(name)
	if ProjectSettings.has_setting(key):
		return ProjectSettings.get_setting_with_override(key)
	else:
		return CONFIG[name].default



static var transition_scene: String:
	get(): return _get_config('transition_scene')


static var empty_save_type: Resource:
	get():
		var klass_name = StringName(_get_config('custom_empty_save_data_type'))
		var klass_list = ProjectSettings.get_global_class_list()
		var index:= klass_list.find_custom(func(_klass: Dictionary):
			return _klass.class == klass_name)

		if index == -1:
			return SaveDataEmptyDefault

		var klass:= klass_list[index] as Dictionary
		return load(klass.path)


static var auto_save_config_on_change: bool:
	get(): return _get_config('auto_save_config_on_change')
