class_name StageChanger
extends Node
## this node is meant to be used as a target destination for a
## event emit, just connect whatever event to "trigger_stage_change"
## and you are set, the function will ignore any parameter its given
## and just run

@export_file("*.tscn", "*.scn")
var scene_file: String


func trigger_stage_change(..._args) -> void:
	StageManager.push_stage(scene_file)
