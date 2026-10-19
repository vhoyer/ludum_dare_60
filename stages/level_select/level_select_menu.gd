extends VBoxContainer

const MINIMUM_STAGE_NUMBER = 0

var next_stage: String
const STAGE_UIDS_LIST = [
	"uid://boew20gyqimy6"
]

func _on_spin_box_value_changed(value):
	next_stage = str(value)


func _on_play_button_button_down():
	var next_stage_number = int(next_stage)
	if next_stage_number != clamp(next_stage_number, MINIMUM_STAGE_NUMBER, STAGE_UIDS_LIST.size()):
		StageManager.push_stage("res://stages/level_select/level_select.tscn")
		return

	var next_stage_uid = STAGE_UIDS_LIST[next_stage_number]

	SaveManager.load_data(GameSaveData.new(0))
	SaveManager.data.amnesia()
	StageManager.push_stage(next_stage_uid)
