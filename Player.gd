extends KinematicBody2D

var gravity = 6
var max_speed = 60
var acceleration = 10
var jump_height = -100
var friction = 15
var fall_gravity = 2

var double_jump = 1


var velocity = Vector2.ZERO

func _ready():
	Global.time = 12

func _physics_process(_delta):
	apply_gravity()
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if input.x == 0:
		apply_friction()
	else:
		if $Timer.is_stopped():
			$Timer.start()
		if $Music.is_playing() ==  true:
			pass
		else:
			$Music.play()
		print (velocity)
		$AnimatedSprite.animation = "run"
		apply_acceleration(input.x)
		if input.x > 0:
			$AnimatedSprite.flip_h = false
		else:
			$AnimatedSprite.flip_h = true
	
	if is_on_floor():
		double_jump = 1 
		if Input.is_action_pressed("ui_accept"):
			$Jump.play()
			velocity.y = jump_height
	else:
		$AnimatedSprite.animation = "jump"
		if Input.is_action_just_pressed("ui_accept") and double_jump == 1:
			$Jump.play()
			double_jump = 0
			velocity.y = 0
			$AnimatedSprite.animation = "jump"
			velocity.y += jump_height

	
	if velocity.y > 7:
		$AnimatedSprite.play("fall")
		velocity.y += fall_gravity
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
func apply_gravity():
	velocity.y += gravity

func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, max_speed * amount, acceleration)

func apply_friction():
	$AnimatedSprite.animation = "stop"
	velocity.x = move_toward(velocity.x, 0, friction)
	
func coffee():
	max_speed = 80
	acceleration = 20
	$CoffeeTimer.start()


func _on_CoffeeTimer_timeout():
	max_speed = 60
	acceleration = 10

func slowdown():
	max_speed = 30
	$SlowTimer.start()


func _on_SlowTimer_timeout():
	max_speed = 60
	
func die():
	queue_free()
	get_tree().reload_current_scene()
	
func add_time():
	Global.time += 10


func _on_Timer_timeout():
	Global.time -= 1


func _on_Door_body_entered(body):
	if body.is_in_group("Player"):
		$Timer.stop()
		get_tree().change_scene("res://GameOver.tscn")
