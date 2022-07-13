extends Node


class CallExecutioner extends Reference:
	var is_func : bool
	var call : String
	var value
	
	func _init(_is_func : bool, _call : String, _value = null):
		is_func = _is_func; call = _call; value = _value
	
	func execute(node : Node):
		if is_func:
			if value: node.call(call, value)
			else: node.call(call)
		else:
			node.call("set", call, value)





func change_scene_with_params(scene_path : String, params : Array):
	var loader = ResourceLoader.load_interactive(scene_path)
	if not loader:
		return
	
	while true:
		var err = loader.poll()
		if err == ERR_FILE_EOF:
			var scene = loader.get_resource().instance()
			
			get_tree().get_root().call_deferred('add_child', scene)
			get_tree().current_scene.queue_free()
			
			yield(get_tree(),"idle_frame")
			get_tree().set_current_scene(scene)
			
			for calls in params:
				calls.execute(scene)
			break
			
		elif err != OK:
#			var _err = get_tree().change_scene("res://scenes/main/main.tscn")
			break
		yield(get_tree(),"idle_frame")
