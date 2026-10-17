@tool
extends EditorPlugin


const autoload_singletons = [
	['GlobalBGM', "res://addons/vhoyer_devkit/Audio/global_bgm.gd"],
	['StageManager', "res://addons/vhoyer_devkit/StageManager/stage_manager.gd"],
	['SaveManager', "res://addons/vhoyer_devkit/SaveSystem/save_manager.gd"],
	['VHDStatus', "res://addons/vhoyer_devkit/InitLoader/vhd_status.gd"],
	['CheatSystem', "res://addons/vhoyer_devkit/CheatSystem/cheat_system.gd"],
]

# name, base class, path, icon
const custom_types = [[
	'GlobalBGMRemote',
	'AudioStreamPlayer',
	"res://addons/vhoyer_devkit/Audio/global_bgm_remote.gd",
], [
	'CreditsRoll',
	'ScrollContainer',
	"res://addons/vhoyer_devkit/UI/ui_elements/credits_roll/credits_roll.gd",
], [
	'InputPrompt',
	'TextureRect',
	"res://addons/vhoyer_devkit/UI/ui_elements/input_prompt/input_prompt.gd",
], [
	'ItemListSource',
	'ItemList',
	"res://addons/vhoyer_devkit/UI/ui_elements/item_list_source/item_list_source.gd",
], [
	'RadialMenu',
	'Control',
	"res://addons/vhoyer_devkit/UI/ui_elements/radial_menu/radial_menu.gd",
], [
	'RadialMenuItem',
	'Control',
	"res://addons/vhoyer_devkit/UI/ui_elements/radial_menu/radial_menu_item.gd",
], [
	'Stopwatch',
	'Label',
	"res://addons/vhoyer_devkit/UI/ui_elements/stopwatch/stopwatch.gd",
], [
	'HVolumeSlider',
	'HSlider',
	"res://addons/vhoyer_devkit/UI/ui_elements/volume_slider/h_volume_slider.gd",
], [
	'HWheelPickerButton',
	'BaseButton',
	"res://addons/vhoyer_devkit/UI/ui_elements/wheel_picker_button/h_wheel_picker_button.gd",
]]


func _enable_plugin() -> void:
	for autoload in autoload_singletons:
		add_autoload_singleton.call(autoload[0], autoload[1])

	for custom_type in custom_types:
		add_custom_type.callv(custom_type)


func _disable_plugin():
	for autoload in autoload_singletons:
		remove_autoload_singleton(autoload[0])

	for custom_type in custom_types:
		remove_custom_type(custom_type[0])


func _enter_tree() -> void:
	if not Engine.is_editor_hint(): return

	VHDSettings.setup_settings()
