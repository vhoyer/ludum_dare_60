@tool
class_name Stopwatch
extends Label

@export
var stopwatch: float = 0.0:
	set(value):
		stopwatch = value

		var h = floor(stopwatch / 3600)
		var mins = fmod(stopwatch, 3600) / 60
		var s = fmod(stopwatch, 60)
		var ms = fmod(stopwatch, 1) * 1000
		stopwatch_diplay = "%02d:%02d:%02d.%03d" % [h, mins, s, ms]

var stopwatch_diplay: String

@export
var stopwatch_enabled:= false



func _ready() -> void:
	self.text = stopwatch_diplay


func _process(delta: float) -> void:
	if stopwatch_enabled:
		stopwatch += delta
	self.text = stopwatch_diplay


func stopwatch_begin() -> void:
	stopwatch = 0
	stopwatch_enabled = true


func stopwatch_end() -> String:
	stopwatch_enabled = false
	return stopwatch_diplay
