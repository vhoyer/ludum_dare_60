@tool
class_name MakeParentBlink
extends Node

signal _model_updated()


@export
var enabled:= true:
	set(value):
		enabled = value
		_elapsed = 0
		if enabled:
			# call setter again
			cycle_repeat_count = cycle_repeat_count
		_model_updated.emit()


@export
var autostart:= false


@export
var cycle_time:= 1.5:
	set(value):
		cycle_time = value


@export_range(0, 10, 1, "or_greater")
## 0 means it will never stop;
var cycle_repeat_count: int = 0:
	set(value):
		cycle_repeat_count = value
		_cycle_count = -1 if value <= 0 else value


@export
var modulate_map: Gradient:
	get():
		if not modulate_map:
			modulate_map = Gradient.new()
			modulate_map.interpolation_mode = Gradient.GRADIENT_INTERPOLATE_CONSTANT
			modulate_map.colors = PackedColorArray()
			modulate_map.offsets = PackedFloat32Array()
			modulate_map.add_point(0.0, Color(1, 1, 1, 1))
			modulate_map.add_point(0.5, Color(1, 1, 1, 0))
		return modulate_map


var parent: Control

## -1 means it IS INFINITE;
## 0 means it IS STOPPED;
var _cycle_count: int:
	set(value):
		_cycle_count = value
		# if count = 0, reset everything
		var should_stop:= _cycle_count == 0
		if should_stop:
			enabled = false
			_elapsed = 0

var _elapsed: float = 0.0:
	set(value):
		_elapsed = value
		_model_updated.emit()

var _gradient_offset: float:
	get(): return remap(_elapsed, 0.0, cycle_time, 0.0, 1.0)


func _ready() -> void:
	parent = self.get_parent()

	if autostart:
		enabled = true

	_model_updated.connect(_update_view)
	_model_updated.emit()


func _update_view() -> void:
	if not parent:
		VHDLogger.scope('MakeBlink').error('wtf? no parent?')
		return

	self.set_process(enabled)
	parent.modulate = modulate_map.sample(_gradient_offset)


func _process(delta: float) -> void:
	_elapsed += delta

	if _elapsed >= cycle_time:
		_elapsed -= cycle_time

		if _cycle_count <= 0: return
		_cycle_count -= 1


func start() -> void:
	enabled = true
