extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 0.2
var speed_limit = 10
var rot = 5

onready var VP = get_viewport_rect().size

onready var Enemy = get_node_or_null("/root/Game/Enemies/Enemy")
onready var Camera = get_node_or_null("/root/Game/Camera")
onready var Bullets = get_node_or_null("/root/Game/Bullets")

var Bullet1 = load("res://Bullets/Bullet1.tscn")
var Bullet2 = load("res://Bullets/Bullet2.tscn")

var shield_deplete = false
var shield_strength = 100
var damage = 0.5
var regenerate = 0.1

var health = 100

var shield_textures = [
	load("res://Assets/shield.png")
	,load("res://Assets/shield2.png")
	,load("res://Assets/shield3.png")
]

var shoot_counter = 0
var shoot_period = 10

func _physics_process(_delta):
	position += velocity
	velocity += get_input()*speed
	if velocity.length() > speed_limit:
		velocity = velocity.normalized() * speed_limit
	position.x = wrapf(position.x,0,Global.width)
	position.y = wrapf(position.y,0,Global.height)
	
	#Health
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

	#Camera
	if Enemy != null:
		var distance = position - Enemy.position 
		var midway = (Enemy.global_position - global_position)/2 + global_position
		var ratio = (distance.length() / VP.length()) * 1.9
		ratio = clamp(ratio, 1, 4)
		Camera.global_position = midway
		Camera.zoom = Vector2(ratio,ratio)
	else:
		Enemy = get_node_or_null("/root/Game/Enemies/Enemy")
	
	
	#Shield
	if shield_deplete:
		shield_strength -= damage
		if shield_strength >= 75:
			$Shield/Sprite.texture = shield_textures[0]
		elif shield_strength >= 40:
			$Shield/Sprite.texture = shield_textures[1]
		elif shield_strength >= 0:
			$Shield/Sprite.texture = shield_textures[2]
		else:
			$Shield/Sprite.hide()
	else:
		shield_strength += regenerate
	shield_strength = clamp(shield_strength,0,100)
	
	
	#Weapon systems
	if Input.is_action_just_pressed("shoot1"):
		var bullet = Bullet1.instance()
		var nose = Vector2(0, -60)
		bullet.position = position + nose.rotated(rotation)
		bullet.rotation = rotation
		bullet.velocity = bullet.velocity.rotated(rotation) + velocity
		Bullets.add_child(bullet)
		
	if Input.is_action_just_pressed("shoot2"):
		var bullet2 = Bullet2.instance()
		var nose = Vector2(0, -60)
		bullet2.position = position + nose.rotated(rotation)
		bullet2.rotation = rotation
		bullet2.velocity = bullet2.velocity.rotated(rotation) + velocity
		Bullets.add_child(bullet2)

	#Movement
func get_input():
	var input_vector = Vector2.ZERO
	$Thrust.hide()
	if Input.is_action_pressed("up"):
		input_vector.y -= 1
		$Thrust.show()
	if Input.is_action_pressed("left"):
		rotation_degrees -= rot
	if Input.is_action_pressed("right"):
		rotation_degrees += rot
	return input_vector.rotated(rotation)

func die(_s):
	queue_free()


func _on_Shield_body_entered(body):
	$Shield/Sprite.show()
	shield_deplete = true
	var d = body.global_position - global_position
	var force = 0.1
	body.velocity += d*force

func _on_Shield_body_exited(_body):
	$Shield/Sprite.hide()
	shield_deplete = false
