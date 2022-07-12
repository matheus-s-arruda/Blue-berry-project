extends KinematicBody

const GRAVITY := 9.8
const MOVE_SPEED := 6
const MOUSE_SENSITIVITY := 0.1

export(bool) var enable_gravity := false

var can_move := true

var motion : Vector3

onready var camera := $cam_pivot/Camera
onready var cam_pivot := $cam_pivot


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	if can_move:
		_move_input()
	else:
		motion = Vector3.ZERO
	
	if enable_gravity:
		motion.y -= GRAVITY * delta * int(is_on_floor())
	
	motion = move_and_slide(motion, Vector3.UP, true, 4, .785398, false)


func _input(event):
	if event is InputEventKey and Input.is_key_pressed(KEY_ESCAPE):
		Input.set_mouse_mode((Input.get_mouse_mode() + 2) % 4)
	
	if can_move and event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg2rad(-event.relative.x * MOUSE_SENSITIVITY))
		cam_pivot.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY))


func _move_input():
	var move_direction : Vector3
	move_direction.z = Input.get_axis("move_down", "move_up")
	move_direction.x = Input.get_axis("move_right", "move_left")
	
	move_direction = (move_direction.x * transform.basis.x) + (move_direction.z * transform.basis.z)
	motion = lerp(motion, move_direction.normalized() * MOVE_SPEED, 0.25)
