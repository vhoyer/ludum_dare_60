@tool
class_name RadialMenu
extends Control

signal _model_updated()

@export
var menu_diameter: int = 65

@export
var pixel_factor: float = 5.0

var view_container: SubViewportContainer
var view: SubViewport
var renderer: RadialMenuRenderer


func _ready() -> void:
	self.custom_minimum_size = Vector2.ONE * pixel_factor * menu_diameter

	view_container = SubViewportContainer.new()
	view_container.name = 'view_container'
	view_container.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	view_container.size = Vector2i.ONE * menu_diameter
	view_container.pivot_offset = view_container.size / 2
	view_container.position = self.get_rect().get_center()
	view_container.scale = Vector2.ONE * pixel_factor
	view_container.set_anchors_and_offsets_preset(Control.PRESET_CENTER, Control.PRESET_MODE_KEEP_SIZE)
	self.add_child(view_container)

	view = SubViewport.new()
	view_container.add_child(view)
	view.name = 'view'
	view.size = Vector2i.ONE * menu_diameter
	view.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST

	renderer = RadialMenuRenderer.new()
	renderer.name = 'renderer'
	renderer.menu = self
	renderer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	renderer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	renderer.size = view.size
	view.add_child(renderer)
