extends AbstractTurret

var xr_arrow_hand : PackedScene = preload("res://scenes/elements/Projectile/XR/xr_arrow_hand.tscn")
var xr_quiver : PackedScene = preload("res://scenes/elements/Projectile/XR/xr_quiver.tscn")
var xr_bow_hand : PackedScene = preload("res://scenes/elements/Projectile/XR/xr_bow_hand.tscn")

func _ready() -> void:
	$Timer.timeout.connect(_on_timer_timeout)

func activate_player_control(xr_origin: XROrigin3D) -> void:
	$Timer.stop()
	xr_origin.position = global_position + Vector3(0, 1, 0)
	xr_origin.rotation = rotation
	var main_hand : XRController3D = xr_origin.find_child(UserSettings.get_main_hand())
	main_hand.add_child(xr_arrow_hand.instantiate())
	var head : XRCamera3D = xr_origin.find_child("XRCamera3D")
	head.add_child(xr_quiver.instantiate())
	var off_hand : XRController3D = xr_origin.find_child(UserSettings.get_off_hand())
	off_hand.add_child(xr_bow_hand.instantiate())
	CommandBus.exit_turret.connect(deactivate_player_control)
	player_control = true

func deactivate_player_control() -> void:
	$Timer.start()
	CommandBus.exit_turret.disconnect(deactivate_player_control)
	player_control = false

func shoot() -> void:
	var projectile:Arrow = projectile_scene.instantiate()
	look_at(enemies_in_range.front().global_position, Vector3.UP) 
	add_child(projectile)
	projectile.global_position.y = 2
	projectile.direction.y += 0.1
	projectile.throw()
