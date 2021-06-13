extends Node2D

export var speed:float=100
export var damage:int=10

export (PackedScene) var bullet

onready var raycast:=$RayCast2D
onready var gun_sound:=$GunSound

func _process(delta):
	_movement_update(delta)
	_look_update(delta)

func _physics_process(_delta):
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

func _look_update(_delta):
	var target=_get_target_coordinates()
	look_at(target)

func _get_target_coordinates()->Vector2:
	var mouse_position=get_viewport().get_mouse_position()
	return mouse_position

func _shoot():
	gun_sound.play()
	var bullet_instance=bullet.instance()
	var target=_get_target_coordinates()
	
	raycast.cast_to=to_local(target)
	raycast.force_raycast_update()
	if raycast.is_colliding():
		target=raycast.get_collision_point()
		var collision_node=raycast.get_collider().get_parent() as Node
		if collision_node.is_in_group("enemy"):
			collision_node.on_damage(damage)
	bullet_instance.set_path(position, target)
	owner.add_child(bullet_instance)
