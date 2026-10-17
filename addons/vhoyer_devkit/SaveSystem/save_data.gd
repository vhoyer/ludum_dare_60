class_name SaveData
extends MemoryData


func empty() -> bool:
	return file_time == 0


func unlock_achievement(_what) -> void:
	push_warning('overwrite this method to do achievements')
	pass


func _get_item(key: String, default: Variant) -> Variant:
	return self._short_term.get_item(key, default)


func _set_item(key: String, value: Variant, emit_changed:= true) -> void:
	self._short_term.set_item(key, value)
	if emit_changed:
		self.changed.emit(key)


var file_time: float:
	get():
		return _get_item('file_time', 0)
	set(value):
		_set_item('file_time', value, false)
