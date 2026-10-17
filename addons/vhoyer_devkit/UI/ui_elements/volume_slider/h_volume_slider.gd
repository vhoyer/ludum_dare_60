@tool
class_name HVolumeSlider
extends HSlider

var bus: String:
	get():
		return AudioServer.get_bus_name(bus_id)
	set(value):
		bus_id = AudioServer.get_bus_index(value)


@export_storage
var bus_id

@export
var auto_update_volume: bool = true

@export_storage
var save_data_sync_property: String = ''


func _get_property_list() -> Array[Dictionary]:
	var props: Array[Dictionary] = []

	props.push_back({
		"name": "bus",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": ",".join(range(AudioServer.bus_count).map(func(i):
			return AudioServer.get_bus_name(i))),
	})

	props.push_back({
		"name": "save_data_sync_property",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_ENUM_SUGGESTION,
		"hint_string": "volume_master,volume_bgm,volume_sfx,volume_voice",
	})

	return props



func _ready() -> void:
	self.max_value = 1.0
	self.step = 0.1
	self.value = AudioServer.get_bus_volume_linear(bus_id)
	self.value_changed.connect(_on_h_slider_value_changed)

func _on_h_slider_value_changed(val: float) -> void:
	if auto_update_volume:
		AudioServer.set_bus_volume_linear(bus_id, val)
	if save_data_sync_property:
		SaveManager.config.set(save_data_sync_property, val)

