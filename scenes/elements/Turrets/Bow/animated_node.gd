extends Node3D

func play(animation_name : StringName)-> void:
	$AnimationPlayer.play(animation_name)

func parent_invoke_arrow()-> void:
	$"..".invoke_arrow()
