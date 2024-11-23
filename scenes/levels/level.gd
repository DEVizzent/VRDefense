extends XRToolsSceneBase
class_name Level

@export var starting_level_gears : int

func _ready() -> void:
	EventBus.level_finished.connect(level_finish)
	GameInfo.gears_amount = starting_level_gears

func level_finish() -> void:
	await get_tree().create_timer(3.0).timeout
	go_back_to_menu()
	
func go_back_to_menu() -> void:
	var scene_base : XRToolsSceneBase = XRTools.find_xr_ancestor(self, "*", "XRToolsSceneBase")
	scene_base.load_scene("res://scenes/menu/menu.tscn")
