@tool
class_name TimerLabel
extends Label


signal timeout()


## in seconds
@export
var time: float = 600:
	set(value):
		time = value
		timer = value

@export
var timer: float = time:
	set(value):
		timer = value
		timer_diplay = VHDUtils.time_display(timer)
		if timer == 0.0:
			stop()
			timeout.emit()

var timer_diplay: String = VHDUtils.time_display(time)

@export
var timer_enabled:= false


@export
var autostart:= false


func _ready() -> void:
	self.text = timer_diplay

	if not Engine.is_editor_hint():
		if autostart:
			timer_enabled = true


func _process(delta: float) -> void:
	if timer_enabled and timer > 0:
		timer -= min(delta, timer)
	self.text = timer_diplay


func start(starting_time: float = time) -> void:
	timer = starting_time
	timer_enabled = true


func stop() -> void:
	timer_enabled = false
