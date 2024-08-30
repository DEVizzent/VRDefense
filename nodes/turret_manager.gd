extends Node3D
class_name TurretManager

@export var turret_scene: PackedScene
@export var xr_origin: XROrigin3D
var xr_origin_position: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	xr_origin_position = xr_origin.global_position
	CommandBus.build_turret.connect(_on_build_turret)
	CommandBus.control_turret.connect(_on_control_turret)
	CommandBus.exit_turret.connect(_on_exit_turret)
	
func _on_build_turret(turret_position: Vector3) -> void:
	var turret_instance = turret_scene.instantiate()
	add_child(turret_instance)
	turret_instance.global_position = turret_position

func _on_control_turret(turret_position: Vector3) -> void:
	for turret in get_children():
		if turret.global_position == turret_position and turret is Turret:
			turret.activate_player_control(xr_origin)
			return	

func _on_exit_turret() -> void:
	xr_origin.global_position = xr_origin_position