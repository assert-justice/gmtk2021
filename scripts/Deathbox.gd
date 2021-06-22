extends Area2D

export (Vector2) var velocity = Vector2()

func _physics_process(delta):
	position += velocity * delta

func _draw():
	var rect = Rect2(-$CollisionShape2D.shape.extents, $CollisionShape2D.shape.extents * 2)
	draw_rect(rect, Color.red)


func _on_Deathbox_body_entered(body):
	if body.is_in_group("player"):
		body.emit_signal("kill")
