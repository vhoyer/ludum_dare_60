@tool
extends ItemList
class_name ItemListSource

var selected_item: Variant

@export var source_label: String
@export var source_list: Array = []:
	set(value):
		source_list = value
		populate_items()

@export var is_disabled: bool:
	get():
		for idx in self.item_count:
			if !self.get("item_%d/disabled" % [idx]): return false
		return true
	set(value):
		for idx in self.item_count:
			self.set_item_disabled(idx, value)

## if this callable returns true when re-populating the source list, automatically selects that item
var source_is_default: Callable = func(item): return false
var source_is_disabled: Callable = func(item): return false
var source_is_selectable: Callable = func(item): return true

signal source_multi_selected(multi_selection: Array)
signal source_item_selected(item: Variant)
signal source_item_actived(item: Variant)

func _init():
	self.multi_selected.connect(_on_multi_selected)
	self.item_selected.connect(_on_item_selected)
	self.item_activated.connect(_on_item_actived)

func _on_multi_selected(_index: int, _selected: bool) -> void:
	var multi_selection = []
	for index in self.get_selected_items():
		multi_selection.push_back(source_list[index])
	source_multi_selected.emit(multi_selection)

func _on_item_selected(index: int) -> void:
	selected_item = source_list[index]
	source_item_selected.emit(selected_item)

func _on_item_actived(index: int) -> void:
	selected_item = source_list[index]
	source_item_actived.emit(selected_item)

func must_use_label() -> bool:
	return source_list.all(func(item): return ![
		TYPE_STRING,
	].has(typeof(item)))

func populate_items() -> void:
	assert(must_use_label() and source_label, 'Error: must use label!')
	self.clear()
	var default_item = source_list[0] if source_list.size() > 0 else null
	for index in source_list.size():
		var item = source_list[index]
		self.add_item(item[source_label] if source_label else item)
		self.set_item_disabled(index, source_is_disabled.call(item))
		self.set_item_selectable(index, source_is_selectable.call(item))
		if (source_is_default.call(item)):
			default_item = item
	
	var has_selection = selected_item and source_list.has(selected_item)
	if (default_item and not has_selection):
		self.select_item(default_item)
	elif (has_selection):
		self.select_item(selected_item)
	
	self.is_disabled

func select_item(what: Variant, find_method: Callable = (func(a, b): return a == b)) -> void:
	var specimen = source_list \
		.filter(func(a): return find_method.call(a, what)) \
		.pop_front()
		
	var index = source_list.find(specimen)
	self.select(index)
	self.ensure_current_is_visible()
	self.item_selected.emit(index)
