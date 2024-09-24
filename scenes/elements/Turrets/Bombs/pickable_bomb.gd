extends XRToolsPickable

var on_fire : bool = false
@onready var on_fire_particle : CPUParticles3D = $CPUParticles3D
var init_global_transform : Transform3D
@onready var timer: Timer = $Timer
@onready var animation_player : AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	super._ready()
	timer.timeout.connect(explosion)
	var area : Area3D = $Area3D
	area.area_entered.connect(_on_area_entered)
	init_global_transform = get_global_transform()
	picked_up.connect(make_visible)

func _on_area_entered(_area: Area3D) -> void:
	if on_fire:
		return
	on_fire_particle.emitting = true
	on_fire = true
	timer.start()

func explosion() -> void:
	animation_player.play("explosion")

func restart() -> void:
	on_fire = false
	on_fire_particle.emitting = false

func make_visible(_pickable: XRToolsPickable) -> void:
	animation_player.play("RESET")
