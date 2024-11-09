extends XRToolsSceneBase

var tutorial_step : int = 0
@onready var tutorial_viewport: Node3D = $XROrigin3D/TutorialViewport
var step_scenes: Array[PackedScene] = [
	load("res://scenes/levels/tutorial/UI/steps/step0.tscn"),#0
	load("res://scenes/levels/tutorial/UI/steps/step1.tscn"),
	load("res://scenes/levels/tutorial/UI/steps/step2.tscn"),
	load("res://scenes/levels/tutorial/UI/steps/step3.tscn"),
	load("res://scenes/levels/tutorial/UI/steps/step4.tscn"),
	load("res://scenes/levels/tutorial/UI/steps/step5.tscn"),#5
	load("res://scenes/levels/tutorial/UI/steps/step6.tscn"),
	load("res://scenes/levels/tutorial/UI/steps/step7.tscn"),
	load("res://scenes/levels/tutorial/UI/steps/step1.tscn"),
	load("res://scenes/levels/tutorial/UI/steps/step2.tscn"),
	load("res://scenes/levels/tutorial/UI/steps/step8.tscn"),#10
	load("res://scenes/levels/tutorial/UI/steps/step9.tscn"),
	load("res://scenes/levels/tutorial/UI/steps/step5.tscn"),
	load("res://scenes/levels/tutorial/UI/steps/step10.tscn"),
]
var timer : Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicController.switch_to_tutorial()
	EventBus.turret_type_selected.connect(message_build_turret)
	EventBus.turret_built.connect(start_spawning_enemies)
	EventBus.round_finished.connect(message_control_turret)
	CommandBus.control_turret.connect(message_get_an_arrow)
	EventBus.arrow_created.connect(message_throw_an_arrow)
	EventBus.arrow_thrown.connect(message_kill_the_goblin)
	EventBus.round_finished.connect(message_exit_turret)
	CommandBus.exit_turret.connect(message_select_bomb_turret)
	EventBus.turret_type_selected.connect(message_build_bomb_turret)
	EventBus.turret_built.connect(message_control_bomb_turret)
	CommandBus.control_turret.connect(message_get_a_bomb)
	EventBus.bomb_grabbed.connect(message_throw_a_bomb)
	EventBus.bomb_thrown.connect(message_kill_the_goblin)
	EventBus.level_finished.connect(message_tutorial_completed)
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
	EventBus.round_finished.disconnect(message_control_turret)

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
	if tutorial_step != 4 and tutorial_step != 11:
		return
	tutorial_step += 1
	tutorial_viewport.set_scene(step_scenes[tutorial_step])
	CommandBus.command_start_spawner()

func message_exit_turret() -> void:
	if tutorial_step != 5:
		return
	tutorial_step += 1
	tutorial_viewport.set_scene(step_scenes[tutorial_step])

func message_select_bomb_turret() -> void:
	if tutorial_step != 6:
		return
	tutorial_step += 1
	tutorial_viewport.set_scene(step_scenes[tutorial_step])
	UISoundController.success()
	EventBus.send_turret_type_unblocked(AbstractTurret.Type.BOMB)
	CommandBus.exit_turret.disconnect(message_select_bomb_turret)

func message_build_bomb_turret(turret_type: AbstractTurret.Type) -> void:
	if tutorial_step != 7:
		return
	if turret_type != AbstractTurret.Type.BOMB:
		return
	tutorial_step += 1
	tutorial_viewport.set_scene(step_scenes[tutorial_step])
	EventBus.turret_type_selected.disconnect(message_build_turret)
	UISoundController.success()

func message_control_bomb_turret(_cost: int, _turret_position: Vector3) -> void:
	if tutorial_step != 8:
		return
	tutorial_step += 1
	tutorial_viewport.visible = true
	tutorial_viewport.set_scene(step_scenes[tutorial_step])
	EventBus.round_finished.disconnect(message_control_turret)

func message_get_a_bomb(_turret_position: Vector3) -> void:
	if tutorial_step != 9:
		return
	tutorial_step += 1
	tutorial_viewport.visible = true
	tutorial_viewport.set_scene(step_scenes[tutorial_step])
	CommandBus.control_turret.disconnect(message_get_a_bomb)

func message_throw_a_bomb() -> void:
	if tutorial_step != 10:
		return
	tutorial_step += 1
	tutorial_viewport.set_scene(step_scenes[tutorial_step])
	EventBus.bomb_grabbed.disconnect(message_throw_a_bomb)
	UISoundController.success()
func message_tutorial_completed() -> void:
	if tutorial_step != 12:
		return
	tutorial_step += 1
	tutorial_viewport.set_scene(step_scenes[tutorial_step])
	await get_tree().create_timer(5.0).timeout
	go_back_to_menu()
	
func go_back_to_menu() -> void:
	var scene_base : XRToolsSceneBase = XRTools.find_xr_ancestor(self, "*", "XRToolsSceneBase")
	scene_base.load_scene("res://scenes/menu/menu.tscn")
