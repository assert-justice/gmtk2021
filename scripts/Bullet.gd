extends Area2D

export (Vector2) var velocity

func _physics_process(delta):
	position += velocity * delta
