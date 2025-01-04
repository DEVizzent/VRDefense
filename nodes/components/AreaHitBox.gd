@tool
extends Area3D
class_name AreaHitBox

signal damaged(damage: int)

func _init() -> void:
	if Engine.is_editor_hint():
		collision_layer = 32 #Set Collision Layer 6
		collision_mask = 0

func take_damage(damage: int)-> void:
	damaged.emit(damage)
