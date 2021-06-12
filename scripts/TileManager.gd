extends Node2D

var flr = null
var empty = []
var player = null
var in_use = []
var floor_height = 18 * 72

func _ready():
	flr = $Floor
	empty = [$Empty, $Empty2]
	in_use = [$Floor, $Empty, $Empty2]
	player = get_tree().get_nodes_in_group("player")[0]

func _physics_process(delta):
	# if we need a new floor spawned
	if in_use[-1].position.y > player.position.y:
		# remove second element from array
		in_use.pop_front()
		var temp = in_use.pop_front()
		in_use.push_front(flr)
		flr.position.y -= floor_height
		temp.position.y = in_use[-1].position.y - floor_height
		in_use.push_back(temp)
