class_name GameCursor
extends Node2D


@export
var cursor: CursorResource


@onready
var _cursor_sprite: Sprite2D = %Cursor

@onready
var _particles: GPUParticles2D = %Particles


func _ready() -> void:
	cursor.apply(_cursor_sprite, CursorResource.TYPE_NORMAL)


func _process(_delta: float) -> void:
	self.position = get_viewport().get_mouse_position()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				cursor.apply(_cursor_sprite, CursorResource.TYPE_PRESSED)
				_impact()
			else:
				cursor.apply(_cursor_sprite, CursorResource.TYPE_NORMAL)

func _impact() -> void:
	VHDUtils.camera_2d_shake(self, 10, 0.2)
	_particles.restart()

