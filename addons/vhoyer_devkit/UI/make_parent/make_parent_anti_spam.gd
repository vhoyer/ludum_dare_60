extends Node
class_name MakeParentAntiSpam

func _process(_delta: float) -> void:
	if not get_parent().is_visible_in_tree():
		get_parent().disabled = true
	else:
		await get_tree().create_timer(1.5).timeout
		get_parent().disabled = false
