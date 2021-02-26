extends Area2D

var velocity = Vector2(0,-10)
var Explosion = load("res://Explosion/Explosion.tscn")
onready var Explosions = get_node("/root/Game/Explosions")

func _physics_process(_delta):
	position += velocity
	if position.y < -20:
		queue_free()

func _on_Bullet1_body_entered(body):
	body.die(10)
	#var explosion = Explosion.instance()
	#explosion.position = position
	#Explosions.add_child(explosion)
	#explosion.playing = true
	queue_free()
