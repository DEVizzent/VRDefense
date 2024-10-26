extends XRToolsSceneBase

var tutorial_step : int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicController.swith_to_tutorial()
	EventBus.turret_type_selected.connect(step_one_completed)
	EventBus.turret_built.connect(step_two_completed)
	EventBus.round_finished.connect(step_three_completed)

func step_one_completed(turret_type: AbstractTurret.Type) -> void:
	if tutorial_step != 0:
		return
	if turret_type != AbstractTurret.Type.BOW:
		return
	$TutorialImages/Step1.visible = false
	$TutorialImages/Step2.visible = true
	tutorial_step += 1

func step_two_completed(_cost: int, _turret_position: Vector3) -> void:
	if tutorial_step != 1:
		return
	$TutorialImages/Step2.visible = false
	$TutorialImages/Step3.visible = true
	CommandBus.command_start_spawner()
	tutorial_step += 1

func step_three_completed() -> void:
	if tutorial_step != 2:
		return
	$TutorialImages/Step3.visible = false
	$TutorialImages/Step4.visible = true
	tutorial_step += 1

func step_four_completed() -> void:
	if tutorial_step != 3:
		return
	$TutorialImages/Step4.visible = false
	tutorial_step += 1
