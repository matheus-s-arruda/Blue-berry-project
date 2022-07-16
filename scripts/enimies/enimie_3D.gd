extends KinematicBody


export var can_move := true

var speed := 9.5
var life := 8 setget update_life
var motion : Vector3
var direction : Vector3

var nav_path : PoolVector3Array
var corrent_nav_step := 0
var can_update_path := false setget update_can_nav_path

var update_timer := 0.0
var attack_timer := 0.0

onready var scene_root = $"../../.."
onready var player_target : Spatial = $"../../../player_top_down_3D"
onready var navmap : Navigation = $"../../../Navigation"
onready var mesh = $mesh
onready var collision_attack = $mesh/hitbox/CollisionShape
onready var animation = $mesh/AnimationPlayer


func _physics_process(delta):
	direction = Vector3.ZERO
	if update_timer > 0.0: update_timer -= delta
	if attack_timer > 0.0: attack_timer -= delta
	
	if can_move:
		if corrent_nav_step < nav_path.size():
			direction = nav_path[corrent_nav_step] - global_transform.origin
			if direction.length() < 1: corrent_nav_step += 1
			if corrent_nav_step < nav_path.size(): rotate_mesh()
			
		if global_transform.origin.distance_to(player_target.global_transform.origin) > 1:
			if direction: animation.play("run")
			else: animation.play("idle")
			
			if update_timer <= 0.0 and can_update_path:
				update_path(player_target.global_transform.origin)
				update_timer = 0.1
		
		else: attack()
	else: animation.play("idle")
	
	motion = lerp(motion, direction.normalized() * speed, 0.25)
	motion = move_and_slide(motion, Vector3.UP)


func update_path(target_position : Vector3):
	nav_path = navmap.get_simple_path(global_transform.origin, target_position)
	corrent_nav_step = 0


func rotate_mesh():
	var t = Vector3(nav_path[corrent_nav_step].x, 0, nav_path[corrent_nav_step].z)
	var new_transform = mesh.global_transform.looking_at(t, Vector3.UP)
	mesh.global_transform  = mesh.global_transform.interpolate_with(new_transform, 0.1)


func disable():
	set_physics_process(false)


func attack():
	if attack_timer <= 0.0:
		attack_timer = 1.0
		animation.play("attack")


func update_life(value):
	life = value
	if not can_update_path: get_parent().alert_all()
	
	if life <= 0:
		life = 100
		AudioSystem.shot_audio(AudioSystem.ENEMY_DYING)
		remove_mesh()
		get_parent().call_deferred("count_childs")
		get_parent().remove_child(self)
		queue_free()


func remove_mesh():
	var t = mesh.global_transform
	remove_child(mesh)
	scene_root.add_child(mesh)
	mesh.global_transform = t
	animation.play("die")


func update_can_nav_path(value):
	can_update_path = value
	if can_update_path:
		var audio = [AudioSystem.ENEMY_ROAR_1, AudioSystem.ENEMY_ROAR_2, AudioSystem.ENEMY_ROAR_3]
		AudioSystem.play(audio[randi() % 3], AudioSystem.volume_effects)



