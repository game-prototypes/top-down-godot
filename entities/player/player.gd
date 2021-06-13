extends Node2D

export var speed:float=100

export (PackedScene) var bullet

onready var raycast:=$RayCast2D

func _process(delta):
	_movement_update(delta)
	_look_update(delta)



func _physics_process(delta):
	if Input.is_action_just_pressed("shoot"):
		_shoot()


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
	var target=_get_target_coordinates()
	look_at(target)

func _get_target_coordinates()->Vector2:
	var mouse_position=get_viewport().get_mouse_position()
	return mouse_position

func _shoot():
	var bullet_instance=bullet.instance() as Bullet
	var target=_get_target_coordinates()
	
	bullet_instance.set_path(position, target)
	owner.add_child(bullet_instance)
	raycast.cast_to=to_local(target)
	raycast.force_raycast_update()
	#print(position, target)
	print(raycast.is_colliding())