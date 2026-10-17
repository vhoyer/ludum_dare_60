extends BaseStorage
class_name ResourceStorage

const PATH = 'user://%s_storage.tres'
const PATH_BACKUP = 'user://%s_storage_bkp.tres'


class Store extends Resource:
	var data: Dictionary = {}

var _scope: String
var _storage:= Store.new()
static var is_cache_valid = {}


func _init(prefix: String = '', scope: String = 'global') -> void:
	super(prefix)
	self._scope = scope
	self.is_cache_valid[scope] = true
	var path = _get_path()

	if FileAccess.file_exists(path):
		var loaded = ResourceLoader.load(path)
		self._storage.data = loaded.data

func _get_path() -> String:
	return PATH % self._scope

func _get_path_backup() -> String:
	return PATH_BACKUP % self._scope


func set_item(key: String, value: Variant) -> void:
	reload_storage_if_necessary()
	_storage.data[self._get_key(key)] = value
	ResourceSaver.save(_storage, _get_path())
	is_cache_valid[_scope] = false


func get_item(key: String, default_value: Variant) -> Variant:
	reload_storage_if_necessary()
	return _storage.data.get(self._get_key(key), default_value)


func reload_storage_if_necessary() -> void:
	if is_cache_valid.get(_scope, false):
		# not necessary, cache is valid
		return
	var loaded = ResourceLoader.load(_get_path(), "", ResourceLoader.CACHE_MODE_IGNORE)
	_storage.data = loaded.data
	is_cache_valid[_scope] = true


func save_backup() -> void:
	ResourceSaver.save(_storage, _get_path_backup())

func override_with_backup() -> void:
	var loaded = ResourceLoader.load(_get_path_backup(), "", ResourceLoader.CACHE_MODE_IGNORE)
	ResourceSaver.save(loaded, _get_path())
	is_cache_valid[_scope] = false


func _list_item_keys() -> PackedStringArray:
	return _storage.data.keys()
