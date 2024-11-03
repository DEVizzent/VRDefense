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
	grabbed.connect(send_bomb_grabbed)
	dropped.connect(send_bomb_thrown_with_fire)

func _on_area_entered(_area: Area3D) -> void:
	bomb.set_fire()

func send_bomb_grabbed(_pickable, by) -> void:
	if by is XRToolsSnapZone:
		return
	EventBus.send_bomb_grabbed()

func send_bomb_thrown_with_fire(_pickable) -> void:
	if not bomb.is_on_fire():
		return
	EventBus.send_bomb_thrown()
