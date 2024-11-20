extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stop()
	EventBus.round_finished.connect(end_round)
	EventBus.turret_upgrated.connect(upgrade)

func success() -> void:
	self["parameters/switch_to_clip"] = "success"
	play()

func end_round() -> void:
	self["parameters/switch_to_clip"] = "end_round"
	play()

func upgrade(_upgrated_stats:TurretStatsResource) -> void:
	self["parameters/switch_to_clip"] = "upgrade"
	play()
