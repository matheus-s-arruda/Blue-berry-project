extends Control


func _ready():
	if Globals.save.history_progress:
		for i in Globals.save.history_progress:
			get_node("scene_" + str(i +1)).disabled = false


func _on_credits_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()


func go_to_scene(extra_arg_0):
	var path = Constants.LEVEL_SCENE_PATH[extra_arg_0]
	var call = Constants.CallExecutioner.new(true, "transit_to", path)
	Globals.change_scene_with_params(Constants.TRANSITION_SCENE, [call])
