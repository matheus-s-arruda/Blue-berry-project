extends Control


onready var show_config = $"../cancel_config"


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if Globals.save.history_progress:
		for i in Globals.save.history_progress:
			get_node("scene_" + str(i +1)).visible = true


func go_to_scene(extra_arg_0):
	var path = Constants.LEVEL_SCENE_PATH[extra_arg_0]
	var call = Constants.CallExecutioner.new(true, "transit_to", path)
	Globals.change_scene_with_params(Constants.TRANSITION_SCENE, [call])


func _on_credits_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()


func _on_config_pressed():
	show_config.visible = true
