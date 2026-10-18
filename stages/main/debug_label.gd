extends Label

func _ready() -> void:
	if !OS.is_debug_build():
		self.hide()
		return

	SaveManager.data.watch(self, ['points', 'current_level', 'roll_counter', 'dice_count'], func():
		self.text = "\n".join(["""
goal_min: {goal_min}
goal_max: {goal_max}
dice_starting_count: {dice_starting_count}
dice_size: {dice_size}
""".strip_edges().format(LevelsManager.current), """
points: {points}
dice_count: {dice_count}
roll_counter: {roll_counter}
current_level: {current_level}
""".strip_edges().format(SaveManager.data)])
		pass)
