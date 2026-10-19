@tool
class_name GameDice
extends RigidBody2D

const ROTATION_RANGE = 18


signal roll_finished(result: int)

signal _model_updated()

@export_group('private')

var result: int

@export
var _rolling: bool = false

var _rolling_counter: float = 0

@export
var _rolling_frame_duration: float = 0.05


@export_range(0, 1)
var _height: float = 0:
	set(value):
		_height = clamp(value, 0, 1)
		if _height <= 0:
			AudioEventBus.emit(AudioEventBus.Id.DIE_LANDED)
		_model_updated.emit()


@export
var _dice_rising_time: float = 0.3


@export
var _light_direction: Vector2


@export_tool_button('roll')
var test_roll: Callable = func():
	roll(5)
	pass


@export_range(0.1, 2)
var size: float = 1:
	set(value):
		size = clamp(value, 0.1, 2)
		_model_updated.emit()


@onready
var visual_root: Node2D = %VisualRoot

@onready
var sprite_dice: Sprite2D = %DiceSprite

@onready
var sprite_shadow: Sprite2D = %DiceShadow

@onready
var collider: CollisionShape2D = %CollisionShape2D


var _initial_visual_root_scale: Vector2
var _initial_colider_radius: float

func _ready() -> void:
	_initial_visual_root_scale = visual_root.scale
	_initial_colider_radius = collider.shape.radius

	_model_updated.connect(_update_view)
	_model_updated.emit()


func _update_view() -> void:
	visual_root.scale = _initial_visual_root_scale * size
	collider.shape.radius = _initial_colider_radius * size

	sprite_dice.scale = Vector2.ONE * ((_height * 0.35) + 1)
	sprite_shadow.position = _light_direction.rotated(-1 * visual_root.rotation) * ((_height * 250) + 1)
	sprite_shadow.scale = Vector2.ONE / ((_height * 1) + 1)
	sprite_shadow.modulate.a = 1 - (_height * 0.75)


func _process(delta: float) -> void:
	_process_rolling(delta)


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if _height > 0.05: return

	state.apply_impulse(-1 * state.linear_velocity * 0.1)
	pass


func roll(roll_result: int, throw_direction:= Vector2.ZERO, throw_force:= 10.0) -> void:
	_rolling = true
	_rolling_counter = 0
	AudioEventBus.emit(AudioEventBus.Id.DIE_ROLLING)

	_randomize_rotation(_dice_rising_time * 10)

	_height = 1

	var tween = self.create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "_height", 0, _dice_rising_time * 10)
	tween.tween_callback(_finish_roll.bind(roll_result))

	self.apply_impulse(throw_direction.normalized() * throw_force)

func reroll(roll_result: int) -> void:
	_rolling = true
	_rolling_counter = 0
	AudioEventBus.emit(AudioEventBus.Id.DIE_ROLLING)

	_randomize_rotation(_dice_rising_time * 2)

	var tween = self.create_tween()
	tween.set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "_height", 1, _dice_rising_time)
	tween.tween_property(self, "_height", 0, _dice_rising_time)
	tween.tween_callback(_finish_roll.bind(roll_result))


func _finish_roll(roll_result: int) -> void:
	_rolling = false
	sprite_dice.frame = roll_result - 1
	result = roll_result
	roll_finished.emit(roll_result)


func _randomize_rotation(duration: float) -> void:
	var tween_rotation = self.create_tween()
	tween_rotation.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween_rotation.tween_property(
		visual_root,
		"rotation_degrees",
		(randf() * ROTATION_RANGE * 2 - ROTATION_RANGE),
		duration)



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


var is_destroying: bool = false

func destroy() -> void:
	is_destroying = true
	AudioEventBus.emit(AudioEventBus.Id.DIE_DESTROY)
	%VisualRoot.hide()
	%Shatter.restart()
	await %Shatter.finished
	self.queue_free()
