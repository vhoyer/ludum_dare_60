@tool
class_name GameDice
extends Node2D


signal roll_finished()

signal _model_updated()

@export_group('private')


@export
var _rolling: bool = false

var _rolling_counter: float = 0

@export
var _rolling_frame_duration: float = 0.05


@export_range(0, 1)
var _height: float = 0:
	set(value):
		_height = value
		_model_updated.emit()


@export
var _dice_rising_time: float = 0.3


@export
var _light_direction: Vector2


@export_tool_button('roll')
var test_roll: Callable = func():
	roll(5)
	pass



@onready
var sprite_dice: Sprite2D = %DiceSprite

@onready
var sprite_shadow: Sprite2D = %DiceShadow



func _ready() -> void:
	_model_updated.connect(_update_view)
	_model_updated.emit()


func _update_view() -> void:
	sprite_dice.scale = Vector2.ONE * ((_height * 0.35) + 1)
	sprite_shadow.position = _light_direction * ((_height * 250) + 1)
	sprite_shadow.scale = Vector2.ONE / ((_height * 1) + 1)
	sprite_shadow.modulate.a = 1 - (_height * 0.75)


func _process(delta: float) -> void:
	_process_rolling(delta)


func roll(result: int) -> void:
	_rolling = true
	_rolling_counter = 0
	AudioEventBus.emit(AudioEventBus.DIE_ROLLING)

	var tween = self.create_tween()
	tween.set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "_height", 1, _dice_rising_time)
	tween.tween_property(self, "_height", 0, _dice_rising_time)
	tween.tween_callback(func():
		_rolling = false
		sprite_dice.frame = result - 1
		roll_finished.emit()
		AudioEventBus.emit(AudioEventBus.DIE_LANDED)
		pass)


func _process_rolling(delta: float) -> void:
	if not _rolling: return
	_rolling_counter += delta
	if _rolling_counter >= _rolling_frame_duration:
		_rolling_counter -= _rolling_frame_duration
		_randomize_side()


func _randomize_side() -> void:
	# can you imagine the randi() generates the same number 100 times in a row?
	# Might as well give the die that one
	for i in range(100):
		var new_frame = randi() % (sprite_dice.hframes * sprite_dice.vframes)
		if new_frame != sprite_dice.frame:
			sprite_dice.frame = new_frame
			break
