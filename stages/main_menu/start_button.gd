extends Button

@export
var next_stage: String


func _on_button_down() -> void:
	SaveManager.load_data(GameSaveData.new(0))
	SaveManager.data.amnesia()
	StageManager.push_stage(next_stage)
