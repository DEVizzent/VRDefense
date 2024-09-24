extends Node
class_name XRTurretControlComponent


func _ready() -> void:
	CommandBus.exit_turret.connect(_on_exit_turret)

func _on_exit_turret() -> void:
	get_parent().queue_free()
