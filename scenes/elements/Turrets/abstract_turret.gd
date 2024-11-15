extends Area3D
class_name AbstractTurret

enum Type {
	BOW = 0,
	BOMB = 1
}
@export var projectile_scene: PackedScene
var stats : TurretStatsResource
var player_control: bool = false
var enemies_in_range: Array[Enemy] = []
@onready var timer: Timer = $Timer

func _ready() -> void:
	update_stats()
	timer.timeout.connect(_on_timer_timeout)
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
func activate_player_control(_xr_origin: XROrigin3D) -> void:
	push_error("Overwrite the method of the abstract class")

func deactivate_player_control() -> void:
	push_error("Overwrite the method of the abstract class")

func shoot() -> void:
	push_error("Overwrite the method of the abstract class")

func idle() -> void:
	push_error("Overwrite the method of the abstract class")

func set_stats(new_stats : TurretStatsResource) -> void:
	stats = new_stats

func update_stats() -> void:
	if not stats:
		push_error("Not stats found")
	var area_shape : CylinderShape3D = $AreaShape.shape
	area_shape.radius = stats.shot_range
	timer.set_wait_time(stats.shot_coldown)

func _on_area_entered(area:Area3D) -> void:
	var enemy : Node3D = area.get_parent()
	if enemy is Enemy:
		enemies_in_range.append(enemy)
	if enemies_in_range.size() == 1 and not player_control:
		_on_timer_timeout()
	

func _on_area_exited(area:Area3D) -> void:
	var enemy: Node3D = area.get_parent()
	if enemy is Enemy:
		enemies_in_range.erase(enemy)
	if enemies_in_range.size() == 0:
		timer.stop()
		idle()
		

func _on_timer_timeout() -> void:
	if enemies_in_range.size() == 0:
		timer.stop()
		return
	shoot()
	timer.start()
