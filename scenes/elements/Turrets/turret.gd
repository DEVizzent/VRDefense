extends AbstractTurret
class_name Turret

func activate_player_control(xr_origin: XROrigin3D) -> void:
	$Timer.stop()
	xr_origin.position = global_position + Vector3(0, 1, 0)
	xr_origin.rotation = rotation
	var main_hand = xr_origin.find_child(UserSettings.get_main_hand())
	main_hand.add_child(XRProjectileShooter.new())
	CommandBus.exit_turret.connect(deactivate_player_control)
	$MeshInstance3D/Head.visible = false
	player_control = true

func deactivate_player_control() -> void:
	$Timer.start()
	CommandBus.exit_turret.disconnect(deactivate_player_control)
	$MeshInstance3D/Head.visible = true
	player_control = false

func shoot() -> void:
	var projectile = projectile_scene.instantiate()
	look_at(enemies_in_range.front().global_position, Vector3.UP) 
	add_child(projectile)
	projectile.global_position.y = 2
	animation_player.play("shot")
