extends Node2D


onready var enemy1:=$Enemy
onready var player:=$Player
onready var map:=$Map

func _ready():
	GlobalNavigation.navigation=map # Sets the global navigation value
	enemy1.set_target(player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
