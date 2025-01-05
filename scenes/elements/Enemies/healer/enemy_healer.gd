extends Enemy

@onready var heal_timer : Timer = $HealTimer

func _ready() -> void:
	super._ready()
	heal_timer.timeout.connect(heal_spell)

func heal_spell() -> void:
	if health == 0:
		return
	animation_player.play("heal_spell")
