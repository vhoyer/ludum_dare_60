extends BaseButton

func _pressed() -> void:
	get_tree().paused = false
	StageManager.reload_current_stage()
