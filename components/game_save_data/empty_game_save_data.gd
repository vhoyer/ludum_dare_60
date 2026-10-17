class_name EmptyGameSaveData
extends GameSaveData


func _init() -> void:
	_short_term = InMemoryStorage.new('', 'save_empty')


func consolidate_memory() -> void:
	pass


func remember() -> void:
	pass


func empty() -> bool:
	return true


func unlock_achievement(_what) -> void:
	pass
