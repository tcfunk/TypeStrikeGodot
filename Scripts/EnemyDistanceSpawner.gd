extends Node3D
class_name EnemyDistanceSpawner

class Wave:
	var path_placement: float
	var enemy_type: String

@export var player_path : PathFollow3D
@onready var enemy_container : Node3D = $"Enemies"

var enemies: Array
var player_controller: TypeStrikePlayer

func _ready():
	enemies = _get_enemy_children()
	enemies.sort_custom(func(a:EnemyMarker, b:EnemyMarker):
		return a.path_position < b.path_position
	)

func _get_enemy_children():
	var enemies = []
	var waiting := get_children()
	while not waiting.is_empty():
		var node := waiting.pop_back() as Node
		waiting.append_array(node.get_children())
		if node.is_in_group("enemy_markers"):
			enemies.append(node)
	return enemies

func _process(delta):
	if player_path == null:
		return
	if enemies.size() == 0:
		return
	
	var player_pos = player_path.progress
	
	while enemies.size() > 0 && enemies[0].path_position <= player_pos:
		var enemy = enemies.pop_front()
		enemy.notify.emit()
		if enemy is EnemyMarker:
			#var enemy : EnemyMarker = enemies.pop_front()
			enemy.enable_enemy()
			Messenger.wave_started.emit()
