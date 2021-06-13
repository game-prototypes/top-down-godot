extends Line2D

func _on_animation_finished(anim_name):
	queue_free()
