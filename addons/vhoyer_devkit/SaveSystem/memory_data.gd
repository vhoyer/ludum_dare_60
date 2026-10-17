class_name MemoryData
extends RefCounted

signal saved()
signal changed(what: String)

var _short_term: InMemoryStorage
var _long_term: JSONStorage

func _init(index: int) -> void:
	var save_id = 'save%s' % index
	_long_term = JSONStorage.new('', save_id)
	_short_term = InMemoryStorage.new('', save_id)
	_short_term._override_with(_long_term)


func consolidate_memory() -> void:
	_long_term._override_with(_short_term)
	saved.emit()


func remember() -> void:
	_short_term._override_with(_long_term)
	changed.emit()


func amnesia() -> void:
	_long_term.erase_storage()
	_short_term.erase_storage()
	changed.emit()
	saved.emit()


## subscribe to changes in save data, when watch is called, it also calls the
## effect automatically.[br]
##
## watch_keys: [PackedStringArray] - array listing keys to watch, if no keys are passed, effect is run for anything
## effect: [Callable] - function to run when the save data changes[br]
func watch(context: Node, watch_keys: PackedStringArray, effect: Callable) -> Callable:
	var subscription:= func(what: String):
		if what == '' or watch_keys.has(what):
			effect.call()
		pass

	changed.connect(subscription)
	effect.call()

	var unsubscribe:= func():
		if changed.is_connected(subscription):
			changed.disconnect(subscription)

	if context:
		context.tree_exiting.connect(unsubscribe)

	return unsubscribe


func empty() -> bool:
	return _short_term._list_item_keys().size() == 0
