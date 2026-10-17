@tool
@icon("res://addons/godot-devkit/UI/ui_elements/wheel_picker_button/h_wheel_picker_button.svg")
class_name HWheelPickerButton
extends BaseButton

signal _model_updated()
signal item_selected(index: int)
signal ui_item_selected(index: int)

@export
var selected: int = 0:
	set(value):
		selected = wrapi(value, 0, _items_count)
		_model_updated.emit()
		item_selected.emit(selected)


@export_group('Styling')
@export
var label_style_previous: String = '<'
@export
var label_style_next: String = '>'


static var _default_label_settings:= LabelSettings.new()

@export_subgroup('label_settings', 'label_settings')
@export
var label_settings_focused: LabelSettings
@export
var label_settings_pressed: LabelSettings
@export
var label_settings_hover: LabelSettings
@export
var label_settings_disabled: LabelSettings

@export_storage
var items_default_type: int = 0:
	set(value):
		items_default_type = value
		self.notify_property_list_changed()

@export_storage
var _items_count: int = 0

@export_storage
var _items_text: PackedStringArray = []

@export_storage
var _items_type: PackedInt32Array = []

@export_storage
var _items_meta: Array = []


func add_item(text: String, metadata: Variant = null) -> int:
	var index = _items_count
	_items_text.resize(index + 1)
	_items_type.resize(index + 1)
	_items_meta.resize(index + 1)

	_items_text.set(index, text)
	_items_type.set(index, typeof(metadata))
	_items_meta.set(index, metadata)

	_items_count += 1

	_model_updated.emit()
	self.notify_property_list_changed()
	return index

func remove_item(index: int) -> void:
	_items_text.remove_at(index)
	_items_type.remove_at(index)
	_items_meta.remove_at(index)
	_items_count -= 1
	_model_updated.emit()
	self.notify_property_list_changed()

func clear_items() -> void:
	_items_text.resize(0)
	_items_type.resize(0)
	_items_meta.resize(0)
	_items_count = 0
	_model_updated.emit()
	self.notify_property_list_changed()

func get_item_metadata(index: int) -> Variant:
	return _items_meta.get(index)

func set_item_metadata(index: int, metadata: Variant) -> void:
	_items_meta.set(index, metadata)
	_model_updated.emit()

func get_item_text(index: int) -> String:
	if index >= _items_count or index < 0:
		return ' ';
	return _items_text.get(index)

func set_item_text(index: int, text: String) -> void:
	_items_text.set(index, text)
	_model_updated.emit()

func get_index_by_metadata(metadata: Variant) -> int:
	return _items_meta.find(metadata)


func select_by_metada(metadata: Variant) -> void:
	selected = get_index_by_metadata(metadata)


var _layout: HBoxContainer
var _selected_text: Label
var _btn_prev: Button
var _btn_next: Button


func _init() -> void:
	_layout = HBoxContainer.new()
	self.add_child(_layout)
	_layout.add_theme_constant_override('separation', 4)
	_layout.alignment = BoxContainer.ALIGNMENT_CENTER
	_layout.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	_btn_prev = Button.new()
	_layout.add_child(_btn_prev)
	_btn_prev.text = label_style_previous
	_btn_prev.flat = true
	_style_sub_btn(_btn_prev)
	_btn_prev.focus_mode = Control.FOCUS_NONE
	_btn_prev.size = Vector2.ZERO
	_btn_prev.set_anchors_and_offsets_preset(Control.PRESET_CENTER_LEFT)
	_btn_prev.pressed.connect(_select_prev_item)

	_selected_text = Label.new()
	_layout.add_child(_selected_text)
	_selected_text.text = ' '
	_selected_text.set_anchors_and_offsets_preset(Control.PRESET_CENTER)

	_btn_next = _btn_prev.duplicate()
	_layout.add_child(_btn_next)
	_btn_next.text = label_style_next
	_btn_next.set_anchors_and_offsets_preset(Control.PRESET_CENTER_RIGHT)
	_btn_next.pressed.connect(_select_next_item)

	self.pressed.connect(_select_next_item)
	self.focus_entered.connect(_on_focus_entered)
	self.focus_exited.connect(_on_focus_exited)
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)
	self.button_down.connect(_on_pressed)
	self.button_up.connect(_on_released)

	item_selected.connect(_item_selected)

	_model_updated.connect(_update_view)
	_update_view()


func _get_property_list() -> Array[Dictionary]:
	var props: Array[Dictionary] = []

	props.push_back({
		"name": "Items",
		"type": TYPE_NIL,
		"hint_string": "item_",
		"usage": PROPERTY_USAGE_GROUP,
	})

	props.push_back({
		"name": "item_default_type",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": ','.join(range(TYPE_MAX).map(func(type_id):
			return '%s:%d' % [type_string(type_id), type_id])),
		"usage": PROPERTY_USAGE_EDITOR,
	})

	for i in _items_count:
		props.push_back({
			"name": "item_%d/text" % i,
			"type": TYPE_STRING,
		})
		props.push_back({
			"name": "item_%d/type" % i,
			"type": TYPE_INT,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": ','.join(range(TYPE_MAX).map(func(type_id):
				return '%s:%d' % [type_string(type_id), type_id])),
			"usage": PROPERTY_USAGE_EDITOR,
		})
		var metatype: int = _items_type.get(i)
		props.push_back({
			"name": "item_%d/metadata" % i,
			"type": metatype,
			"usage": PROPERTY_USAGE_EDITOR if (metatype != TYPE_NIL) else PROPERTY_USAGE_NONE,
		})
		props.push_back({
			"name": "item_%d/remove" % i,
			"type": TYPE_CALLABLE,
			"hint": PROPERTY_HINT_TOOL_BUTTON,
			"hint_string": "Remove,Remove",
			"usage": PROPERTY_USAGE_EDITOR,
		})

	props.push_back({
		"name": "item_add",
		"type": TYPE_CALLABLE,
		"hint": PROPERTY_HINT_TOOL_BUTTON,
		"hint_string": "Add Item,Add",
		"usage": PROPERTY_USAGE_EDITOR,
	})

	return props


func _get(property: StringName) -> Variant:
	if property == &"item_add":
		return add_item.bind('', null)

	var regex:= RegEx.new()
	regex.compile(r'^item_(?<index>\d+)/(?<pname>\w+)$')
	var result = regex.search(property)
	if result:
		var index:= result.get_string('index') as int
		var pname:= result.get_string('pname')
		match pname:
			'remove':
				return remove_item.bind(index)
			'text':
				return get_item_text(index)
			'type':
				return _items_type.get(index)
			'metadata':
				return get_item_metadata(index)
		pass

	return null


func _set(property: StringName, value: Variant) -> bool:
	if property == 'disabled':
		if value:
			_on_disabled()
		else:
			_on_enabled()
		return false

	var regex:= RegEx.new()
	regex.compile(r'^item_(?<index>\d+)/(?<pname>\w+)$')
	var result = regex.search(property)
	if result:
		var index:= result.get_string('index') as int
		var pname:= result.get_string('pname')
		match pname:
			'text':
				set_item_text(index, value)
				return true
			'type':
				_items_type.set(index, value)
				self.notify_property_list_changed()
				return true
			'metadata':
				set_item_metadata(index, value)
				return true
		pass

	return false


func _property_can_revert(property: StringName) -> bool:
	var regex:= RegEx.new()
	regex.compile(r'^items\d+/type$')
	return !!regex.search(property)


func _property_get_revert(property: StringName) -> Variant:
	var regex:= RegEx.new()
	regex.compile(r'^items\d+/type$')
	if regex.search(property):
		return items_default_type
	return false


func _style_sub_btn(btn: Button) -> void:
	var stylebox_empty:= StyleBoxEmpty.new()
	stylebox_empty.set_content_margin_all(4)

	btn.add_theme_stylebox_override('focus', stylebox_empty)
	btn.add_theme_stylebox_override('hover', stylebox_empty)
	btn.add_theme_stylebox_override('hover_pressed', stylebox_empty)
	btn.add_theme_stylebox_override('normal', stylebox_empty)
	btn.add_theme_stylebox_override('pressed', stylebox_empty)


func _get_minimum_size() -> Vector2:
	var controls = _layout.get_children() \
		.map(func(node: Control): return node.get_minimum_size())
	var separation = _layout.get_theme_constant('separation')

	var new_min_size:= Vector2(
		controls.reduce(func(acc: float, min_size: Vector2): return acc + min_size.x, 0) + (separation * max(0, controls.size() - 2)),
		controls.reduce(func(acc: float, min_size: Vector2): return max(acc, min_size.y), 0))

	_layout.set_size(new_min_size)

	return new_min_size

func _update_view() -> void:
	_selected_text.text = tr(get_item_text(selected))
	self.update_minimum_size()

func _on_focus_entered():
	_selected_text.label_settings = label_settings_focused if label_settings_focused else _default_label_settings

func _on_focus_exited():
	_selected_text.label_settings = null

func _on_mouse_entered():
	_selected_text.label_settings = label_settings_hover if label_settings_hover else _default_label_settings

func _on_mouse_exited():
	_selected_text.label_settings = null

func _on_pressed():
	_selected_text.label_settings = label_settings_pressed if label_settings_pressed else _default_label_settings

func _on_released():
	if self.has_focus():
		_on_focus_entered()
	else:
		_selected_text.label_settings = null

func _on_disabled():
	_selected_text.label_settings = label_settings_disabled if label_settings_disabled else _default_label_settings

func _on_enabled():
	_selected_text.label_settings = null


func _input(_event: InputEvent) -> void:
	if not self.has_focus(): return

	if Input.is_action_just_pressed('ui_left'):
		accept_event()
		_select_prev_item()
	elif Input.is_action_just_pressed('ui_right'):
		accept_event()
		_select_next_item()


func _select_next_item() -> void:
	selected += 1
	ui_item_selected.emit(selected)
	self.grab_focus()

func _select_prev_item() -> void:
	selected -= 1
	ui_item_selected.emit(selected)
	self.grab_focus()


func _item_selected(_index: int) -> void:
	pass
