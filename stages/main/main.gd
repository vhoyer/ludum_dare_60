extends Node

const GAME_DICE_SCENE = preload('uid://cvf0j1cif853i')


@onready
var dices_group: Node2D = %Dices

@onready
var dice_spawn: Node2D = %DiceSpawn

@onready
var tug_of_war: GameTugOfWar = %GameTugOfWar


@export_group('throw', '_throw')
@export
var _throw_direction: Vector2

@export
var _throw_direction_variation_rad: float = 0.1

@export
var _throw_force: float

@export
var _throw_inbetween_interval: float = 0.3


func _ready() -> void:
	SaveManager.data.watch(self, ['points', 'current_level'], func():
		tug_of_war.value = SaveManager.data.points / LevelsManager.current.goal
		pass)


func _on_roll_button_button_down() -> void:
	VHDUtils.remove_children(dices_group)

	SaveManager.data.points = 0

	AudioEventBus.emit(AudioEventBus.Id.DICE_ROLL_REQUESTED)

	for _i: int in SaveManager.data.dice_count:
		var dice = GAME_DICE_SCENE.instantiate()
		dices_group.add_child(dice)
		dice.global_position = dice_spawn.global_position

		var value = randi() % 6 + 1

		dice.roll(
			value,
			_throw_direction.rotated(randf() * _throw_direction_variation_rad * 2 - _throw_direction_variation_rad),
			_throw_force)

		dice.roll_finished.connect(func():
			SaveManager.data.points += value
			pass,
			CONNECT_ONE_SHOT)

		await self.get_tree().create_timer(_throw_inbetween_interval).timeout


func _on_hit_table_button_button_down() -> void:
	SaveManager.data.points = 0

	for dice: GameDice in dices_group.get_children():
		var value = randi() % 6 + 1
		dice.reroll(value)

		dice.roll_finished.connect(func():
			SaveManager.data.points += value
			pass,
			CONNECT_ONE_SHOT)
