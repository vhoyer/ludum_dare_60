class_name MakeParentPersistent
extends Node

@export
var list_of_persistent_properties: Array[String] = []

@export
var scope: String = 'global'

@export
var save_on_window_closing: bool = true


func _enter_tree() -> void:
	var parent: Node = get_parent() as Node
	if parent.is_node_ready():
		load_persistent_values()
	else:
		get_parent().ready.connect(load_persistent_values, CONNECT_ONE_SHOT)


func load_persistent_values() -> void:
	var parent: Node = get_parent() as Node
	var store:= JSONStorage.new(parent.name, scope)
	for prop: String in list_of_persistent_properties:
		parent.set(prop, store.get_item(prop, parent.get(prop)))


func _exit_tree() -> void:
	save_persistent_values()


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_CLOSE_REQUEST:
			if save_on_window_closing:
				save_persistent_values()


func save_persistent_values() -> void:
	var parent: Node = get_parent() as Node
	var store:= JSONStorage.new(parent.name, scope)
	for prop: String in list_of_persistent_properties:
		store.set_item(prop, parent.get(prop))
