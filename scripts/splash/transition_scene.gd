extends Control


func _ready():
	$narrador.change_emotion($narrador.Emotions.SAD)


func _process(_delta):
	$narrador.eye_direction(Vector2(randf() - 0.5, randf() - 0.5) * 2.0)


func transit_to(path : String, _calls := []):
	Globals.change_scene_with_params(path, [])


