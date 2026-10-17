extends Resource
class_name StateTween

var target: Node:
	set(value):
		if value == null: return
		target = value

var current_tween: Tween

func reset(_target: Node = null) -> void:
	self.target = _target
	self.target.tree_exiting.connect(func():
		if current_tween:
			current_tween.kill())

func enter(tween: Tween) -> Tween:
	if current_tween and current_tween.is_running():
		current_tween.kill()
	current_tween = tween
	return tween

func exit(tween: Tween) -> Tween:
	if current_tween and current_tween.is_running():
		current_tween.kill()
	current_tween = tween
	return tween
