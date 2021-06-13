extends Node2D

export var life:int = 100

onready var life_bar:=$LifeBar

func _ready():
	life_bar.max_value=life
	life_bar.value=life

func on_damage(damage:int):
	life-=damage
	life_bar.value=life
	
	if life<=30:
		life_bar.modulate=Color(1, 0, 0)
	if life<=0:
		queue_free()
