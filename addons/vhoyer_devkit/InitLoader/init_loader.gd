extends Node


@export_file("*.tscn", "*.scn")
var next_scene: String


@onready
var loader_holder: VBoxContainer = %LoaderHolder


const LOADER_SCENE = preload('uid://j5aw2e2pdy08')


func _ready() -> void:
	for id: String in VHDStatus._statuses:
		var loader = LOADER_SCENE.instantiate()
		loader.id = id
		loader_holder.add_child(loader)
		pass

	VHDStatus.status_changed.connect(_on_status_changed.unbind(2))
	_on_status_changed()



var done_timer: SceneTreeTimer

func _on_status_changed() -> void:
	if VHDStatus.all_ok():
		if not done_timer:
			if not OS.is_debug_build():
				done_timer = get_tree().create_timer(1)
				await done_timer.timeout
			StageManager.push_stage(next_scene)

