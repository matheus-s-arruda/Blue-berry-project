extends Node

const SAVE_DIR_PATH := "user://yamig/"
const SAVE_NAME_PATH := "bandeclay.sv"
const SAVE_TEMPLATE := {
	"history_progress" : 0,
	"volume_music" : -5,
	"volume_dialogue" : -5,
	"volume_effects" :10,
	"volume_master" : 0.9,
}


var save := SAVE_TEMPLATE.duplicate(true)


func _init():
	var dir = Directory.new()
	if not dir.dir_exists(SAVE_DIR_PATH):
		if dir.make_dir(SAVE_DIR_PATH) != OK:
			print("!!! tentativa de cirar diretorio SAVE_DIR_PATH falhou. \n")
	
	load_sv()
	for element in SAVE_TEMPLATE:
		if not save.has(element): save[element] = SAVE_TEMPLATE[element]


func load_sv():
	var file : File = File.new()
	if not file.file_exists(SAVE_DIR_PATH + SAVE_NAME_PATH):
		save_sv()
		return
	if file.open(SAVE_DIR_PATH + SAVE_NAME_PATH, File.READ) == OK:
		var new_sv = file.get_var()
		file.close()
		if new_sv is Dictionary: save = new_sv
		else: save_sv()
	else: save_sv()


func save_sv():
	var file = File.new()
	if file.open(SAVE_DIR_PATH + SAVE_NAME_PATH, File.WRITE) == OK:
		file.store_var(save)
		file.close()


func change_scene_with_params(scene_path : String, params : Array):
	var loader = ResourceLoader.load_interactive(scene_path)
	if not loader: return
	
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
			break
		yield(get_tree(),"idle_frame")
