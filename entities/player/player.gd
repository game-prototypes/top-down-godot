extends Node2D

export var speed:float=100

func _process(delta):
	_movement_update(delta)
	_look_update(delta)
	
	if Input.is_action_just_pressed("shoot"):
		print("SHOOT")


func _movement_update(delta):
	var velocity = Vector2()
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	velocity = velocity.normalized() * speed
	position += velocity * delta

func _look_update(delta):
	var mouse_position=get_viewport().get_mouse_position()
	look_at(mouse_position)
