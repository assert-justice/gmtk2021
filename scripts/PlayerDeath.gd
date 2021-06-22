extends Node


func _on_Timer_timeout():
	#load lose state
	get_parent().get_parent().reload()
