extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.level_finished.connect(unhidden)
	EventBus.round_finished.connect(unhidden_1_second)

func unhidden() -> void:
	visible = true

func unhidden_1_second() -> void:
	visible = true
	await get_tree().create_timer(2.0).timeout
	visible = false
