extends Area3D
class_name Projectile

var direction:Vector3 = Vector3.FORWARD

@export var speed : float = 100.0
@export var damage : int = 30
var impacted:bool = false

func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func _on_life_timer_timeout() -> void:
	queue_free()

func set_damage(new_damage: int) -> void:
	damage = new_damage

func _on_area_entered(area: Area3D) -> void:
	if impacted or not (area is AreaHitBox):
		return
	impacted = true
	area.take_damage(damage)
	queue_free()
