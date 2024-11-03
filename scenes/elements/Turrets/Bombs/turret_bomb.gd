extends AbstractTurret

var fire_point_scene : PackedScene = preload("res://scenes/elements/Projectile/XR/xr_fire_point.tscn")
var belt_scene : PackedScene = preload("res://scenes/elements/Turrets/Bombs/bomber_belt.tscn")
@onready var character_soldier: Node3D = $"character-soldier"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_bomb: Node3D = $"character-soldier/AnimatedBomb"
@onready var bombs_pool: Node3D = $BombsPool

func _ready() -> void:
	super._ready()
	animation_player.animation_finished.connect(run_next_animation)

func activate_player_control(xr_origin: XROrigin3D) -> void:
	$Timer.stop()
	xr_origin.position = global_position + Vector3(0, 2, 0)
	xr_origin.rotation.y = character_soldier.rotation.y + deg_to_rad(180.0)
	xr_origin.add_child(belt_scene.instantiate())
	var main_hand : XRController3D = xr_origin.find_child(UserSettings.get_main_hand())
	var function_pickup : XRToolsFunctionPickup = XRToolsFunctionPickup.new()
	main_hand.add_child(function_pickup)
	function_pickup.add_child(XRTurretControlComponent.new())
	var off_hand : XRController3D = xr_origin.find_child(UserSettings.get_off_hand())
	off_hand.add_child(fire_point_scene.instantiate())
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
	var bomb: Area3D = bombs_pool.get_child(0)
	bombs_pool.remove_child(bomb)
	bomb.visible = true
	animated_bomb.add_child(bomb)
	bomb.position = Vector3.ZERO
	look_at_enemy()
	animation_player.play("pick-up-bomb")

func throw_bomb() -> void:
	var bomb: Area3D = animated_bomb.get_child(0)
	var previous_global_transform : Transform3D = bomb.global_transform
	animated_bomb.remove_child(bomb)
	bombs_pool.add_child(bomb)
	bomb.global_transform = previous_global_transform
	bomb.throw(-character_soldier.global_transform.basis.z)

func idle() -> void:
	animation_player.play("idle")
	
func look_at_enemy() -> void:
	character_soldier.look_at(enemies_in_range.front().global_position, Vector3.UP) 

func run_next_animation(animation_finished : StringName) -> void:
	match animation_finished:
		"idle":
			idle()
		"throw-bomb-right":
			idle()
		"pick-up-bomb":
			look_at_enemy()
			animated_bomb.get_child(0).set_fire()
			animation_player.play("throw-bomb-right")
