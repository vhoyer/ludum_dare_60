class_name VHDUtils


static func remove_children(node: Node, include_internal: bool = false):
	var free_me_later = []

	if node.is_inside_tree():
		for child in node.get_children(include_internal):
			node.remove_child(child)
			free_me_later.push_back(child)
		await node.get_tree().process_frame
	else:
		free_me_later = node.get_children(include_internal)

	for child: Node in free_me_later:
		child.queue_free()


static func to_token_name(original: String) -> String:
	return original.to_lower()\
		.replace('!', '')\
		.replace('.', '')\
		.replace(',', '')\
		.replace('/', '')\
		.replace('(', '')\
		.replace(')', '')\
		.replace(' ', '_')


static func to_safe_filename(unsafe_name: String) -> String:
	var safe_name: String = unsafe_name
	var unsafe_chars: PackedStringArray = ["/", "\\", ":", "*", "?", "\"", "<", ">", "|"]
	for character in unsafe_chars:
		safe_name = safe_name.replacen(character, "")

	safe_name = safe_name.strip_edges()

	return safe_name


static func time_display(seconds: float) -> String:
	var h = floor(seconds / 3600)
	var mins = fmod(seconds, 3600) / 60
	var s = fmod(seconds, 60)
	var ms = fmod(seconds, 1) * 1000
	return "%02d:%02d:%02d.%03d" % [h, mins, s, ms]


static func time_display_no_hour(seconds: float) -> String:
	var mins = seconds / 60
	var s = fmod(seconds, 60)
	var ms = fmod(seconds, 1) * 1000
	return "%02d:%02d.%03d" % [mins, s, ms]


static func parse_time_display(time_str: String) -> float:
	# Split milliseconds from the rest
	var time_parts = time_str.split(".")
	if time_parts.size() != 2:
		return -1.0  # Invalid format

	var main_time = time_parts[0]
	var milliseconds = time_parts[1].substr(0, 3)  # Ensure only 3 digits

	# Split hours, minutes, seconds
	var components = main_time.split(":")
	if components.size() != 3:
		return -1.0  # Invalid format

	# Convert all parts to integers
	var h = components[0].to_int()
	var m = components[1].to_int()
	var s = components[2].to_int()
	var ms = milliseconds.to_int()

	# Calculate total seconds
	return h * 3600.0 + m * 60.0 + s + ms / 1000.0


static func generate_uuid() -> String:
	var uuid = ""
	for i in 16:
		uuid += "%02x" % randi_range(0, 255)
	return uuid.insert(8, "-").insert(13, "-").insert(18, "-")


static func _rumble_all_joypads(duration: float) -> void:
	var rumble_strength:= SaveManager.config.controller_rumble

	if rumble_strength <= 0.0:
		return

	for id: int in Input.get_connected_joypads():
		Input.start_joy_vibration(id, rumble_strength, rumble_strength, duration)
	pass


static func _get_camera_shake_tween(context: Node) -> Tween:
	const TWEEN_META:= 'dvk_camera_shake_tween'
	var meta = context.get_meta(TWEEN_META, false)

	if meta and meta is Tween and meta.is_valid():
		(meta as Tween).custom_step(999_999)
		(meta as Tween).kill()

	var tween: Tween = context.create_tween()

	context.set_meta(TWEEN_META, tween)
	return tween


static func camera_2d_shake(context: Node, magnitude:= 20.0, duration:= 0.5) -> void:
	var camera:= context.get_viewport().get_camera_2d()
	var original_offset:= camera.offset

	var max_shake:= magnitude * SaveManager.config.screen_shake

	var tween:= context.create_tween()

	const SHAKES_PER_SECOND:= 20
	var shake_count:= int(duration * SHAKES_PER_SECOND)
	var shake_each_duration = duration / shake_count

	for i in shake_count:
		var attenuate_overtime = (shake_count - i) / float(shake_count)

		tween.tween_callback(_rumble_all_joypads.bind(shake_each_duration))

		if max_shake >= 0.0:
			tween.tween_property(
				camera,
				'offset',
				original_offset + Vector2.from_angle(TAU * randf()) * max_shake * attenuate_overtime,
				shake_each_duration)
	tween.tween_property(camera, 'offset', original_offset, 0.1)



static func camera_3d_shake(context: Node, magnitude:= 0.01, duration:= 0.5) -> void:
	var camera:= context.get_viewport().get_camera_3d()
	var initial_transform = camera.transform

	var max_shake:= magnitude * SaveManager.config.screen_shake

	var tween: Tween = _get_camera_shake_tween(context)

	const SHAKES_PER_SECOND:= 20

	var shake_count:= int(duration * SHAKES_PER_SECOND)
	var shake_each_duration = duration / shake_count

	for i in shake_count:
		tween.tween_callback(_rumble_all_joypads.bind(shake_each_duration))

		if max_shake >= 0.0:
			var attenuate_overtime:= (shake_count - i) / float(shake_count)
			var random_direction:= Vector2.from_angle(TAU * randf())
			var vec3_offset:= Vector3(random_direction.x, random_direction.y, 0.0)

			tween.tween_property(
				camera,
				'transform:origin',
				initial_transform.origin + vec3_offset * max_shake * attenuate_overtime,
				shake_each_duration)

	tween.tween_property(camera, 'transform:origin', initial_transform.origin, 0.1)
