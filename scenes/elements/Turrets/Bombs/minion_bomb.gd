extends Area3D

@onready var bomb: Node3D = $Bomb

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(explosion)
	bomb.explosion_finished.connect(back_to_origin_position)
	monitoring = false

func explosion() -> void:
	$Bomb.explosion()
	monitoring = false

func set_fire() -> void:
	$Bomb.set_fire()
	monitoring = true

func back_to_origin_position() -> void:
	position = Vector3.ZERO
