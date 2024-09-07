extends Path3D

@export var enemy_scene: PackedScene
var counter: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var timer: Timer = $Timer
	timer.timeout.connect(spawn_enemy)

func spawn_enemy() -> void:
	add_child(enemy_scene.instantiate())
	counter += 1
	if counter == 10 and $Timer.wait_time > 0.2:
		$Timer.wait_time -= 0.2
		print_debug("Decreasing spawn time to: ", $Timer.wait_time)
