extends Control

func _physics_process(_delta):
	$Score.text = "score: " + str(Global.score)
