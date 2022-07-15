extends Control


func _ready():
	if Globals.save.history_progress:
		for i in Globals.save.history_progress:
			get_node("scene_" + str(i + 1)).disabled = false


func _on_continue_pressed():
	var path = Constants.LEVEL_SCENE_PATH[0]
	var call = Constants.CallExecutioner.new(true, "transit_to", path)
	
	Globals.change_scene_with_params(Constants.TRANSITION_SCENE, [call])


func _on_credits_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()
