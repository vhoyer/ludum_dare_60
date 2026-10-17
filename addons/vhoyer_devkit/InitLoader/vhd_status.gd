# class_name VHDStatus
extends Node


signal status_changed(id: String, status: String)


var _logger:= VHDLogger.new('VHD_Loader')

var _statuses: Dictionary[String, String] = {}



## to report sub loaders, separate them by using slashes ('/') in id
## a status beginning with "error" will be considered an error
func report(id: String, status: String) -> void:
	if _statuses.get(id) == status: return

	_statuses.set(id, status)
	status_changed.emit(id, status)

	if status.begins_with('error'):
		_logger.error('%s: %s' % [id, status])
	else:
		_logger.info('%s: %s' % [id, status])


func get_status(id: String) -> String:
	return _statuses.get(id, '')


func all_ok() -> bool:
	return _statuses.values().all(func(item: String): return item == 'ok')

func any_error() -> bool:
	return _statuses.values().any(func(item: String): return item.begins_with('error'))
