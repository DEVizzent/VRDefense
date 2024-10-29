extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stop()
	EventBus.round_finished.connect(success)

func success() -> void:
	self["parameters/switch_to_clip"] = "success"
	play()
