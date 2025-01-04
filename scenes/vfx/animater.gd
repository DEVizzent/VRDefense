extends Node3D
class_name VFXAnimated

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@export var animation_name : String

func animate() -> void:
	animation_player.play(animation_name)
