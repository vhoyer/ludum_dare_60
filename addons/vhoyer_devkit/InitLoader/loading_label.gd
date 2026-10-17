extends Label

@export var prepend_text: String = 'Loading'
var timer: Timer
var i: int = 1

func _ready() -> void:
	timer = Timer.new()
	self.add_child(timer)
	timer.wait_time = 0.5
	timer.autostart = true
	timer.one_shot = false
	timer.start()
	timer.timeout.connect(update_label)


func update_label() -> void:
	self.text = prepend_text + '.'.repeat(i)
	i += 1
	if i > 3:
		i = 1
