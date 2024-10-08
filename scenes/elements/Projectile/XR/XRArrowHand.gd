extends Area3D
class_name XRArrowHand


var arrow_scene: PackedScene = preload("res://scenes/elements/Projectile/arrow.tscn")
var _projectile_manager: Node3D
var current_arrow: Projectile
var current_bow: Node3D
var active_button_action : String = "trigger_click"
var _controller: XRController3D
var is_in_quiver_zone: bool = false
		

func _ready() -> void:
	_projectile_manager = get_tree().get_first_node_in_group("projectile_manager")
	if not _projectile_manager:
		push_error("No projectile manager found in the scene")
	# Check for a parent controller
	_controller = XRHelpers.get_xr_controller(self)
	if _controller:
		# Get button press feedback from our parent controller
		_controller.button_pressed.connect(_on_button_pressed)
		_controller.button_released.connect(_on_button_released)
	else:
		push_error("No XRController3D found in parent nodes")
	CommandBus.exit_turret.connect(queue_free)

func _process(_delta: float) -> void:
	if not current_arrow:
		return
	current_arrow.global_transform = global_transform
	current_arrow.direction = -global_transform.basis.z
	if current_bow:
		current_arrow.look_at(current_bow.global_position, Vector3.UP)
		current_arrow.direction = current_bow.global_transform.origin - global_transform.origin

func _on_button_pressed(p_button : String) -> void:
	match p_button:
		active_button_action:
			create_arrow()

func _on_button_released(p_button : String) -> void:
	if p_button != active_button_action:
		return

	shoot_current_arrow()

func create_arrow() -> void:
	if not is_in_quiver_zone:
		return
	if _projectile_manager.get_children().size() >= 10:
		return
	current_arrow = arrow_scene.instantiate()
	_projectile_manager.add_child(current_arrow)

func shoot_current_arrow() -> void:
	if not current_arrow:
		return
	var arrow_speed : float = 0.0
	if current_bow:
		arrow_speed = current_bow.global_transform.origin.distance_to(global_transform.origin) * 50.0
	current_arrow.speed = arrow_speed
	current_arrow.throw()
	current_arrow = null
	current_bow = null

func _on_area_entered(area:Area3D) -> void:
	if area.name == "XRQuiver":
		is_in_quiver_zone = true
	if area.name == "XRBowHand" and current_arrow:
		current_bow = area
		
func _on_area_exited(area : Area3D) -> void:
	if area.name == "XRQuiver":
		is_in_quiver_zone = false
