@tool
class_name GameTugOfWar
extends Control


signal _model_updated()


## value of progress from 0 to 1 (0 = enemy win, 1 = player win)
@export_range(0, 1)
var value: float = 0.5:
	set(v):
		value = v
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

@export
var _jitter_range: float = 25:
	set(value):
		_jitter_range = value
		_model_updated.emit()



@onready
var fill_bar: Control = %Fill

@onready
var _jitter_scheduler: Timer = %JitterScheduler


func _ready() -> void:
	_model_updated.connect(_update_view)
	_model_updated.emit()


func _update_view() -> void:
	fill_bar.position.y = (self.size.y - _fill_margin * 2) * value + _fill_margin + _jitter


func _on_jitter_scheduler_timeout() -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, '_jitter', randf() * _jitter_range * 2 - _jitter_range, _jitter_scheduler.wait_time)
