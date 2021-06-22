extends Camera2D
var max_y = 0
var player = null

func _ready():
	max_y = position.y
	player = get_tree().get_nodes_in_group("player")[0]

func _process(delta):
	if player == null:
		return
	if player.position.y > max_y:
		position.y = max_y
	else:
		position.y = player.position.y
