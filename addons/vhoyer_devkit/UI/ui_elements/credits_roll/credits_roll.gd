@tool
class_name CreditsRoll
extends ScrollContainer

signal _model_updated()
signal finished()

@export
var pixels_per_second: float = 100

@export
var mouse_wheel_scroll_enabled: bool = false

@export
var pixels_per_scroll_wheel_input: float = 32

@export
var auto_scroll_enabled: bool = true

@export_group('editor')

@export
var preview_margin: int = 16:
	set(value):
		preview_margin = value
		_model_updated.emit()


@onready
var _scrolling_margin:= self.get_node_or_null(^'ScrollingMargin')

@onready
var _vertical_margin: int:
	get():
		if Engine.is_editor_hint():
			return preview_margin
		else:
			return int(self.size.y)

@onready
var _scrollbar: VScrollBar = self.get_v_scroll_bar()


func _init() -> void:
	self.ready.connect(_on_ready)
	self.child_entered_tree.connect(update_configuration_warnings.unbind(1))
	self.child_exiting_tree.connect(update_configuration_warnings.unbind(1))


func _get_configuration_warnings() -> PackedStringArray:
	var warns = PackedStringArray()
	for child: Node in self.get_children():
		if child != _scrolling_margin:
			warns.push_back('All children must be placed under the "ScrollingMargin" node')
			break
	return warns


func _on_ready() -> void:
	self.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	self.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER

	if not _scrolling_margin:
		_scrolling_margin = MarginContainer.new()
		_scrolling_margin.name = 'ScrollingMargin'
		self.add_child(_scrolling_margin)
		_scrolling_margin.owner = self.owner

	_scrolling_margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_scrolling_margin.size_flags_vertical = Control.SIZE_EXPAND_FILL

	self.item_rect_changed.connect(_update_view)
	if mouse_wheel_scroll_enabled:
		self.gui_input.connect(_on_gui_input)
	_model_updated.connect(_update_view)
	_update_view()


func _update_view() -> void:
	_scrolling_margin.add_theme_constant_override('margin_top', _vertical_margin)
	_scrolling_margin.add_theme_constant_override('margin_bottom', _vertical_margin)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_released():
			return
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_scroll_accumulator += pixels_per_scroll_wheel_input
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_scroll_accumulator -= pixels_per_scroll_wheel_input


var _scroll_accumulator: float = 0:
	set(value):
		_scroll_accumulator = clamp(value, 0, _scrolling_margin.size.y)


func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	if not auto_scroll_enabled: return

	_scroll_accumulator += pixels_per_second * delta
	self.scroll_vertical = int(_scroll_accumulator)

	if (_scrollbar.value + _scrollbar.page) == _scrollbar.max_value:
		auto_scroll_enabled = false
		finished.emit()


func reset_scroll() -> void:
	_scroll_accumulator = 0
	auto_scroll_enabled = true
