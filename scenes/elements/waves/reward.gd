extends Resource
class_name Reward
enum Type {
	UNBLOCK_BOMB_TOWER,
}

@export var reward : Type

func applyReward() -> void:
	match (reward):
		Type.UNBLOCK_BOMB_TOWER:
			EventBus.send_turret_type_unblocked(AbstractTurret.Type.BOMB)
