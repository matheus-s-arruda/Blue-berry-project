extends PlayerBasics3D

signal take_damage

const BULLET = preload("res://scenes/player/player_bullet_3D.tscn")

const SHOOT_DELAY := 0.15

export var can_shoot := false

var shoot_in_delay := 0.0
var camera_pivot_target : Vector3

onready var animation = $AnimationPlayer
onready var camera_pivot = $"../camera_pivot"
onready var camera = $"../camera_pivot/Camera"
onready var weapon_cannon = $mesh/mesh/weapon
onready var mesh := $mesh


func _physics_process(delta):
	var plane = Plane(Vector3.UP, 0)
	var mouse_pos = get_viewport().get_mouse_position()
	var origin = camera.project_ray_origin(mouse_pos)
	var rayEnd = origin + camera.project_ray_normal(mouse_pos) * 2000
	var p = plane.intersects_ray(camera.global_transform.origin, rayEnd)
	var d = global_transform.origin.direction_to(p).x
	
	var target = Vector3(p.x, 0, p.z) - Vector3(0, 0, sign(d))
	var new_transform = mesh.global_transform.looking_at(target, Vector3.UP)
	
	var length_origin_target : Vector3
	if can_move:
		move_input(Vector3(Input.get_axis("move_left", "move_right"), 0, Input.get_axis("move_up", "move_down")))
		mesh.global_transform = mesh.global_transform.interpolate_with(new_transform, 0.2)
		length_origin_target = ((target - global_transform.origin) * 0.3)
	
	var _camera_pivot_target = global_transform.origin + Vector3(0, 0, 2) + length_origin_target
	
	camera_pivot_target = lerp(camera_pivot_target, _camera_pivot_target, 0.1)
	camera_pivot.global_transform.origin = camera_pivot_target * Vector3(1, 0, 1)
	
	if shoot_in_delay > 0.0:
		shoot_in_delay -= delta
	
	if shoot_in_delay <= 0.0 and can_shoot and Input.is_action_pressed("mouse_click"):
		shoot_in_delay = SHOOT_DELAY
		shot()


func shot():
	var bullet = BULLET.instance()
	get_parent().add_child(bullet)
	bullet.global_transform = weapon_cannon.global_transform
	AudioSystem.shot_audio(AudioSystem.BULLET_LAZER)


func die():
	can_move = false
	can_shoot = false
	animation.play("die")


func _on_hurtbox_area_entered(_area):
	emit_signal("take_damage")
