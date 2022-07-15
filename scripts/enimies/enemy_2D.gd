extends KinematicBody2D

var max_speed := 300

var life := 10 setget update_life

var can_move := true
var attack_timer := 0.0
var direction : Vector2
var motion : Vector2
var player : Node2D

func _physics_process(delta):
	if can_move:
		direction = lerp(direction, global_position.direction_to(player.global_position), 0.2)
	
	if attack_timer > 0.0:
		attack_timer -= delta
	
	var speed := direction * max_speed
	if can_move and global_position.distance_to(player.global_position) < 100:
		speed = Vector2.ZERO
		attack()
	
	$sprite.scale.x = direction.sign().x
	$AnimationPlayer.play("run" if motion.length() > 10 else "idle")
	
	motion = lerp(motion, speed if can_move else Vector2.ZERO, 0.1)
	motion = move_and_slide(motion)


func desative_self():
	can_move = false


func update_life(value : int):
	life = value
	if life <= 0:
		player.kills += 1
		life = 100
		AudioSystem.shot_audio(AudioSystem.ENEMY_DYING, AudioSystem.volume_effects)
		queue_free()


func attack():
	if attack_timer <= 0.0:
		attack_timer = 1.0
		$AnimationPlayer2.play("attack")
