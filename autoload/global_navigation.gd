extends Node
# This node is an autoload node, it will be loaded at the baginning and will be available to any node

# This node will be loaded by our main node, to ensure everything is ready and decoupled
var navigation:Navigation2D

# Given 2 points, returns the path using our navigation, empty array if navigation is not available
func get_navigation_path(from:Vector2, to:Vector2)->PoolVector2Array:
	if not navigation:
		return PoolVector2Array([])
	else:
		return navigation.get_simple_path(from ,to)
