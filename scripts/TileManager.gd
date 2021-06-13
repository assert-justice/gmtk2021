extends Node2D

var flr = null
var pool = []
var player = null
var in_use = []
var floor_height = 18 * 72

func _ready():
	flr = $Floor
	pool = [$Roku, $Frank]
	in_use = [$Floor, $Empty, $Empty2]
	player = get_tree().get_nodes_in_group("player")[0]

func _physics_process(delta):
	# if we need a new floor spawned
	if in_use[-1].position.y > player.position.y:
		# remove second element from array
		in_use.pop_front()
		var temp = in_use.pop_front()
		temp.position.x = - 15 * 72
		pool.append(temp)
		in_use.push_front(flr)
		flr.position.y -= floor_height
		var idx = rand_range(0, len(pool))
		var new_chunk = pool[idx]
		pool.remove(idx)
		new_chunk.position.y = in_use[-1].position.y - floor_height
		new_chunk.position.x = 0
		in_use.push_back(new_chunk)
