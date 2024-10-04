extends AbstractTurret

var xr_arrow_hand : PackedScene = preload("res://scenes/elements/Projectile/XR/xr_arrow_hand.tscn")
var xr_quiver : PackedScene = preload("res://scenes/elements/Projectile/XR/xr_quiver.tscn")
var xr_bow_hand : PackedScene = preload("res://scenes/elements/Projectile/XR/xr_bow_hand.tscn")
@onready var character_soldier: Node3D = $"character-soldier"

func _ready() -> void:
	super._ready()

func activate_player_control(xr_origin: XROrigin3D) -> void:
	$Timer.stop()
	xr_origin.position = global_position + Vector3(0, 2, 0)
	xr_origin.rotation = rotation
	var main_hand : XRController3D = xr_origin.find_child(UserSettings.get_main_hand())
	main_hand.add_child(xr_arrow_hand.instantiate())
	var head : XRCamera3D = xr_origin.find_child("XRCamera3D")
	head.add_child(xr_quiver.instantiate())
	var off_hand : XRController3D = xr_origin.find_child(UserSettings.get_off_hand())
	off_hand.add_child(xr_bow_hand.instantiate())
	CommandBus.exit_turret.connect(deactivate_player_control)
	player_control = true
	character_soldier.visible = false
	character_soldier.set_process(false)

func deactivate_player_control() -> void:
	$Timer.start()
	CommandBus.exit_turret.disconnect(deactivate_player_control)
	player_control = false
	character_soldier.visible = true
	character_soldier.set_process(true)

func shoot() -> void:
	$AnimationPlayer.play("shoot")
	character_soldier.look_at(enemies_in_range.front().global_position, Vector3.UP) 
	character_soldier.rotate_object_local(Vector3.UP, PI)
	
func invoke_arrow() -> void:
	var projectile:Arrow = projectile_scene.instantiate()
	character_soldier.look_at(enemies_in_range.front().global_position + Vector3.UP, Vector3.UP)
	character_soldier.rotate_object_local(Vector3.UP, PI)
	character_soldier.add_child(projectile)
	projectile.direction = - projectile.direction
	projectile.throw()
