extends CharacterBody2D

var speed = 50
var player_chase = false
var player = null

var health = 100
var player_in_attack_area = false

func _ready():
	player_chase = false
	player = null
	$AnimatedSprite2D.play("idle_side")
	
func _physics_process(delta):
	deal_with_damage()
	
	if player_chase:
		position += (player.position - position)/speed
		$AnimatedSprite2D.play("walk_side")
	else:
		$AnimatedSprite2D.play("idle_side")
	
	move_and_slide()
func _on_detection_area_body_entered(body):
	player = body # Replace with function body.
	player_chase = true

func _on_detection_area_body_exited(body):
	player = null # Replace with function body.
	player_chase = false

func enemy():
	pass


func _on_enemy_hitbox_body_entered(body):
		if body.has_method("player"):
			player_in_attack_area = true


func _on_enemy_hitbox_body_exited(body):
		if body.has_method("player"):
			player_in_attack_area = false

func deal_with_damage():
	if player_in_attack_area and global.player_current_attack == true:
		health = health - 20
		print("enemy health = ", health)
		if health <= 0:
			self.queue_free()
