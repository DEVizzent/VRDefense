extends Area3D
class_name Projectile

var direction:Vector3 = Vector3.FORWARD

@export var speed : float = 30.0
@export var damage : int = 30

func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func _on_life_timer_timeout() -> void:
	queue_free()


func _on_area_entered(area: Area3D) -> void:
	var enemy : Node = area.get_parent()
	if enemy is Enemy:
		enemy.take_damage(damage)
		queue_free()
