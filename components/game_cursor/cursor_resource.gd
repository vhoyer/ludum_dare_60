class_name CursorResource
extends Resource


@export_group('normal')
@export
var _normal: Texture2D

@export
var _normal_offset: Vector2

@export_group('pressed')
@export
var _pressed: Texture2D

@export
var _pressed_offset: Vector2


enum Type {
	NORMAL,
	PRESSED,
}


func apply(sprite: Sprite2D, type: Type) -> void:
	match type:
		Type.NORMAL:
			sprite.texture = _normal
			sprite.offset = _normal_offset
		Type.PRESSED:
			sprite.texture = _pressed
			sprite.offset = _pressed_offset
