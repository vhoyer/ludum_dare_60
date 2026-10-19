extends Button


@export
var cursor: CursorResource


func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		GameCursor.instance.cursor = cursor

		cursor.hit_collisions.connect(_on_hit)
		cursor.aoe_collisions.connect(_on_aoe)
	else:
		GameCursor.instance.reset()
		cursor.hit_collisions.disconnect(_on_hit)
		cursor.aoe_collisions.disconnect(_on_aoe)


func _on_hit(_origin: Vector2, bodies: Array) -> void:
	for body: Node2D in bodies:
		if body is GameDice:
			SaveManager.data.points -= body.result
			body.destroy()


func _on_aoe(origin: Vector2, bodies: Array) -> void:
	for body: Node2D in bodies:
		if body is GameDice:
			SaveManager.data.points -= body.result
			body.roll(
				SaveManager.data.generate_dice_result(),
				origin.direction_to(body.global_position),
				200)
			body.roll_finished.connect(func(result):
				SaveManager.data.points += result
				pass, CONNECT_ONE_SHOT)
