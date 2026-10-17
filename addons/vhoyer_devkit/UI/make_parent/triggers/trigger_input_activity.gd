extends Trigger
class_name TriggerInputActivity

var timer: Timer

@export
var idle_timeout: float = 2


func setup(node: Node) -> void:
	timer = Timer.new()
	node.add_child(timer)
	timer.wait_time = idle_timeout
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

	self.enter.emit()


func _on_timer_timeout() -> void:
	self.exit.emit()


func on_input(_event: InputEvent) -> void:
	if not DisplayServer.window_is_focused(): return
	timer.start()
	self.enter.emit()


func set_paused(value: bool) -> void:
	timer.paused = value


func get_paused() -> bool:
	return timer.paused
