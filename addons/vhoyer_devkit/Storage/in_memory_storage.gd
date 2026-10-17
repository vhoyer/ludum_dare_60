class_name InMemoryStorage
extends BaseStorage

static var _storage: Dictionary = {}
static var _backup: Dictionary = {}

var _scope: String

func _init(prefix: String = '', scope: String = 'global') -> void:
	super(prefix)
	_scope = scope
	_storage.get_or_add(_scope, {})


func set_item(key: String, value: Variant) -> void:
	_storage.get_or_add(_scope, {}).set(self._get_key(key), value)


func get_item(key: String, default_value: Variant) -> Variant:
	return _storage.get_or_add(_scope, {}).get(self._get_key(key), default_value)


func save_backup() -> void:
	_backup.set(_scope, _storage.get(_scope, {}).duplicate(true))


func override_with_backup() -> void:
	_storage.set(_scope, _backup.get(_scope, {}).duplicate(true))


func erase_storage() -> void:
	_storage.set(_scope, {})


func _list_item_keys() -> PackedStringArray:
	return _storage.get(_scope, {}).keys()
