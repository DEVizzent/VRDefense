extends MeshInstance3D

@export var y_reference : Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if y_reference:
		global_position.y = y_reference.global_position.y - 1.2
	$TutorialButton.button_pressed.connect(tutorial_button_pressed)
	$PlayButton.button_pressed.connect(button_pressed)
	$ExitButton.button_pressed.connect(exit_button_pressed)

func button_pressed(_button: Variant) -> void:
	UISoundController.success()
	var scene_base : XRToolsSceneBase = XRTools.find_xr_ancestor(self, "*", "XRToolsSceneBase")
	scene_base.load_scene("res://scenes/levels/world1/level1/level.tscn")

func tutorial_button_pressed(_button: Variant) -> void:
	UISoundController.success()
	var scene_base : XRToolsSceneBase = XRTools.find_xr_ancestor(self, "*", "XRToolsSceneBase")
	scene_base.load_scene("res://scenes/levels/tutorial/tutorial_level.tscn")

func exit_button_pressed(_button: Variant) -> void:
	get_tree().quit()
