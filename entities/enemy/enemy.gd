extends Node2D

export var life:int = 100

func on_damage(damage:int):
	life-=damage
	if life<=0:
		queue_free()
