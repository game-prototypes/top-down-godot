extends KinematicBody2D

# Life and speed can be configured in our editor
export var life:int = 100
export var speed:float=100

onready var life_bar:=$LifeBar

var target:Node2D

func _ready():
	_setup_life_bar()

func _physics_process(_delta):
	if target:
		_follow_target()

# Called by the player when the enemy is hit
func on_damage(damage:int):
	life-=damage
	life_bar.value=life
	
	if life<=30:
		life_bar.modulate=Color(1, 0, 0) # Makes life bar red
	if life<=0:
		queue_free() # Removes enemy node

func _setup_life_bar():
	life_bar.max_value=life
	life_bar.value=life

func _follow_target():
	# Gets the path to target from our GlobalNavigation
	# The path will be an array, with the first element being the current position
	var path=GlobalNavigation.get_navigation_path(position, target.position)
	# We will move in the direction of the next waypoint of the path 
	# (i.e. the diff between the next waypoint and current pos)
	# Normalized ensure we get a vector of distance 1
	var direction:Vector2=(path[1] - path[0]).normalized()
	# We go to the direction, but taking enemy speed into account
	var velocity=direction*speed
	# Will move in the given direction and speed, sliding if a collision is detected
	# delta is already taken into account
	# Note, this needs to run in the _physics_process step
	move_and_slide(velocity)
