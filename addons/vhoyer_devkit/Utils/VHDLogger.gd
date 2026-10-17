extends Resource
class_name VHDLogger

@export var name: String

func _init(_name: String = "") -> void:
	self.name = _name


func debug(msg: String) -> void:
	print_rich('DEBUG: [color=dimgray]', '[b][lb]', name, '[rb]:[/b] ', msg, '[/color]')


func info(msg: String) -> void:
	print_rich('INFO: [b][lb]', name, '[rb]:[/b] ', msg)


func warn(msg: String) -> void:
	print_rich('WARN: [color=gold]', '[b][lb]', name, '[rb]:[/b] ', msg, '[/color]')
	push_warning('WARN: [%s]: ' % name, msg)


func error(msg: String) -> void:
	print_rich('ERROR: [color=firebrick]', '[b][lb]', name, '[rb]:[/b] ', msg, '[/color]')
	push_error('ERROR: [%s]: ' % name, msg)


static func scope(_name: String) -> VHDLogger:
	return VHDLogger.new(_name)
