extends Node3D
class_name XRProjectileShooter


var projectile_scene: PackedScene = preload("res://scenes/elements/Projectile/projectile.tscn")
var _projectile_manager: Node3D
var active_button_action : String = "trigger_click"
var exit_button_action : String = "by_button"
var _controller: XRController3D

func _ready() -> void:
	_projectile_manager = get_tree().get_first_node_in_group("projectile_manager")
	if not _projectile_manager:
		push_error("No projectile manager found in the scene")
	# Check for a parent controller
	_controller = XRHelpers.get_xr_controller(self)
	if _controller:
		# Get button press feedback from our parent controller
		_controller.button_pressed.connect(_on_button_pressed)
	else:
		push_error("No XRController3D found in parent nodes")

func _on_button_pressed(p_button : String) -> void:
	match p_button:
		exit_button_action:
			exit()
		active_button_action:
			shoot()

func shoot() -> void:
	if _projectile_manager.get_children().size() > 5:
		return
	var projectile = projectile_scene.instantiate()
	_projectile_manager.add_child(projectile)
	projectile.global_position = global_position
	projectile.direction = -global_transform.basis.z

func exit() -> void:
	CommandBus.command_exit_turret()
	queue_free()
