extends PlayerBasics3D

const MOUSE_SENSITIVITY := 0.1


onready var camera := $cam_pivot/Camera
onready var cam_pivot := $cam_pivot


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
	if event is InputEventKey and Input.is_key_pressed(KEY_Q):
		Input.set_mouse_mode((Input.get_mouse_mode() + 2) % 4)
	
	if can_move and event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg2rad(-event.relative.x * MOUSE_SENSITIVITY))
		cam_pivot.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY))

