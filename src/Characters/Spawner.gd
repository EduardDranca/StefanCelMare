extends Node2D

export(String, "otoman") var _spawn = "otoman"
export(float) var _spawnTime
var _enemyDictionary = EnemyDictionary.enemyDictionary
var _enemySpawn = _enemyDictionary.get(_spawn)

onready var _parent = get_parent()
onready var _timer = $Timer

func _ready():
	_timer.set_wait_time(_spawnTime)
	_timer.set_one_shot(false)
	_timer.connect("timeout", self, "spawn")
	_timer.start()

func spawn():
	var newEnemy = _enemySpawn.instance()
	newEnemy.position = position
	_parent.add_child(newEnemy)
