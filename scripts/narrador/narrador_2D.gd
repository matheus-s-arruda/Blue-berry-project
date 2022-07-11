extends Panel

enum Emotions {NORMAL, ANGRY, IMPRESS, SAD, SERIUS}


export(Emotions) var emotion : int
export var direction_eyes : Vector2


onready var eyebrow_R = $eyebrowR
onready var eyebrow_L = $eyebrowL
onready var pupil_L = $marginL/eyeR/pupil
onready var pupil_R = $marginR/eyeR/pupil


func _ready():
	change_emotion(Emotions.NORMAL)
	eye_direction(Vector2(3.0, 5.0))


func change_emotion(new_emotion : int):
	emotion = new_emotion
	
	eyebrow_R.rect_position.y = 47
	eyebrow_L.rect_position.y = 47
	eyebrow_R.rect_rotation = 0.0
	eyebrow_L.rect_rotation = 0.0
	pupil_R.rect_scale = Vector2(0.6, 0.6)
	pupil_L.rect_scale = Vector2(0.6, 0.6)
	
	match emotion:
		Emotions.SERIUS:
			pupil_R.rect_scale = Vector2(0.5, 0.5)
			pupil_L.rect_scale = Vector2(0.5, 0.5)
		
		Emotions.IMPRESS:
			pupil_R.rect_scale = Vector2(0.35, 0.35)
			pupil_L.rect_scale = Vector2(0.35, 0.35)
		
		Emotions.SAD:
			eyebrow_R.rect_rotation = -19
			eyebrow_L.rect_rotation = 19
			eyebrow_R.rect_position.y = 57
			eyebrow_L.rect_position.y = 57
		
		Emotions.ANGRY:
			eyebrow_R.rect_rotation = 20
			eyebrow_L.rect_rotation = -20
			pupil_R.rect_scale = Vector2(0.4, 0.4)
			pupil_L.rect_scale = Vector2(0.4, 0.4)


func eye_direction(_direction_eyes : Vector2):
	direction_eyes = _direction_eyes
	
	if direction_eyes.length() > 6.0:
		direction_eyes = direction_eyes.normalized() * 6.0
	
	pupil_L.rect_position = direction_eyes
	pupil_R.rect_position = direction_eyes
