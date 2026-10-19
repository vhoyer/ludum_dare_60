extends Node

const GAME_DICE_SCENE = preload('uid://cvf0j1cif853i')


@onready
var dices_group: Node2D = %Dices

@onready
var dice_spawn: Node2D = %DiceSpawn

@onready
var goal_gauge: Label = %GoalGauge

@onready
var tug_of_war: GameTugOfWar = %GameTugOfWar

@onready
var rolls_label: Label = %RollsLabel


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
	var goal_gauge_model:= goal_gauge.text
	var labels_model:= rolls_label.text

	SaveManager.data.watch(self, ['points', 'current_level'], func():
		tug_of_war.value = SaveManager.data.points / LevelsManager.current.goal_min
		goal_gauge.text = goal_gauge_model.format(SaveManager.data).format(LevelsManager.current)
		pass)

	SaveManager.data.watch(self, ['roll_counter', 'current_level'], func():
		rolls_label.text = labels_model % [SaveManager.data.roll_counter, LevelsManager.current.max_rolls]
		%RollButton.disabled = (SaveManager.data.roll_counter >= LevelsManager.current.max_rolls)
		%SubmitButton.disabled = SaveManager.data.roll_counter <= 0
		pass)


func _on_roll_button_button_down() -> void:
	VHDUtils.remove_children(dices_group)
	AudioEventBus.emit(AudioEventBus.Id.DICE_ROLL_REQUESTED)
	SaveManager.data.roll_counter += 1

	var points: int = 0

	for _i: int in SaveManager.data.dice_count:
		var dice: GameDice = GAME_DICE_SCENE.instantiate()
		dices_group.add_child(dice)
		dice.global_position = dice_spawn.global_position
		dice.size = LevelsManager.current.dice_size

		var value = SaveManager.data.generate_dice_result()

		dice.roll(
			value,
			_throw_direction.rotated(randf() * _throw_direction_variation_rad * 2 - _throw_direction_variation_rad),
			_throw_force)

		await self.get_tree().create_timer(_throw_inbetween_interval).timeout

	for dice: GameDice in dices_group.get_children():
		points += await dice.roll_finished

	SaveManager.data.points = points



func _on_hit_table_button_button_down() -> void:
	var points: int = 0

	for dice: GameDice in dices_group.get_children():
		var value = SaveManager.data.generate_dice_result()
		dice.reroll(value)

	for dice: GameDice in dices_group.get_children():
		points += await dice.roll_finished

	SaveManager.data.points = points


func _on_submit_button_button_down() -> void:
	%PreventInteraction.show()

	if LevelsManager.current.is_goal_met():
		AudioEventBus.emit(AudioEventBus.Id.HUMAN_PULL_WIN_GRUNT)
		tug_of_war.win()

		await tug_of_war.end_animation_finished
		LevelsManager.next_level()
		if LevelsManager.is_complete:
			StageManager.push_stage('uid://dfeemruwqkcvk')
		else:
			StageManager.reload_current_stage()
	else:
		AudioEventBus.emit(AudioEventBus.Id.HUMAN_PULL_LOSE_GRUNT)
		tug_of_war.lose()
		await tug_of_war.end_animation_finished
		StageManager.push_stage('uid://cah01bitodg5j')
