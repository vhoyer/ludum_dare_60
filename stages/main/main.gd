extends Node


@onready
var dices_group: Node2D = %Dices

@onready
var tug_of_war: GameTugOfWar = %GameTugOfWar


func _on_roll_button_button_down() -> void:
	SaveManager.data.points = 0

	AudioEventBus.emit(AudioEventBus.Id.DICE_ROLL_REQUESTED)

	for dice: GameDice in dices_group.get_children():
		var value = randi() % 6 + 1
		dice.roll(value)
		SaveManager.data.points += value

	var max_points:= dices_group.get_child_count() * 6
	tug_of_war.value = SaveManager.data.points / float(max_points)
