extends Node

var navigation:Navigation2D

func get_navigation_path(from:Vector2, to:Vector2)->PoolVector2Array:
	if not navigation:
		return PoolVector2Array([])
	else:
		return navigation.get_simple_path(from ,to)
