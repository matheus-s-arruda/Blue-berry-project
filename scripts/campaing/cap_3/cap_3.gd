extends Spatial

const BULLET_PARTICLES = preload("res://scenes/campaing/cap_3/bullet_particles_3D.tscn")
const BLOOD_PARTICLES = preload("res://scenes/campaing/cap_3/blood_particles_3D.tscn")

var item = Constants.STATUS_ITEM.instance()
var player_life := 100

onready var player = $player_top_down_3D
onready var gui = $gui
onready var exit_win = $exit/Area/CollisionShape
onready var exit_mesh = $exit/MeshInstance
onready var animation = $AnimationPlayer
onready var audioplayer = $AudioStreamPlayer


func _ready():
	AudioSystem.dialogue_audio_nodes.append(audioplayer)
	audioplayer.volume_db = AudioSystem.volume_dialogue


func game_win():
	if Globals.save.history_progress < 3:
		Globals.save.history_progress = 3
		Globals.save_sv()
	
	exit_win.disabled = false
	exit_mesh.visible = true
	animation.play("win")
	gui.label_alert.emit_alert("Passe pela saida")


func game_lose():
	get_tree().call_group("enimy_3D", "disable")
	animation.play("lose")
	player.die()


func fade_in():
	gui.fade_anim.play("fade_in")


func reload_scene():
	var _err = get_tree().reload_current_scene()
 

func player_enable():
	player.can_move = true
	player.can_shoot = true
	gui.status_bar.add_child(item)
	animation.play("narrador_move_to_exit")


func emit_particles(transform_point : Transform, blood : bool):
	var p
	if blood: p = BLOOD_PARTICLES.instance()
	else: p = BULLET_PARTICLES.instance()
	
	add_child(p)
	p.global_transform = transform_point
	p.emitting = true
	yield(get_tree().create_timer(0.2, false), "timeout")
	p.queue_free()


func _on_player_top_down_3D_take_damage():
	player_life -= 10
	item.set_bar_value(float(player_life))
	if player_life <= 0:
		game_lose()
	else:
		AudioSystem.shot_audio(AudioSystem.PLAYER_HITTED[randi() % 2], AudioSystem.volume_effects)


func _on_Area_body_entered(_body):
	player.can_move = false
	player.can_shoot = false
	gui.fade_anim.play("fade_in")
	yield(get_tree().create_timer(1.0, false), "timeout")
	Globals.change_scene_with_params(Constants.LEVEL_SCENE_PATH[3], [])



