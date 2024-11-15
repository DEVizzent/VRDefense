extends Area3D
class_name XRArrowHand


@onready var shot_sound: AudioStreamPlayer3D = $ShotSound
@onready var fast_draw_sound: AudioStreamPlayer3D = $FastDrawSound
@onready var slow_draw_sound: AudioStreamPlayer3D = $SlowDrawSound


var arrow_scene: PackedScene = preload("res://scenes/elements/Projectile/arrow.tscn")
var stats : TurretBowStatsResource
var _projectile_manager: Node3D
var current_arrow: Projectile
var current_bow: Node3D
var active_button_action : String = "trigger_click"
var _controller: XRController3D
var is_in_quiver_zone: bool = false
		
func set_stat(turret_stats : TurretBowStatsResource) -> void:
	stats = turret_stats

func _ready() -> void:
	if not stats:
		push_error("No stats on the XRArrowHand, call set_stat before add_child")
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
		play_draw_sound()
		send_haptics()
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
	current_arrow.set_damage(stats.shot_damage)
	_projectile_manager.add_child(current_arrow)
	EventBus.send_arrow_created()

func shoot_current_arrow() -> void:
	if not current_arrow:
		return
	var arrow_speed : float = 0.0
	if current_bow:
		arrow_speed = current_bow.global_transform.origin.distance_to(global_transform.origin) * 50.0
		shot_sound.play()
		slow_draw_sound.stop()
		fast_draw_sound.stop()
		_controller.trigger_haptic_pulse("haptic", .0, 1. if arrow_speed > 40. else .5, .1, 0)
		current_bow.send_haptics("haptic", .0, 1. if arrow_speed > 40. else .5, .1, 0)
	current_arrow.speed = arrow_speed
	current_arrow.throw()
	EventBus.send_arrow_thrown()
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

func play_draw_sound() -> void:
	var velocity : float = _controller.get_pose().linear_velocity.length()
	if velocity < 0.05 :
		fast_draw_sound.stop()
		slow_draw_sound.stop()
		return
	if velocity < .3:
		if (slow_draw_sound.is_playing()):
			return
		slow_draw_sound.play()
		fast_draw_sound.stop()
		return
	if (fast_draw_sound.is_playing()): 
		return
	slow_draw_sound.stop()
	fast_draw_sound.play()

func send_haptics() -> void:
	var bow_distance: float = current_bow.global_transform.origin.distance_to(global_transform.origin)
	if bow_distance < .6 :
		return
	if bow_distance > 1.:
		bow_distance = 1.0
	_controller.trigger_haptic_pulse("haptic", 0.0 , bow_distance*.1, 1, 0)
	current_bow.send_haptics("haptic", 0.0 , bow_distance*.1, 1, 0)
