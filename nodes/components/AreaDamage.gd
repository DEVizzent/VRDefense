extends Area3D
class_name AreaDamage

@export var damage : float = 20.0

func _ready() -> void:
	monitorable = false
	monitoring = true

func generate_damage() -> void:
	for area in get_overlapping_areas():
		if area is AreaHitBox:
			area.take_damage(damage)
