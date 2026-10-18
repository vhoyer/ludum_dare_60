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

@export
var _pressed_sound: AudioEventBus.Id

@export_enum('none', 'impact')
var _pressed_effect: String = 'none'


enum Type {
	NORMAL,
	PRESSED,
}


func apply(cursor: GameCursor, type: Type) -> void:
	match type:
		Type.NORMAL:
			cursor.sprite.texture = _normal
			cursor.sprite.offset = _normal_offset

		Type.PRESSED:
			cursor.sprite.texture = _pressed
			cursor.sprite.offset = _pressed_offset

			AudioEventBus.emit(_pressed_sound)

			if cursor.has_method('_effect_%s' % _pressed_effect):
				cursor.call('_effect_%s' % _pressed_effect)
