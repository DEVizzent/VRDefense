extends Node3D
class_name TurretManager
# The turrent_types_scenes array  must be aligned with the AbstractTurret.Type enum
@export var turret_types_scenes: Array[PackedScene] = [
	preload("res://scenes/elements/Turrets/turret_bow.tscn"),
	preload("res://scenes/elements/Turrets/Bombs/turret_bomb.tscn")
]
var active_turret_type := AbstractTurret.Type.BOW
@export var xr_origin: XROrigin3D
var xr_origin_position: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	xr_origin_position = xr_origin.global_position
	DK.set_current_camera(xr_origin.find_child("XRCamera3D"))
	CommandBus.build_turret.connect(_on_build_turret)
	CommandBus.control_turret.connect(_on_control_turret)
	CommandBus.exit_turret.connect(_on_exit_turret)
	EventBus.turret_type_selected.connect(_on_turret_type_selected)
	
func _on_build_turret(turret_position: Vector3) -> void:
	if (GameInfo.gears_amount < 50):
		return
	var turret_instance: AbstractTurret = turret_types_scenes[active_turret_type].instantiate()
	add_child(turret_instance)
	EventBus.send_turret_built(50, turret_position)
	turret_instance.global_position = turret_position + Vector3.UP

func _on_control_turret(turret_position: Vector3) -> void:
	turret_position.y = 1
	for turret in get_children():
		if turret.global_position == turret_position and turret is AbstractTurret:
			turret.activate_player_control(xr_origin)
			return	

func _on_exit_turret() -> void:
	xr_origin.global_position = xr_origin_position
	xr_origin.rotation = Vector3(0, 0, 0)

func _on_turret_type_selected(turret_type: AbstractTurret.Type) -> void:
	active_turret_type = turret_type
