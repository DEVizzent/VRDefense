extends AbstractTurret

var xr_arrow_hand : PackedScene = preload("res://scenes/elements/Projectile/XR/xr_arrow_hand.tscn")
var xr_quiver : PackedScene = preload("res://scenes/elements/Projectile/XR/xr_quiver.tscn")
var xr_bow_hand : PackedScene = preload("res://scenes/elements/Projectile/XR/xr_bow_hand.tscn")
var preload_stats_progresion: TurretProgressionResource = preload("res://scenes/elements/Turrets/Bow/stats/bow_progression.tres")
@onready var character_soldier: Node3D = $"character-soldier"
@onready var sound: AudioStreamPlayer3D = $Sound

func _ready() -> void:
	stats_progresion = preload_stats_progresion.stats_progression
	super._ready()

func activate_player_control(xr_origin: XROrigin3D) -> void:
	timer.stop()
	xr_origin.position = global_position + Vector3(0, 2, 0)
	xr_origin.rotation.y = character_soldier.rotation.y + deg_to_rad(180)
	var main_hand : XRController3D = xr_origin.find_child(UserSettings.get_main_hand())
	var xr_arrow_hand_instance : XRArrowHand = xr_arrow_hand.instantiate()
	xr_arrow_hand_instance.set_stat(stats_progresion[stats_level])
	main_hand.add_child(xr_arrow_hand_instance)
	var head : XRCamera3D = xr_origin.find_child("XRCamera3D")
	head.add_child(xr_quiver.instantiate())
	var off_hand : XRController3D = xr_origin.find_child(UserSettings.get_off_hand())
	off_hand.add_child(xr_bow_hand.instantiate())
	CommandBus.exit_turret.connect(deactivate_player_control)
	player_control = true
	character_soldier.visible = false
	character_soldier.set_process(false)

func deactivate_player_control() -> void:
	timer.start()
	CommandBus.exit_turret.disconnect(deactivate_player_control)
	player_control = false
	character_soldier.visible = true
	character_soldier.set_process(true)

func shoot() -> void:
	$AnimationPlayer.play("shoot")
	sound["parameters/switch_to_clip"] = "Draw"
	sound.play()
	character_soldier.look_at(enemies_in_range.front().global_position, Vector3.UP) 
	character_soldier.rotate_object_local(Vector3.UP, PI)
	
func idle() -> void:
	$AnimationPlayer.play("idle_bow")
	
func invoke_arrow() -> void:
	var projectile:Arrow = projectile_scene.instantiate()
	projectile.set_damage(stats_progresion[stats_level].shot_damage)
	character_soldier.look_at(enemies_in_range.front().global_position + Vector3.UP, Vector3.UP)
	character_soldier.rotate_object_local(Vector3.UP, PI)
	character_soldier.add_child(projectile)
	projectile.direction = - projectile.direction
	projectile.throw()
	sound["parameters/switch_to_clip"] = "Shot"
	sound.play()
