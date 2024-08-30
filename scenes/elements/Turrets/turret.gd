extends Area3D

class_name Turret

@export var projectile_scene: PackedScene
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var enemies_in_range: Array[Enemy] = []

func activate_player_control(xr_origin: XROrigin3D) -> void:
	$Timer.stop()
	xr_origin.position = global_position + Vector3(0, 1, 0)
	xr_origin.rotation = rotation
	var main_hand = xr_origin.find_child(UserSettings.get_main_hand())
	main_hand.add_child(XRProjectileShooter.new())
	main_hand.find_child("FunctionPointer").enabled = false
	CommandBus.exit_turret.connect(deactivate_player_control)

func deactivate_player_control() -> void:
	$Timer.start()
	CommandBus.exit_turret.disconnect(deactivate_player_control)

	

func _on_area_entered(area:Area3D) -> void:
	var enemy = area.get_parent()
	if enemy is Enemy:
		enemies_in_range.append(enemy)
	if enemies_in_range.size() == 1:
		_on_timer_timeout()
		$Timer.start()


func _on_area_exited(area:Area3D) -> void:
	var enemy = area.get_parent()
	if enemy is Enemy:
		enemies_in_range.erase(enemy)
	if enemies_in_range.size() == 0:
		$Timer.stop()


func _on_timer_timeout() -> void:
	if enemies_in_range.size() == 0:
		$Timer.stop()
		return
	var projectile = projectile_scene.instantiate()
	look_at(enemies_in_range.front().global_position, Vector3.UP) 
	add_child(projectile)
	projectile.global_position.y = 2
	animation_player.play("shot")
	$Timer.start()
