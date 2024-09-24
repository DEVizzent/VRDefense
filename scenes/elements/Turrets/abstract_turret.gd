extends Area3D
class_name AbstractTurret

enum Type {
	BOW = 0,
	BOMB = 1
}
@export var projectile_scene: PackedScene
var player_control: bool = false
var enemies_in_range: Array[Enemy] = []


func _ready() -> void:
	$Timer.timeout.connect(_on_timer_timeout)
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
func activate_player_control(_xr_origin: XROrigin3D) -> void:
	push_error("Overwrite the method of the abstract class")

func deactivate_player_control() -> void:
	push_error("Overwrite the method of the abstract class")

func shoot() -> void:
	push_error("Overwrite the method of the abstract class")

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
		$Timer.stop()

func _on_timer_timeout() -> void:
	if enemies_in_range.size() == 0:
		$Timer.stop()
		return
	shoot()
	$Timer.start()
