extends Node3D
class_name TurretManager
# The turrent_types_scenes array  must be aligned with the AbstractTurret.Type enum
@export var turret_types_scenes: Array[PackedScene] = [
	preload("res://scenes/elements/Turrets/Bow/turret_bow.tscn"),
	preload("res://scenes/elements/Turrets/Bombs/turret_bomb.tscn")
]
var turret_progression_by_type: Array[TurretProgressionResource] = [
	preload("res://scenes/elements/Turrets/Bow/stats/bow_progression.tres"),
	preload("res://scenes/elements/Turrets/Bombs/stats/bomb_progression.tres")
]
@export var xr_grid_map : XRPointableGridMap
var has_selected := false
var active_turret_type : AbstractTurret.Type
@export var xr_origin: XROrigin3D
var xr_origin_position: Vector3
var active_turret : AbstractTurret
var show_popup_info : bool = true
@onready var info_popup: InfoPopUp = $InfoPopup
@onready var vfx_level_up: Emitter = $VFX_Level_Up

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	xr_origin_position = xr_origin.global_position
	DK.set_current_camera(xr_origin.find_child("XRCamera3D"))
	CommandBus.build_turret.connect(_on_build_turret)
	CommandBus.upgrade_turret.connect(_on_upgrade_turret)
	CommandBus.control_turret.connect(_on_control_turret)
	CommandBus.exit_turret.connect(_on_exit_turret)
	EventBus.turret_type_selected.connect(_on_turret_type_selected)
	xr_grid_map.cell_hovered.connect(_on_cell_hovered)
	xr_grid_map.cell_unhovered.connect(_on_cell_unhovered)
	
func _on_build_turret(turret_position: Vector3) -> void:
	if (GameInfo.gears_amount < turret_progression_by_type[active_turret_type].stats_progression[0].cost or not has_selected):
		return
	var turret_instance: AbstractTurret = turret_types_scenes[active_turret_type].instantiate()
	add_child(turret_instance)
	EventBus.send_turret_built(turret_progression_by_type[active_turret_type].stats_progression[0].cost, turret_position)
	turret_instance.global_position = turret_position + Vector3.UP

func _on_control_turret(turret_position: Vector3) -> void:
	turret_position.y = 1
	for turret in get_children():
		if turret.global_position == turret_position and turret is AbstractTurret:
			turret.activate_player_control(xr_origin)
			return	

func _on_upgrade_turret() -> void:
	if not active_turret or GameInfo.gears_amount < active_turret.get_upgrade_cost():
		return
	active_turret.upgrade_turret()
	vfx_level_up.global_position = active_turret.global_position
	vfx_level_up.emit()
	info_popup.show_compared_stats(active_turret.get_current_stats(), active_turret.get_upgrade_stats())
	return

func _on_exit_turret() -> void:
	xr_origin.global_position = xr_origin_position
	xr_origin.rotation.y = deg_to_rad(90.0)

func _on_turret_type_selected(turret_type: AbstractTurret.Type) -> void:
	active_turret_type = turret_type
	has_selected = true
func _on_cell_hovered(hover_position: Vector3, item: int)-> void:
	if not show_popup_info:
		return
	hover_position.y += 1.0
	for turret in get_children():
		if turret.global_position == hover_position and turret is AbstractTurret:
			info_popup.position = hover_position
			info_popup.show_compared_stats(turret.get_current_stats(), turret.get_upgrade_stats())
			info_popup.look_at(xr_origin_position, Vector3.UP, true)
			active_turret = turret
			return	
func _on_cell_unhovered(hover_position: Vector3) -> void:
	if not show_popup_info:
		return
	active_turret = null
	info_popup.hide()
