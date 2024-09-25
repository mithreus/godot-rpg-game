extends CharacterBody2D

var enemy_in_range = false
var enemy_attack_cooldown = true
var health = 100
var alive = true
var attack_ip = false

const SPEED = 80.0
const JUMP_VELOCITY = -400.0
var current_dir = "none"
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$AnimatedSprite2D.play("front_idle")

func _physics_process(delta):
	enemy_attack()
	player_movement(delta)
	attack()
	
	if health <= 0:
		alive = false
		health = 0
		print("you died")
		self.queue_free()
	
func player_movement(delta):
	if Input.is_action_pressed("ui_right") || Input.is_action_pressed("Keyboard_D"):
		current_dir = "right"
		play_anim(1)
		velocity.x = SPEED
		velocity.y = 0
	elif Input.is_action_pressed("ui_left") || Input.is_action_pressed("Keyboard_A"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -SPEED
		velocity.y = 0
	elif Input.is_action_pressed("ui_down")|| Input.is_action_pressed("Keyboard_S"):
		current_dir = "down"
		play_anim(1)
		velocity.x = 0 
		velocity.y = SPEED
	elif Input.is_action_pressed("ui_up")|| Input.is_action_pressed("Keyboard_W"):
		current_dir = "up"
		play_anim(1)
		velocity.x = 0 
		velocity.y = -SPEED
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
		
	move_and_slide()

func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
	if dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("front_idle")
	if dir == "up":
		anim.flip_h = true
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("back_idle")


func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_in_range = true
		
func _on_player_hitbox_body_exited(body):
		if body.has_method("enemy"):
			enemy_in_range = false

func player():
	pass
	
func enemy_attack():
	if enemy_in_range and enemy_attack_cooldown == true:
		health = health - 20
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(health)

func _on_attack_cooldown_timeout():
	$attack_cooldown.stop()
	enemy_attack_cooldown = true
	
func attack():
	var dir = current_dir
	if Input.is_action_just_pressed("attack"):
		global.player_current_attack = true
		attack_ip = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "down":

			$AnimatedSprite2D.play("front_attack")
			$deal_attack_timer.start()
		if dir == "up":
			$AnimatedSprite2D.play("back_attack")
			$deal_attack_timer.start()

func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false
