# class_name CheatSystem
extends Control


signal requested_stage_next()
signal requested_stage_previous()


var _layer_enabled: bool = false


const CHEAT_LAYER = 'vhoyer_devkit_cheat_layer'
const CHEAT_SCREENSHOT = 'vhoyer_devkit_cheat_screenshot'
const CHEAT_TOGGLE_FRAME_STEPPING = 'vhoyer_devkit_cheat_toggle_frame_stepping'
const CHEAT_FRAME_STEP = 'vhoyer_devkit_cheat_frame_step'
const CHEAT_STAGE_RELOAD = 'vhoyer_devkit_cheat_stage_reload'
const CHEAT_STAGE_NEXT = 'vhoyer_devkit_cheat_stage_next'
const CHEAT_STAGE_PREV = 'vhoyer_devkit_cheat_stage_prev'

var _input_actions:= {
	CHEAT_LAYER: [{
		'type': InputEventKey,
		'keycode': KEY_F3,
	}],
	CHEAT_SCREENSHOT: [{
		'type': InputEventKey,
		'keycode': KEY_F2,
	}],
	CHEAT_TOGGLE_FRAME_STEPPING: [{
		'type': InputEventKey,
		'keycode': KEY_K,
	}, {
		'type': InputEventKey,
		'keycode': KEY_UP,
	}],
	CHEAT_FRAME_STEP: [{
		'type': InputEventKey,
		'keycode': KEY_L,
	}, {
		'type': InputEventKey,
		'keycode': KEY_RIGHT,
	}],
	CHEAT_STAGE_RELOAD: [{
		'type': InputEventKey,
		'keycode': KEY_F5,
	}],
	CHEAT_STAGE_NEXT: [{
		'type': InputEventKey,
		'keycode': KEY_N,
	}],
	CHEAT_STAGE_PREV: [{
		'type': InputEventKey,
		'keycode': KEY_P,
	}],
}


var logger:= VHDLogger.scope('Cheat')


func _init() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	_register_cutom_actions()


func _register_cutom_actions() -> void:
	for id: String in _input_actions.keys():
		if InputMap.has_action(id): continue
		InputMap.add_action(id)
		for event: Dictionary in _input_actions.get(id):
			if not event.has('type'):
				push_error('Action has no type')
				continue

			var key_event = event.get('type').new()
			if event.has('keycode'):
				key_event.keycode = event.get('keycode')

			InputMap.action_add_event(id, key_event)


func _exit_tree() -> void:
	# unregistering the custom actions
	for id: String in _input_actions.keys():
		if InputMap.has_action(id):
			InputMap.erase_action(id)


func _input(event: InputEvent) -> void:
	if not OS.is_debug_build():
		# do not execute this function if not on debug mode
		return

	if event.is_action_pressed(CHEAT_LAYER):
		_layer_enabled = true
	elif event.is_action_released(CHEAT_LAYER):
		_layer_enabled = false

	if not _layer_enabled:
		return

	if Input.is_action_just_pressed(CHEAT_SCREENSHOT):
		screenshot()
		self.accept_event()
	elif Input.is_action_just_pressed(CHEAT_TOGGLE_FRAME_STEPPING):
		var frame_stepping := self.get_node_or_null(^"frame_stepping")
		if !frame_stepping:
			self.add_child(FrameStepping.new())
			logger.info('Frame Stepping enabled')
		else:
			frame_stepping.queue_free()
			logger.info('Frame Stepping disabled')
		self.accept_event()
	elif Input.is_action_just_pressed(CHEAT_STAGE_RELOAD):
		StageManager.reload_current_stage()
	elif Input.is_action_just_pressed(CHEAT_STAGE_NEXT):
		requested_stage_next.emit()
	elif Input.is_action_just_pressed(CHEAT_STAGE_PREV):
		requested_stage_previous.emit()


func screenshot(sub_folder: String = "") -> void:
	var img:= get_viewport().get_texture().get_image()

	var basedir:= OS.get_system_dir(OS.SYSTEM_DIR_PICTURES)
	var timestring:= Time.get_datetime_string_from_system().replace(':', '-')

	var project_name:= ProjectSettings.get_setting_with_override('application/config/name') as String
	var token_project_name:= VHDUtils.to_safe_filename(project_name)

	var filename:= "%s-%s.png" % [token_project_name, timestring]

	var dir:= "%s/%s" % [basedir, token_project_name]
	if not sub_folder.is_empty():
		dir = "%s/%s" % [dir, sub_folder]
	var filepath:= "%s/%s" % [dir, filename]

	DirAccess.make_dir_recursive_absolute(dir)
	img.save_png(filepath)

	logger.info('Screenshot saved to path "%s"' % filepath)


class FrameStepping extends Node:
	func _init() -> void:
		self.name = 'frame_stepping'
		self.process_mode = PROCESS_MODE_ALWAYS
	func _exit_tree() -> void:
		get_tree().paused = false
	func _process(_delta: float) -> void:
		var tree:= get_tree()
		if !tree.paused:
			await tree.process_frame
			tree.paused = true
		else:
			if Input.is_action_just_pressed(CHEAT_FRAME_STEP):
				tree.paused = false
			elif Input.is_action_just_pressed(CHEAT_TOGGLE_FRAME_STEPPING):
				self.queue_free()
			elif Input.is_action_just_pressed(CHEAT_SCREENSHOT):
				self.get_parent().screenshot()
