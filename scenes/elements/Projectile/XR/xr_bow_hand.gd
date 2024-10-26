extends Area3D


var _controller: XRController3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_controller = XRHelpers.get_xr_controller(self)
	if !_controller:
		push_error("No XRController3D found in parent nodes")

func send_haptics(action_name: String, frequency: float, amplitude: float, duration_sec: float, delay_sec: float) -> void:
	_controller.trigger_haptic_pulse(action_name, frequency, amplitude, duration_sec, delay_sec)	
