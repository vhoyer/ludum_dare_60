# class_name LevelsManager
extends Node


var current: GameLevel:
	get():
		return self.get_child(SaveManager.data.current_level)
