extends AbstractTurret

var fire_point_scene : PackedScene = preload("res://scenes/elements/Projectile/XR/xr_fire_point.tscn")
var belt_scene : PackedScene = preload("res://scenes/elements/Turrets/Bombs/bomber_belt.tscn")
@onready var character_soldier: Node3D = $"character-soldier"
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	super._ready()

func activate_player_control(xr_origin: XROrigin3D) -> void:
	$Timer.stop()
	xr_origin.position = global_position + Vector3(0, 2, 0)
	xr_origin.rotation = rotation
	xr_origin.add_child(belt_scene.instantiate())
	var main_hand : XRController3D = xr_origin.find_child(UserSettings.get_main_hand())
	var function_pickup : XRToolsFunctionPickup = XRToolsFunctionPickup.new()
	main_hand.add_child(function_pickup)
	function_pickup.add_child(XRTurretControlComponent.new())
	var off_hand : XRController3D = xr_origin.find_child(UserSettings.get_off_hand())
	off_hand.add_child(fire_point_scene.instantiate())
	CommandBus.exit_turret.connect(deactivate_player_control)
	player_control = true

func deactivate_player_control() -> void:
	$Timer.start()
	CommandBus.exit_turret.disconnect(deactivate_player_control)
	player_control = false

func shoot() -> void:
	var projectile = projectile_scene.instantiate()
	character_soldier.look_at(enemies_in_range.front().global_position, Vector3.UP) 
	add_child(projectile)
	projectile.global_position.y += 2

func idle() -> void:
	$AnimationPlayer.play("idle")
