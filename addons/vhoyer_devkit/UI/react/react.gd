## ## Example
## ```gdscript
## func _ready() -> void:
##     var patient:= Patient.new()
##     patient.name = 'wololo'
##
##     DvkReact.new(patient, func(fetch):
##         self.get_name('Label').text = fetch.call('name')
##         pass)
## ```
class_name DvkReact
extends RefCounted


signal model_changed(what: String)


var _bind_dependencies:= PackedStringArray()

var _data: Object

var _update_view: Callable


func _init(data: Object, bind: Callable) -> void:
	_data = data

	if _data.has_signal('_model_changed'):
		_data._model_changed.connect(_on_model_changed)
	else:
		model_changed.connect(_on_model_changed)

	_update_view = bind
	bind.call(_bind)


func _on_model_changed(what: String) -> void:
	if what == '' or _bind_dependencies.has(what):
		_update_view.call(_bind)


func _bind(key: String) -> Variant:
	if not _bind_dependencies.has(key):
		_bind_dependencies.push_back(key)
	return _data.get(key)


## When updating data, always update it using this method to ensure proper
## reactivity
func update(key: String, value: Variant) -> void:
	_data.set(key, value)
	model_changed.emit(key)
