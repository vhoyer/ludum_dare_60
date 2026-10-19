extends CanvasLayer


@onready
var _color_rect: ColorRect = %ColorRect


@export
var duration: float = 0.4


func _set_progress(value: float) -> void:
	_color_rect.material.set_shader_parameter('progress', value)


func _stage_out(tween: Tween) -> void:
	tween.tween_callback(func():
		_color_rect.material.set_shader_parameter('invert', false))
	tween.tween_method(_set_progress, 0.0, 1.1, duration)


func _stage_in(tween: Tween) -> void:
	tween.tween_callback(func():
		_color_rect.material.set_shader_parameter('invert', true))
	tween.tween_method(_set_progress, 0.0, 1.1, duration)
