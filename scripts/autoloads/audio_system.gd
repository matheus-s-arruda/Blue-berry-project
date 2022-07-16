extends Node

const BUS_MASTER : AudioBusLayout = preload("res://assets/resources/default_bus_layout.tres")

const PLAYER_HITTED := ["res://assets/audio/player/boy hurt2.wav", "res://assets/audio/player/boy hurt.mp3"]
const PLAYER_DIE = "res://assets/audio/player/player die.wav"
const BULLET_LAZER = "res://assets/audio/bullet_lazer.wav"

const ENEMY_DYING = "res://assets/audio/inimigo mostro/enemy dying.wav"
const ENEMY_ROAR_1 = "res://assets/audio/inimigo mostro/roar1.wav"
const ENEMY_ROAR_2 = "res://assets/audio/inimigo mostro/roar2.wav"
const ENEMY_ROAR_3 = "res://assets/audio/inimigo mostro/roar3.wav"

const AUDIO_SHOT = preload("res://scenes/tools/audio_shot.tscn")

var idx = AudioServer.get_bus_index("Master")

var volume_master : float = Globals.save.volume_music
var volume_effects : float = Globals.save.volume_effects
var volume_dialogue : float = Globals.save.volume_dialogue setget update_dialogue_volume

var audio_nodes := {}
var dialogue_audio_nodes := []

func _ready():
	change_bus_volume_range(Globals.save.volume_master)


func change_bus_volume_range(volume_range : float):
	var volume = (clamp(volume_range, 0.0, 1.0) * 86.0) - 80.0
	AudioServer.set_bus_volume_db(idx, volume)
 

func shot_audio(audio_path : String, volume := volume_effects):
	var audio_node = AUDIO_SHOT.instance()
	add_child(audio_node)
	audio_node.stream = load(audio_path)
	audio_node.volume_db = volume
	audio_node.playing = true


func play(audio_path : String, volume := volume_effects):
	if audio_nodes.has(audio_path):
		if not audio_nodes[audio_path].is_playing():
			audio_nodes[audio_path].playing = true
			audio_nodes[audio_path].volume_db = volume
	else:
		var audio = AudioStreamPlayer.new()
		add_child(audio)
		audio.stream = load(audio_path)
		audio.volume_db = volume
		audio_nodes[audio_path] = audio
		audio.playing = true


func play_soundtrack(audio_path : String, volume := volume_master):
	print(audio_path, volume)


func update_dialogue_volume(value):
	volume_dialogue = value
	update_dialogue_audio_nodes()


func update_dialogue_audio_nodes():
	var size = dialogue_audio_nodes.size()
	var pointer := 0
	
	while true:
		if pointer >= size: break
		var node = dialogue_audio_nodes[pointer]
		
		if is_instance_valid(node):
			if node is AudioStreamPlayer3D:
				node.unit_db = volume_dialogue
				
			elif node is AudioStreamPlayer:
				node.volume_db = volume_dialogue
			
			pointer += 1
		else:
			dialogue_audio_nodes.remove(pointer)
			size -= 1



