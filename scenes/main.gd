extends Node2D

onready var enemy1:=$Enemy
onready var enemy2:=$Enemy2
onready var player:=$Player
onready var map:=$Map
onready var music:=$Music

onready var end_text:=$HUD/ToBeContinued

func _ready():
	GlobalNavigation.navigation=map # Sets the global navigation value
	enemy1.set_target(player)
	enemy2.set_target(player)

func _on_player_dead():
	print("DEAD")
	music.play()
	end_text.visible=true
	_pause_game()

func _pause_game():
	get_tree().paused = true
	music.stream_paused=false
	
