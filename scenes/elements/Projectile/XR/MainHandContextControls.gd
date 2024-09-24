extends Node
class_name MainHandContextControls

enum ControlContext { TURRET, MAP }

var _controller: XRController3D
var _context : ControlContext = ControlContext.MAP

func _ready() -> void:
	DK.print_fixed("XROnTurretControls ready")
	_controller = XRHelpers.get_xr_controller(self)
	if _controller:
		_controller.button_pressed.connect(_on_button_pressed)
		_controller.button_released.connect(_on_button_released)
		CommandBus.control_turret.connect(enter_turret_context)
	else:
		DK.print_fixed("No XRController3D found in parent nodes")
		push_error("No XRController3D found in parent nodes")
	

func _on_button_pressed(p_button : String) -> void:
	match p_button:
		"select_button":
			DK.print_fixed("Select button pressed")
			get_tree().paused = not get_tree().paused
		"menu_button":
			DK.print_fixed("Menu button pressed")
			get_tree().paused = not get_tree().paused
		"by_button":
			if _context == ControlContext.TURRET:
				CommandBus.command_exit_turret()

func _on_button_released(_p_button : String) -> void:
	pass


func exit_turret() -> void:
	_context = ControlContext.MAP
	_set_funtion_pointer_enabled(true)
	CommandBus.exit_turret.disconnect(exit_turret)

func enter_turret_context(_turret_position: Vector3) -> void:
	_context = ControlContext.TURRET
	_set_funtion_pointer_enabled(false)
	CommandBus.exit_turret.connect(exit_turret)

func _set_funtion_pointer_enabled(p_enabled : bool) -> void:
	var funtion_pointer : XRToolsFunctionPointer = _controller.find_child("FunctionPointer")
	if funtion_pointer:
		funtion_pointer.set_enabled(p_enabled)
		funtion_pointer.visible = p_enabled
	var bracelet_control : Node3D = _controller.find_child("BraceletControl")
	if bracelet_control:
		bracelet_control.visible = p_enabled
