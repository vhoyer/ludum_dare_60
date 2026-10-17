## This Node should be the root node of the main scene project
# class_name StageManager
extends Node


#region Public API

## gets payload data from previous stage to the current one, can be set using
## `set_payload` function. This can also be called in the same stage the set
## function was called.
func get_payload(key, default = null):
	var pay = _payloads
	if !pay.has(key): return default
	var value = pay[key]
	pay.erase(key)
	return value

## set payload data from one stage to the next one, can be retrieved using `get_payload` function
func set_payload(key, value):
	_payloads[key] = value
	payload_updated.emit(key)


## changes current stage to a duplicate of the previous one
func go_back(index: int = 1, payload_append = {}):
	_current_cursor -= index

	var cur_index = _current_cursor
	var cur_history_entry = _history[cur_index]
	_payloads = cur_history_entry.payloads.duplicate(true)
	_payloads.merge(payload_append, true)
	_update_current_stage()

## reload the current stage
func reload_current_stage(payload_append = {}) -> void:
	go_back(0, payload_append)

## change stage to a new scene, going through the loading screen in the middle;
## handles game pause state in between stages
func push_stage(scene: String, payload_append = {}) -> void:
	if _loading:
		push_error("Stage Manager: Can't request change on stage while another change is already in progress")
		return

	_payloads.merge(payload_append, true)
	_change_stage_to_file(scene)

## go to the first main stage, the starting one
func go_to_start(payload_append = {}) -> void:
	_current_cursor = 0

	var cur_history_entry = _history[0]
	_payloads = cur_history_entry.payloads.duplicate(true)
	_payloads.merge(payload_append, true)
	_update_current_stage()

## register one off functions to execute when the new scene has already loaded,
## but the loading screen has yet to be dismissed
func do_on_load_screen_callbacks(fn: Callable) -> void:
	_on_load_screen_callbacks.push_back(fn)


#endregion



signal payload_updated(key: Variant)
## Stage finished loading on the tree, but transition may not be finished
signal stage_changed()
## Tree Resumed stage has full control of the scene
signal stage_change_finished()
signal _stage_loaded(stage: PackedScene)

var current_stage: Node:
	get():
		return get_tree().current_scene

var _on_load_screen_callbacks: Array[Callable] = []

var _payloads: Dictionary = {}

var _history: Array[HistoryEntry] = []
var _current_cursor: int = 0
var _current_history: HistoryEntry:
	get():
		return _history[_current_cursor]


var _loading: bool = false
var _loading_status: ResourceLoader.ThreadLoadStatus
var _loading_progress: Array = []
var _loading_tween: Tween

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS

	var main_stage = ProjectSettings.get_setting('application/run/main_scene')
	if main_stage:
		_append_to_history(main_stage)
		_current_cursor += 1
	_append_to_history(get_tree().current_scene.scene_file_path)

	setup_transition_layer()


func _process(_delta: float) -> void:
	if not _loading: return
	_load_step()


func _load_begin() -> PackedScene:
	_loading = true
	ResourceLoader.load_threaded_request(_current_history.stage_file)

	var tween = tween_stage_out()
	var stage = await _stage_loaded

	if tween.is_running():
		await tween.finished

	return stage

func _load_step() -> void:
	_loading_status = ResourceLoader.load_threaded_get_status(
		_current_history.stage_file,
		_loading_progress)

	match _loading_status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			# nothing to see here, everyone, keep going
			pass
		ResourceLoader.THREAD_LOAD_LOADED:
			_load_done()
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE, \
		ResourceLoader.THREAD_LOAD_FAILED:
			push_error('Error: Scene failed to load or is invalid')

func _load_done() -> void:
	var stage: PackedScene = ResourceLoader.load_threaded_get(_current_history.stage_file)

	_loading = false
	_loading_progress = []
	_loading_status = ResourceLoader.THREAD_LOAD_INVALID_RESOURCE

	_stage_loaded.emit(stage)


func _append_to_history(path):
	_history.append(HistoryEntry.new(path, _payloads.duplicate(true)))


func _change_stage_to_file(scene: String) -> void:
	if _current_cursor != _history.size() - 1:
		_history.resize(_current_cursor + 1)

	_append_to_history(scene)
	_current_cursor += 1
	_update_current_stage()


func _update_current_stage() -> void:
	var tree:= get_tree()
	tree.paused = true

	var stage = await _load_begin()

	tree.change_scene_to_packed(stage)
	await tree.tree_changed

	stage_changed.emit()

	while _on_load_screen_callbacks.size():
		var fn: Callable = _on_load_screen_callbacks.pop_front()
		await fn.call()


	if current_stage.has_method('_stage_load_step'):
		await current_stage._stage_load_step()

	await tween_stage_in().finished

	tree.paused = false

	stage_change_finished.emit()


var transition_scene: Node

func setup_transition_layer() -> void:
	if VHDSettings.transition_scene:
		var loaded = load(VHDSettings.transition_scene)
		if not loaded:
			push_error('[StageManager]: Transition Scene on Project Settings are invalid')
			return
		transition_scene = loaded.instantiate()
		transition_scene.hide()
		self.add_child(transition_scene)

func tween_stage_out() -> Tween:
	_loading_tween = create_tween()

	var default_transition:= func default_stage_out() -> void:
		if not transition_scene: return
		if not transition_scene.has_method('_stage_out'):
			push_error('[StageManager]: Transition Scene needs to implement _stage_out')
		transition_scene.show()
		transition_scene._stage_out(_loading_tween)

	if current_stage.has_method('_stage_out'):
		current_stage._stage_out(_loading_tween, default_transition)
	else:
		default_transition.call()

	return _loading_tween

func tween_stage_in() -> Tween:
	_loading_tween = create_tween()

	var default_transition:= func default_stage_in() -> void:
		if not transition_scene: return
		if not transition_scene.has_method('_stage_in'):
			push_error('[StageManager]: Transition Scene needs to implement _stage_in')
		transition_scene.show()
		transition_scene._stage_in(_loading_tween)
		await _loading_tween.finished
		transition_scene.hide()

	if current_stage.has_method('_stage_in'):
		if transition_scene:
			# if there is a transition_scene, make sure it's hidden at the
			# start of _stage_in
			transition_scene.hide()

		current_stage._stage_in(_loading_tween, default_transition)
	else:
		default_transition.call()

	return _loading_tween



class HistoryEntry:
	var stage_file: String
	var payloads: Dictionary
	func _init(lstage_file, lpayloads):
		self.stage_file = lstage_file
		self.payloads = lpayloads
