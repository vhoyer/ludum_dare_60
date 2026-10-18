extends Node


@onready
var dices_group: Node2D = %Dices


func _on_roll_button_button_down() -> void:
	AudioEventBus.emit(AudioEventBus.Id.DICE_ROLL_REQUESTED)

	for dice: GameDice in dices_group.get_children():
		dice.roll(randi() % 5 + 1)
