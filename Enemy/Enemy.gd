extends KinematicBody2D

var health = 100
var velocity = Vector2.ZERO
var speed_limit = 10
var drag = 0.05

var Enemy_Bullet = load("res://Enemy_Bullet/Enemy_Bullet.tscn")
onready var Bullets = get_node("/root/Game/Bullets")
var speed = 2
var ready_to_move = true
var Explosion = load("res://Explosion/Explosion.tscn")
onready var Explosions = get_node("/root/Game/Explosions")

func _ready():
	randomize()

func _physics_process(_delta):
	position += velocity
	if velocity.length() > speed_limit:
		velocity = velocity.normalized() * speed_limit
	if velocity.length() > drag:
		velocity = velocity.normalized() * (velocity.length() - drag)
	position.x = wrapf(position.x,0,Global.width)
	position.y = wrapf(position.y,0,Global.height)
	
	$Health.value = health
	$Health.set_rotation(-rotation)
	if health >= 100:
		$Health.hide()
	else:
		$Health.show()
	if health > 70:
		$Health.tint_progress = Color8(116,184,22)
	elif health > 40:
		$Health.tint_progress = Color8(240,140,0)
	else:
		$Health.tint_progress = Color8(224,49,49)

func damage(d):
	health -= d
	if health <= 0:
		queue_free()

func die(s):
	var explosion = Explosion.instance()
	explosion.position = position
	Explosions.add_child(explosion)
	explosion.playing = true
	Global.score += s
	queue_free()


func _on_Shoot_timeout():
	if randf() < 0.2 and position.y > 0:
		var enemy_bullet = Enemy_Bullet.instance()
		enemy_bullet.position = position
		Bullets.add_child(enemy_bullet)


func _on_Move_timeout():
	if randf() < 0.2 and ready_to_move:
		var new_position = Vector2(randi() % 1024,randi() % 450)
		$Tween.interpolate_property(self, "position", position, new_position, speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
		ready_to_move = false

func _on_Tween_tween_all_completed():
	ready_to_move = true
