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

const TYPE_NORMAL = Type.NORMAL
const TYPE_PRESSED = Type.PRESSED


func apply(sprite: Sprite2D, type: Type) -> void:
	var new_texture: Texture2D
	var new_offset: Vector2

	match type:
		Type.NORMAL:
			new_texture = _normal
			new_offset = _normal_offset
		Type.PRESSED:
			new_texture = _pressed
			new_offset = _pressed_offset

	sprite.texture = new_texture
	sprite.offset = new_offset
