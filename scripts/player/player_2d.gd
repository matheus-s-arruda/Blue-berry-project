extends KinematicBody2D

const SPEED := 600

var can_move := true
var look_at_mouse := false setget update_hands

var motion : Vector2
var _move : Vector2

onready var body := $body
onready var head := $body/head
onready var animation := $AnimationPlayer


func _physics_process(_delta):
	_move_input()
	
	if look_at_mouse:
		var direction = global_position.direction_to(get_global_mouse_position())
		if direction.x > 0:
			head.rect_rotation = rad2deg(direction.angle())
		else:
			head.rect_rotation = rad2deg(-direction.angle()) - 180
		
		if direction.x: body.rect_scale.x = sign(direction.x)
		animation.play("mid_run" if _move else "idle")
	else:
		if _move.x: body.rect_scale.x = _move.x
		animation.play("run" if _move else "idle")
	
	motion = move_and_slide(motion)


func _move_input():
	if can_move:
		_move.y = Input.get_axis("move_up", "move_down")
		_move.x = Input.get_axis("move_left", "move_right")
	
	motion = lerp(motion, _move.normalized() * SPEED, 0.25)


func update_hands(value):
	look_at_mouse = value
	$body/arm_L.visible = !look_at_mouse
	$body/arm_R.visible = !look_at_mouse
	$body/head/arm_l.visible = look_at_mouse
	$body/head/arm_r.visible = look_at_mouse
	$body/head/weapon.visible = look_at_mouse
	if not look_at_mouse: head.rect_rotation = 0

