extends KinematicBody2D

signal suffered_damage

const SPEED := 800

export var sudo_can_move := true
var can_move := true setget update_move

var look_at_mouse := false setget update_hands

var dead := false
var has_dead := false
var motion : Vector2
var _move : Vector2

onready var shooter := $body/head/weapon/shooter
onready var shadow := $shadow
onready var body := $body
onready var head := $body/head
onready var animation := $AnimationPlayer


func _physics_process(_delta):
	_move_input()
	if not dead:
		if look_at_mouse:
			var direction = global_position.direction_to(get_global_mouse_position())
			if direction.x > 0:
				head.rect_rotation = rad2deg(direction.angle())
			else:
				head.rect_rotation = rad2deg(-direction.angle()) - 180
			
			if direction.x: body.rect_scale.x = sign(direction.x)
			animation.play("mid_run" if _move else "idle")
		else:
			if _move.x: body.rect_scale.x = sign(_move.x)
			animation.play("run" if _move else "idle")
	else:
		if not has_dead:
			has_dead = true
			AudioSystem.shot_audio(AudioSystem.PLAYER_DIE)
			animation.play("die")
	
	motion = move_and_slide(motion)


func _move_input():
	if can_move and sudo_can_move:
		_move.y = Input.get_axis("move_up", "move_down")
		_move.x = Input.get_axis("move_left", "move_right")
	
	motion = lerp(motion, _move.normalized() * SPEED, 0.25)


func update_move(value):
	can_move = value
	if not can_move: _move = Vector2.ZERO


func update_hands(value):
	look_at_mouse = value
	$body/arm_L.visible = !look_at_mouse
	$body/arm_R.visible = !look_at_mouse
	$body/head/arm_l.visible = look_at_mouse
	$body/head/arm_r.visible = look_at_mouse
	$body/head/weapon.visible = look_at_mouse
	if not look_at_mouse: head.rect_rotation = 0


func _on_hurbox_area_entered(_area):
	emit_signal("suffered_damage")
