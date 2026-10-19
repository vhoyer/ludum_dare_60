class_name GameCursor
extends Node2D


static var instance: GameCursor


signal _model_updated()


@export
var _default_cursor: CursorResource


var cursor: CursorResource:
	get():
		if override_cursor:
			return override_cursor
		return cursor
	set(value):
		cursor = value
		_model_updated.emit()

var override_cursor: CursorResource:
	set(value):
		override_cursor = value
		_model_updated.emit()


var _pressed: bool = false:
	set(value):
		_pressed = value
		_model_updated.emit()

@onready
var sprite: Sprite2D = %Cursor

@onready
var _aoe_area: Area2D = %AoEArea

@onready
var _hit_area: Area2D = %HitArea

@onready
var _particles: GPUParticles2D = %Particles


func _ready() -> void:
	if instance:
		push_warning('You should just have one GameCursor loaded at a time')
	instance = self

	cursor = _default_cursor

	_model_updated.connect(_update_view)
	_model_updated.emit()


func _update_view() -> void:
	if _pressed:
		cursor.apply(self, CursorResource.Type.PRESSED)
		cursor.hit_collisions.emit(self.global_position, _hit_area.get_overlapping_bodies())
		cursor.aoe_collisions.emit(self.global_position, _aoe_area.get_overlapping_bodies())
	else:
		cursor.apply(self, CursorResource.Type.NORMAL)


func _process(_delta: float) -> void:
	self.position = get_viewport().get_mouse_position()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_pressed = event.is_pressed()


func _effect_impact() -> void:
	VHDUtils.camera_2d_shake(self, 10, 0.2)
	_particles.restart()


func reset() -> void:
	cursor = _default_cursor
