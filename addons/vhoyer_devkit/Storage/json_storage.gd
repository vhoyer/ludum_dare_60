class_name JSONStorage
extends BaseStorage

const PATH = 'user://%s_storage.json'
const PATH_BACKUP = 'user://%s_storage_bkp.json'

var logger: VHDLogger

var _scope: String
var _storage: Dictionary = {}

static var _is_cache_valid = {}


func _init(prefix: String = '', scope: String = 'global') -> void:
	super(prefix)
	logger = VHDLogger.scope('JSONStorage.%s' % scope)
	self._scope = scope
	self._is_cache_valid[scope] = true
	var path = _get_path()

	load_from_file(path)

func _get_path() -> String:
	return PATH % self._scope

func _get_path_backup() -> String:
	return PATH_BACKUP % self._scope


func set_item(key: String, value: Variant) -> void:
	reload_storage_if_necessary()
	_storage[self._get_key(key)] = value
	save_to_file(_get_path())
	_is_cache_valid[_scope] = false


func get_item(key: String, default_value: Variant) -> Variant:
	reload_storage_if_necessary()
	return _storage.get(self._get_key(key), default_value)


func reload_storage_if_necessary() -> void:
	if _is_cache_valid.get(_scope, false):
		# not necessary, cache is valid
		return
	load_from_file(_get_path())
	_is_cache_valid[_scope] = true


func load_from_file(path) -> void:
	if not FileAccess.file_exists(path): return
	var file = FileAccess.open(path, FileAccess.READ)
	var json_string = file.get_as_text()
	var json = JSON.new()
	var error = json.parse(json_string)
	if error != OK:
		logger.error("JSON Parse Error: %s in %s at line %s" % [
			json.get_error_message(), json_string, json.get_error_line(),
		])
		return
	var loaded = JSON.to_native(json.data, false)
	if typeof(loaded) != TYPE_DICTIONARY:
		logger.error("Unexpected data")
		return
	self._storage = loaded
	file.close()


func save_to_file(path: String) -> void:
	var json = JSON.from_native(_storage, false)
	DirAccess.make_dir_recursive_absolute(path.get_base_dir())
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(json))
	file.close()


func save_backup() -> void:
	save_to_file(_get_path_backup())

func override_with_backup() -> void:
	load_from_file(_get_path_backup())


func erase_storage() -> void:
	_storage = {}
	save_to_file(_get_path())
	_is_cache_valid[_scope] = false



func _list_item_keys() -> PackedStringArray:
	return _storage.keys()
