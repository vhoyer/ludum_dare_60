class_name BaseStorage
extends RefCounted

var prefix: String = ''

func _init(prefix: String = '') -> void:
	if prefix != '':
		self.prefix = prefix + '::'

func _get_key(key: String) -> StringName:
	return StringName(prefix + key)


func get_item(_key: String, default_value: Variant) -> Variant:
	push_error('get_item needs to be overwritten')
	return default_value


func set_item(_key: String, _value: Variant) -> void:
	push_error('set_item needs to be overwritten')


func save_backup() -> void:
	push_error('save_backup needs to be overwritten')


func override_with_backup() -> void:
	push_error('override_with_backup needs to be overwritten')


func erase_storage() -> void:
	push_error('erase_storage needs to be overwritten')


func _list_item_keys() -> PackedStringArray:
	push_error('_list_item_keys needs to be overwritten')
	return []


func _override_with(storage: BaseStorage, prefix: String = '') -> void:
	for key: String in storage._list_item_keys():
		if not key.begins_with(prefix): continue
		set_item(key, storage.get_item(key, null))
