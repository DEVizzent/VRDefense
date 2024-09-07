extends Projectile
class_name Arrow

var is_thrown: bool = false
var speed_3d: Vector3 = Vector3(0, 0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not is_thrown:
		return
	position += speed_3d * delta
	speed_3d.y -=  gravity * delta

func throw() -> void:
	is_thrown = true
	speed_3d = direction * speed
	$LifeTimer.start()
