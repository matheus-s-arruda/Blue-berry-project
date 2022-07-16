class_name PlayerBasics3D extends KinematicBody

const GRAVITY := 13.8

export(float, 0, 1) var motion_smooth := 0.25
export var move_speed := 6
export(bool) var enable_gravity := false
export var can_move := true

var motion : Vector3


func _physics_process(delta):
	if enable_gravity:
		motion.y -= GRAVITY * delta
	
	motion = move_and_slide(motion, Vector3.UP, true, 4, .785398, false)


func move_input(move_direction : Vector3):
	move_direction = (move_direction.x * transform.basis.x) + (move_direction.z * transform.basis.z)
	motion.x = lerp(motion.x, move_direction.normalized().x * move_speed, motion_smooth)
	motion.z = lerp(motion.z, move_direction.normalized().z * move_speed, motion_smooth)
