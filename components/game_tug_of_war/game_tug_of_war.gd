@tool
class_name GameTugOfWar
extends Control


signal _model_updated()
signal end_animation_finished()


## value of progress from 0 to 1 (0 = enemy win, 1 = player win)
@export_range(0, 1)
var value: float = 0.5:
	set(v):
		value = clamp(v, 0, 1)

		if _value_tween: _value_tween.kill()
		_value_tween = self.create_tween()
		_value_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
		_value_tween.tween_property(self, '_value_but_real', value, 0.15)

var _value_tween: Tween

var _value_but_real: float = 0.5:
	set(value):
		_value_but_real = value
		_model_updated.emit()

@export_group('private')

@export
var _fill_margin: float = 100:
	set(value):
		_fill_margin = value
		_model_updated.emit()

var _jitter: float = 0:
	set(value):
		_jitter = value
		_model_updated.emit()

var _offset: float = 0:
	set(value):
		_offset = value
		_model_updated.emit()

@export
var _jitter_range: float = 25:
	set(value):
		_jitter_range = value
		_model_updated.emit()


@export_tool_button('win')
var tool_win: Callable = func():
	win()
	pass

@export_tool_button('lose')
var tool_lose: Callable = func():
	lose()
	pass

@export_tool_button('reset')
var tool_reset: Callable = func():
	reset()
	pass


@onready
var fill_bar: Control = %Fill

@onready
var _content: Control = %Content

@onready
var _jitter_scheduler: Timer = %JitterScheduler


@onready
var player: MarginContainer = %Player


@onready
var enemy: MarginContainer = %Enemy



func _ready() -> void:
	_model_updated.connect(_update_view)
	_model_updated.emit()


func _update_view() -> void:
	fill_bar.position.y = (self.size.y - _fill_margin * 2) * _value_but_real + _fill_margin + _jitter - _offset


func _on_jitter_scheduler_timeout() -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, '_jitter', randf() * _jitter_range * 2 - _jitter_range, _jitter_scheduler.wait_time)


var _original_jitter_range: float
var _original_fill_margin: float

func _let_go(target: MarginContainer, margin: StringName) -> void:
	_original_jitter_range = _jitter_range
	_original_fill_margin = _fill_margin
	_jitter_range = 0
	_fill_margin = 0

	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_method(func(val: int):
		target.add_theme_constant_override(margin, val)
		_content.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
		pass, 0, 600, 0.4)

	await tween.finished
	end_animation_finished.emit()


func win() -> void:
	_let_go(enemy, 'margin_bottom')

func lose() -> void:
	_let_go(player, 'margin_top')

func reset() -> void:
	enemy.add_theme_constant_override('margin_top', 0)
	enemy.add_theme_constant_override('margin_bottom', 0)
	player.add_theme_constant_override('margin_top', 0)
	player.add_theme_constant_override('margin_bottom', 0)
	_jitter_range = _original_jitter_range
	_fill_margin = _original_fill_margin
	_offset = 0
	_content.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
