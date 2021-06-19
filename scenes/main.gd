extends Node2D

# The main script will handle all basic setup and orchestration

onready var player:Player=$Player
# This node constains all enemies as children
onready var enemies:=$Enemies
# Text to display on game over
onready var end_text:=$HUD/ToBeContinued

export(AudioStream) var game_over_music

var game_over:=false

func _ready():
	# At this point, all nodes in the scene are ready

	# Sets our map for our global (singleton) navigation
	GlobalNavigation.navigation=$Map
	_set_enemies_target()

# This function will be called by a signal if the player dies
func on_player_dead():
	# The game_over ensures game_over is only called once
	if !game_over:
		_game_over()

func _set_enemies_target():
	# All enemies under "Enemies" node need a target (player) to follow
	var enemies_list:=enemies.get_children()
	for enemy in enemies_list:
		enemy.target=player

func _game_over():
	print("Game Over")
	game_over=true
	end_text.visible=true
	
	_pause_game()
	_play_game_over_music()

func _pause_game():
	# This function pauses the whole game except the music node
	get_tree().paused = true
	Music.stream_paused=false

func _play_game_over_music():
	# Music is an autoload (i.e. global singleton) node for... playing music
	Music.stream=game_over_music # Sets the game over music
	Music.play() # Play our game over music
