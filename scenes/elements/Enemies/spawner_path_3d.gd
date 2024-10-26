extends Path3D

@onready var timer: Timer = $Timer
@export var time_betweent_rounds: float = 5.0
@export var enemy_scene: PackedScene
@export var round_collection : Array[Round]
var current_round_index: int
var current_wave_index: int
var next_enemy_index: int
var waiting_next_round: bool
var counter: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CommandBus.start_spawner.connect(start_spawner)
	EventBus.enemy_defeated.connect(prepare_next_round)
	timer.timeout.connect(spawn_enemy)
	current_round_index = 0
	current_wave_index = 0
	next_enemy_index = 0

func start_spawner() -> void:
	timer.start(.1)
	
func update_spawn_time()->void:
	var duration: float = round_collection[current_round_index].waves[current_wave_index].duration
	var enemies_on_wave: int = round_collection[current_round_index].waves[current_wave_index].enemies.size()
	if enemies_on_wave < 2:
		timer.wait_time = duration
		return
	timer.wait_time = duration/float(enemies_on_wave-1)
	
func spawn_enemy() -> void:
	if (next_enemy_index == 0):
		update_spawn_time()
	_add_current_enemy_to_scene()
	next_enemy_index += 1
	var enemies_in_wave := round_collection[current_round_index].waves[current_wave_index].enemies.size()
	if has_next_enemy():
		return
	next_enemy_index = 0
	current_wave_index += 1
	if has_next_wave():
		timer.wait_time = round_collection[current_round_index].waves[current_wave_index].rest_time
		return
	current_wave_index = 0
	current_round_index += 1
	waiting_next_round = true
	timer.stop()

func _add_current_enemy_to_scene() -> void:
	var enemy: EnemyResource = round_collection[current_round_index].waves[current_wave_index].enemies[next_enemy_index]
	var enemy_instance: Enemy = enemy.scene.instantiate()
	enemy_instance.init(enemy.enemy_stats)
	add_child(enemy_instance)

func prepare_next_round(_enemy: Enemy) -> void:
	if not waiting_next_round:
		return
	if get_child_count() > 2:
		return
	
	if round_collection.size() >= current_round_index:
		EventBus.send_level_finished()
	
	waiting_next_round = false
	if has_next_round():
		EventBus.send_round_finished()
		update_spawn_time()
		timer.start(time_betweent_rounds)
		return
	EventBus.send_level_finished()

func has_next_enemy() -> bool:
	return round_collection[current_round_index].waves[current_wave_index].enemies.size() > next_enemy_index

func has_next_wave() -> bool:
	return round_collection[current_round_index].waves.size() > current_wave_index

func has_next_round() -> bool:
	return round_collection.size() > current_round_index
