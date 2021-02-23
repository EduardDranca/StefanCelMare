extends Node2D

onready var player = $Stefan
var playerDead = false
var score = 0

func _input(event):
	if playerDead and event.is_action_pressed("restart"):
		get_tree().reload_current_scene()

func _ready():
	for child in get_children():
		if child.is_in_group("spawners"):
			child.connect("spawned", self, "connectEnemy")
	$Stefan.connect("requestSound", $SoundManager, "playSound")
	$Stefan.connect("playerDeath", self, "playerDeath")
	$Stefan.connect("moved", self, "updateGameOverTextPosition")

func playerDeath(camera):
	playerDead = true
	camera.position = camera.get_parent().position
	camera.get_parent().remove_child(camera)
	$GameOverText.visible = true
	add_child(camera)

func connectEnemy(enemy):
	if ($Stefan):
		$Stefan.connect("moved", enemy, "updatePlayerPosition")
	enemy.connect("requestSound", $SoundManager, "playSound")
	enemy.connect("death", self, "increaseScore")

func increaseScore():
	score += 1
	$GUI.setScore(score)

func updateGameOverTextPosition(position):
	$GameOverText.position = position
