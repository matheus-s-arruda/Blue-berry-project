class_name PlayerBasics3D extends KinematicBody

const GRAVITY := 9.8
const MOVE_SPEED := 6

export(bool) var enable_gravity := false

var can_move := true
var motion : Vector3


func _physics_process(delta):
	if can_move:
		_move_input()
	else:
		motion = Vector3.ZERO
	
	if enable_gravity:
		motion.y -= GRAVITY * delta * int(is_on_floor())
	
	motion = move_and_slide(motion, Vector3.UP, true, 4, .785398, false)



func _move_input():
	var move_direction : Vector3
	move_direction.z = Input.get_axis("move_down", "move_up")
	move_direction.x = Input.get_axis("move_right", "move_left")
	
	move_direction = (move_direction.x * transform.basis.x) + (move_direction.z * transform.basis.z)
	motion = lerp(motion, move_direction.normalized() * MOVE_SPEED, 0.25)

