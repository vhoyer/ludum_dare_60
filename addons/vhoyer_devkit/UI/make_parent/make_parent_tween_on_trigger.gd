extends Node
class_name MakeParentTweenOnTrigger

@export
var trigger: Trigger = Trigger.new()

@export
var tween: StateTween

var paused: bool:
	get():
		return trigger.paused
	set(value):
		trigger.paused = value

func _ready() -> void:
	tween.reset(self.get_parent())
	trigger.setup(self)
	trigger.enter.connect(enter)
	trigger.exit.connect(exit)

func _input(event: InputEvent) -> void:
	trigger.on_input(event)

## old: appear
func enter() -> Tween:
	return tween.enter(create_tween())

## old: disappear
func exit() -> Tween:
	return tween.exit(create_tween())
