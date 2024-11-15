extends Area3D
class_name MinionBomb

@onready var bomb: Bomb = $Bomb
var is_thrown: bool = false
var speed_3d: Vector3 = Vector3(0, 0, 0)
var stats: TurretBombStatsResource
@export var speed: float = 20.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(explosion)
	body_entered.connect(explosion)
	bomb.explosion_finished.connect(back_to_origin_position)
func set_stats(stats) -> void:
	bomb.set_stats(stats)
func _physics_process(delta: float) -> void:
	if not is_thrown: 
		return
	speed_3d.y -=  9.8 * delta
	position += speed_3d * delta

func throw(throw_direction: Vector3) -> void:
	is_thrown = true
	speed_3d = (throw_direction * speed) + Vector3.UP

func explosion(_area_or_body: Node3D) -> void:
	bomb.explosion()
	speed_3d = Vector3.ZERO

func set_fire() -> void:
	bomb.set_fire()

func back_to_origin_position() -> void:
	is_thrown = false
	position = Vector3.ZERO
	bomb.reset_bomb()
