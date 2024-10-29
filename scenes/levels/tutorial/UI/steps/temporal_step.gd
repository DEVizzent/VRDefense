extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(hidden)
	timer.start(3.0)

func hidden() -> void:
	visible = false
