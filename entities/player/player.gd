extends KinematicBody2D

class_name Player
# Our player is a kinematic body because interacts with the physics (e.g. collisions)
# But it is controlled by the player, not the physics engine

# Speed and famage are configurable
export var speed:float=100
export var damage:int=10

# The bullet (trail) is a separate scene that will be instanced when needed
# In this example is not needed, but in a real game, pre-instances and pooling
# can be used to improve performance
export (PackedScene) var bullet

# Raycast will be used to calculate collisions in our hitscan weapons (gun)
onready var gun_raycast:=$GunRaycast
onready var gun_sound:=$GunSound #BANG!

# Signals are used to notify of a change to another node (usually the parent) without hardcoding it
signal dead

func _process(delta): # Called on screen render (glorious FPS), delta is the time elapsed since last called
	_look_update(delta) # Rotate node to match global mouse position

func _physics_process(delta): # Called on physics render
	if Input.is_action_just_pressed("shoot"): # The "shoot" action can be configured in project settings
		_shoot()
	_movement_update(delta) # Updates player movement
	_collision_update() # Updates collision detection

func _movement_update(delta):
	var direction = Vector2()
	# First we set the direction, depending on the buttons pressed
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	
	# Normalize the direction vector (to make sure the distance traveled is 1 unit) and sets the 
	# actual velocity depending on player speed
	var velocity = direction.normalized() * speed
	# Move in the given direction and speed, delta is already taken into account
	# If a collision happens, the player will slide
	move_and_slide(velocity) 

func _look_update(_delta):
	# Returns global coordinates of the mouse in the world, not the screen position
	# Global means that it doesn't matter where the player is
	var target=_get_target_position()
	look_at(target)

func _shoot():
	gun_sound.play() # BANG!
	var bullet_instance=bullet.instance() # This instances our bullet trail that will fade, like tears in the rain
	# NOTE: if we were to use a lot of bullets in a performance intensive game, this instancing can be done
	# beforehand and then use and reuse the same nodes (pooling)
	
	var target=_get_target_position() 
	# Raycast will send a ray to the target, it works with local reference so we
	# convert the global target to local coordinates
	gun_raycast.cast_to=to_local(target) 
	# Raycast, by default, will run on the next physics_process
	# because we want to run it now, we will force the update
	gun_raycast.force_raycast_update()
	
	var collision_point=target # If we don't hit anything, the bullet will end on our mouse position
	if gun_raycast.is_colliding(): # We hit something? (Collider between the player and mouse)
		collision_point=gun_raycast.get_collision_point() # Updates the bullet position if we hit something
		var collision_node=gun_raycast.get_collider().get_parent() as Node # The thing we hit
		
		if collision_node.is_in_group("enemy"): # We use groups to identify enemies
			collision_node.on_damage(damage) # damage the enemy (enemy.gd)
	
	bullet_instance.set_path(position, collision_point) # Draws the bullet trail path (check bullet_trail.tscn)
	# To render any node, the node needs to be set as child of any element in the scene. We can set the node
	# as the child of the player, but then the trail will move along with the player
	# The owner node will be root scene, that doesn't move, so we set the bullet as part of it
	owner.add_child(bullet_instance)

func _collision_update():
	for i in get_slide_count(): # Iterate through all our collisions
		var collider := get_slide_collision(i).collider # The thing we are colliding with
		if collider.is_in_group("enemy"): # Is an enemy?
			emit_signal("dead") # DEAD, a signal is emitted, main will take core of our rotting corpse

func _get_target_position():
	# Returns global coordinates of the mouse in the world, not the screen position
	# Global means that it doesn't matter where the player is
	return get_global_mouse_position() 
