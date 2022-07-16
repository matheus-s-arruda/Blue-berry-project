extends Control


onready var show_config = $"../cancel_config"
onready var credits = $"../credtis_screen"
onready var color_rects := [$"../ColorRect1", $"../ColorRect2", $"../ColorRect3", $"../ColorRect4"]

func _ready():
	AudioSystem.play_soundtrack(AudioSystem.SOUNDTRACKS_PATH[0])
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	for i in Globals.save.history_progress + 1:
		get_node("scene_" + str(i + 1)).visible = true
		color_rects[i].visible = true


func go_to_scene(extra_arg_0):
	var path = Constants.LEVEL_SCENE_PATH[extra_arg_0]
	var call = Constants.CallExecutioner.new(true, "transit_to", path)
	Globals.change_scene_with_params(Constants.TRANSITION_SCENE, [call])


func _on_credits_pressed():
	credits.visible = true


func _on_quit_pressed():
	get_tree().quit()


func _on_config_pressed():
	show_config.visible = true
