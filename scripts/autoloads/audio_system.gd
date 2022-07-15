extends Node


const ENEMY_ROAR_1 = "res://assets/audio/inimigo mostro/roar1.wav"
const ENEMY_ROAR_2 = "res://assets/audio/inimigo mostro/roar2.wav"
const ENEMY_ROAR_3 = "res://assets/audio/inimigo mostro/roar3.wav"
const BULLET_LAZER = "res://assets/audio/bullet_lazer.wav"

const AUDIO_SHOT = preload("res://scenes/tools/audio_shot.tscn")

var audio_nodes := {}
var volume_master := -10


func shot_audio(audio_path : String, volume := volume_master):
	var audio_node = AUDIO_SHOT.instance()
	add_child(audio_node)
	audio_node.stream = load(audio_path)
	audio_node.volume_db = volume
	audio_node.playing = true


func play(audio_path : String, volume := volume_master):
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

