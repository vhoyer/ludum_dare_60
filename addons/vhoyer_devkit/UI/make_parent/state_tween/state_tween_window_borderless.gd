extends StateTween
class_name StateTweenWindowBorderless

func reset(_target: Node = null) -> void:
	super(_target)
	_target.get_window().borderless = true

func enter(tween: Tween) -> Tween:
	super(tween)
	
	tween.tween_callback(func():
		target.get_window().borderless = false)
	
	return tween

func exit(tween: Tween) -> Tween:
	super(tween)
	
	tween.tween_callback(func():
		target.get_window().borderless = true)
	
	return tween
