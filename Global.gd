extends Node

var score = 0
var width = 7146
var height = 2930

func _process(_delta):
	if Input.is_action_pressed("quit"):	
		get_tree().quit()
