extends AudioStreamPlayer

func _ready() -> void:
	EventBus.level_finished.connect(switch_to_intro)

func switch_to_tutorial():
	self["parameters/switch_to_clip"] = "Tutorial"

func switch_to_intro():
	self["parameters/switch_to_clip"] = "Intro"
