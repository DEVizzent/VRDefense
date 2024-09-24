extends XRToolsPickable

var on_fire : bool = false
@onready var bomb: Node3D = $Bomb
var init_global_transform : Transform3D

func _ready() -> void:
	super._ready()
	var area : Area3D = $Area3D
	area.area_entered.connect(_on_area_entered)
	init_global_transform = get_global_transform()
	picked_up.connect(bomb.make_visible)

func _on_area_entered(_area: Area3D) -> void:
	bomb.set_fire()
