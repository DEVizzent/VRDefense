extends Resource
class_name Wave

@export_range(.1, 25.) var duration: float = 1.
@export var enemies: Array[EnemyResource]
@export_range(.1, 25.) var rest_time: float = 1.
