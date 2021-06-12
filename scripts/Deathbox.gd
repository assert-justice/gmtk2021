extends CollisionShape2D

func _draw():
	var rect = Rect2(Vector2.ZERO, shape.extents)
	draw_rect(rect, Color.red)
