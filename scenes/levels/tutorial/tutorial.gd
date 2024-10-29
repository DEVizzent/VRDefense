extends XRToolsSceneBase

var tutorial_step : int = 0
@onready var tutorial_viewport: Node3D = $XROrigin3D/TutorialViewport
var step_scenes: Array[PackedScene] = [
	load("res://scenes/levels/tutorial/UI/steps/step0.tscn"),
	load("res://scenes/levels/tutorial/UI/steps/step1.tscn"),
	load("res://scenes/levels/tutorial/UI/steps/step2.tscn"),
	load("res://scenes/levels/tutorial/UI/steps/step3.tscn"),
	load("res://scenes/levels/tutorial/UI/steps/step4.tscn"),
	load("res://scenes/levels/tutorial/UI/steps/step5.tscn"),
]
var timer : Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicController.swith_to_tutorial()
	EventBus.turret_type_selected.connect(message_build_turret)
	EventBus.turret_built.connect(start_spawning_enemies)
	EventBus.round_finished.connect(message_control_turret)
	CommandBus.control_turret.connect(message_get_an_arrow)
	EventBus.arrow_created.connect(message_throw_an_arrow)
	EventBus.arrow_thrown.connect(message_kill_the_goblin)
	tutorial_viewport.set_scene(step_scenes[0])

func message_build_turret(turret_type: AbstractTurret.Type) -> void:
	if tutorial_step != 0:
		return
	if turret_type != AbstractTurret.Type.BOW:
		return
	tutorial_step += 1
	tutorial_viewport.set_scene(step_scenes[tutorial_step])
	EventBus.turret_type_selected.disconnect(message_build_turret)
	UISoundController.success()

func start_spawning_enemies(_cost: int, _turret_position: Vector3) -> void:
	if tutorial_step != 1:
		return
	CommandBus.command_start_spawner()
	tutorial_viewport.visible = false
	EventBus.turret_built.disconnect(start_spawning_enemies)
	UISoundController.success()

func message_control_turret() -> void:
	if tutorial_step != 1:
		return
	tutorial_step += 1
	tutorial_viewport.visible = true
	tutorial_viewport.set_scene(step_scenes[tutorial_step])
	#EventBus.round_finished.disconnect(message_control_turret)

func message_get_an_arrow(_turret_position: Vector3) -> void:
	if tutorial_step != 2:
		return
	tutorial_step += 1
	tutorial_viewport.set_scene(step_scenes[tutorial_step])
	CommandBus.control_turret.disconnect(message_get_an_arrow)
	UISoundController.success()

func message_throw_an_arrow() -> void:
	if tutorial_step != 3:
		return
	tutorial_step += 1
	tutorial_viewport.set_scene(step_scenes[tutorial_step])
	EventBus.arrow_created.disconnect(message_throw_an_arrow)
	UISoundController.success()

func message_kill_the_goblin() -> void:
	if tutorial_step != 4:
		return
	tutorial_step += 1
	tutorial_viewport.set_scene(step_scenes[tutorial_step])
	CommandBus.command_start_spawner()
