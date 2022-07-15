extends PlayerBasics3D

signal take_damage

const BULLET = preload("res://scenes/player/player_bullet_3D.tscn")
const MOUSE_PROJECT_PLANE = Plane(Vector3.UP, 0)

const SHOOT_DELAY := 0.15

export var can_shoot := false

var is_dead := false
var shoot_in_delay := 0.0
var camera_pivot_target : Vector3
var mesh_transform : Transform

onready var animation = $mesh/jogador/AnimationPlayer
onready var camera_pivot = $"../camera_pivot"
onready var camera = $"../camera_pivot/Camera"
onready var weapon_cannon = $mesh/weapon
onready var mesh := $mesh


func _physics_process(delta):
	var m_pos = get_3D_mouse_position()
	var target = Vector3(m_pos.x, 0, m_pos.z) - Vector3(0, 0, sign(global_transform.origin.direction_to(m_pos).x))
	
	var length_origin_target : Vector3
	var direction : Vector3
	
	if can_move:
		direction = Vector3(Input.get_axis("move_left", "move_right"), 0, Input.get_axis("move_up", "move_down"))
		if direction: animation.play("run")
		else: animation.play("idle")
		
		length_origin_target = ((target - global_transform.origin) * 0.3)
	
	move_input(direction)
	
	var _camera_pivot_target = global_transform.origin + Vector3(0, 0, 2) + length_origin_target
	camera_pivot_target = lerp(camera_pivot_target, _camera_pivot_target, 0.1)
	camera_pivot.global_transform.origin = camera_pivot_target * Vector3(1, 0, 1)
	
	if shoot_in_delay > 0.0:
		shoot_in_delay -= delta
	
	if can_shoot and Input.is_action_pressed("mouse_click") and shoot_in_delay <= 0.0:
		shoot_in_delay = SHOOT_DELAY
		shot()
	
	mesh_transform = mesh.global_transform.looking_at(target, Vector3.UP)
	mesh.global_transform = mesh.global_transform.interpolate_with(mesh_transform, 0.3)


func get_3D_mouse_position():
	var mouse_pos = get_viewport().get_mouse_position()
	var origin = camera.project_ray_origin(mouse_pos)
	var rayEnd = origin + camera.project_ray_normal(mouse_pos) * 2000
	return MOUSE_PROJECT_PLANE.intersects_ray(camera.global_transform.origin, rayEnd)


func shot():
	var bullet = BULLET.instance()
	get_parent().add_child(bullet)
	bullet.global_transform = weapon_cannon.global_transform
	AudioSystem.shot_audio(AudioSystem.BULLET_LAZER, AudioSystem.volume_effects)


func die():
	AudioSystem.shot_audio(AudioSystem.PLAYER_DIE, AudioSystem.volume_effects)
	is_dead = true
	can_move = false
	can_shoot = false
	animation.play("die")


func _on_hurtbox_area_entered(_area):
	emit_signal("take_damage")
