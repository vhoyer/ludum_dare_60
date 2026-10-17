extends CanvasLayer


@onready
var _color_rect: ColorRect = %ColorRect


@export
var duration: float = 0.4


var _progress_max: float:
	get():
		var donno = ceil(_grid) * _progress_bias
		return donno.x + donno.y


var _grid: Vector2:
	get():
		return _color_rect.material.get_shader_parameter('grid_size')


var _screen: Vector2:
	get():
		return get_viewport().get_visible_rect().size


var _progress_bias: Vector2:
	get():
		return (_color_rect.material.get_shader_parameter('progress_bias')) / 10


func _set_progress(value: float) -> void:
	_color_rect.material.set_shader_parameter('progress', value * _progress_max)


func _adjust_grid_size_based_on_screen_aspect() -> void:
	var grid_size:= _grid
	grid_size.x = _grid.y * _screen.aspect()
	_color_rect.material.set_shader_parameter('grid_size', grid_size)


func _stage_out(tween: Tween) -> void:
	_adjust_grid_size_based_on_screen_aspect()

	tween.tween_callback(func():
		_color_rect.material.set_shader_parameter('invert', true))
	tween.tween_method(_set_progress, 0.0, 1.0, duration)


func _stage_in(tween: Tween) -> void:
	_adjust_grid_size_based_on_screen_aspect()

	tween.tween_callback(func():
		_color_rect.material.set_shader_parameter('invert', false))
	tween.tween_method(_set_progress, 0.0, 1.0, duration)
