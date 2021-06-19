extends KinematicBody2D

export var life:int = 100
export var speed:float=100

onready var life_bar:=$LifeBar

var target:Node2D

func _ready():
	life_bar.max_value=life
	life_bar.value=life

func _process(delta):
	if target:
		var path=GlobalNavigation.get_navigation_path(position, target.position)
		var movement_vector:Vector2=(path[1] - path[0]).normalized()
		var velocity=movement_vector*speed
		move_and_slide(velocity)

func set_target(target_node:Node2D):
	target=target_node

func on_damage(damage:int):
	life-=damage
	life_bar.value=life
	
	if life<=30:
		life_bar.modulate=Color(1, 0, 0)
	if life<=0:
		queue_free()
