extends Node

export (PackedScene) var main_menu_scene
export (PackedScene) var game_scene
export (PackedScene) var lose_scene
var gs
export var best_height = 0

func _ready():
	gs = game_scene.instance()
	add_child(gs)
	
func reload():
	remove_child(gs)
	gs.queue_free()
	gs = game_scene.instance()
	add_child(gs)
