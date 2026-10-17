extends VBoxContainer

const SELF_SCENE = 'uid://j5aw2e2pdy08'

signal _model_updated()


@export
var id: String:
	set(value):
		id = value
		_model_updated.emit()

var _status: String:
	set(value):
		_status = value
		_model_updated.emit()


@onready
var label: Label = %Label

@onready
var status: Label = %Status

@onready
var _sub_loader_container: Container = %SubLoader


var _sub_loaders:= PackedStringArray()

func _ready() -> void:
	_status = VHDStatus.get_status(id)
	_model_updated.connect(_update_view)
	_model_updated.emit()

	VHDStatus.status_changed.connect(_status_changed)


func _update_view() -> void:
	label.text = id.substr(id.rfind('/') + 1)
	status.text = _status

	if _status.begins_with('error'):
		status.add_theme_color_override('font_color', Color.RED)
	else:
		status.remove_theme_color_override('font_color')


func _status_changed(incoming_id: String, incoming_status: String) -> void:
	if id == incoming_id:
		_status = incoming_status
	elif id.begins_with('%s/' % id):
		if _sub_loaders.has(incoming_id): return
		_sub_loaders.push_back(incoming_id)

		var loader = load(SELF_SCENE).instantiate()
		_sub_loader_container.add_child(loader)
		loader.id = incoming_id
