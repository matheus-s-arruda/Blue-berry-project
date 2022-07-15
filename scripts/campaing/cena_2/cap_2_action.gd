extends Node2D


const ENEMY := preload("res://scenes/campaing/cap_2/enemy_2D.tscn")
const SPAWN_LOCATIONS := [Vector2(3300, 460), Vector2(3300, 1030), Vector2(3300, 1940)]
const HORDE_SPAWN_PROGRESS := [6, 7, 8, 10, 10, 15, 15, 20, 20, 25, 30]
const HORDE_SPEED := [250, 300, 300, 350, 400, 400, 450, 500, 600, 700]

var progress := 0
var entry_style := 2

var is_game_end := false
var player_life := 100
var item = Constants.STATUS_ITEM.instance()

onready var tween := $Tween
onready var player := $YSort/player_2d
onready var hand_1 := $narrador_hand2
onready var hand_2 := $narrador_hand
onready var narrador := $narrador
onready var gui := $gui
onready var animation := $AnimationPlayer


func _ready():
	narrador.player = player
	player.can_move = false
	player.shadow.visible = false
	
	if entry_style == 1:
		yield(get_tree().create_timer(0.5, false), "timeout")
		var _err = tween.interpolate_property(hand_1, "rect_position", hand_1.rect_position, Vector2(800, 250), 1.5, Tween.TRANS_QUAD)
		_err = tween.interpolate_property(player, "position", player.position, Vector2(850, 470), 1.5, Tween.TRANS_QUAD)
		_err = tween.interpolate_property(player, "rotation_degrees", player.rotation_degrees, 0, 1.5, Tween.TRANS_QUAD)
		tween.start()
		
		yield(get_tree().create_timer(2.0, false), "timeout")
		hand_2.rect_position = hand_1.rect_position
		hand_1.visible = false
		
		_err = tween.interpolate_property(player, "position", player.position, Vector2(player.position.x, 900), 0.5, Tween.TRANS_SINE, Tween.EASE_IN)
		tween.start()
		
		yield(get_tree().create_timer(0.3, false), "timeout")
		_err = tween.interpolate_property(hand_2, "rect_position", hand_2.rect_position, Vector2(hand_2.rect_position.x, -200), 1.0, Tween.TRANS_QUAD)
		tween.start()
		
		player.shadow.visible = true
		yield(get_tree().create_timer(0.5), "timeout")
		player.look_at_mouse = true
		
	elif entry_style == 2:
		yield(get_tree().create_timer(0.5, false), "timeout")
		player._move.x = 1
		player.look_at_mouse = true
		player.rotation_degrees = 0
		var _err = tween.interpolate_property(player, "position", player.position, Vector2(500, 700), 1.5)
		tween.start()
		
		yield(get_tree().create_timer(1.5, false), "timeout")
		
	player.can_move = true
	gui.label_alert.emit_alert("Atire com ( Botão Direito do mouse )")


func advance_progress():
	progress += 1
	if progress >= 10:
		game_win()
		return
	
	gui.label_alert.emit_alert("horda " + str(progress) + "/10")
	spawn_enemies()


func spawn_enemies():
	for i in HORDE_SPAWN_PROGRESS[progress]:
		var enemy = ENEMY.instance()
		enemy.player = player
		enemy.max_speed = HORDE_SPEED[progress]
		$YSort.call_deferred("add_child", enemy)
		enemy.global_position = SPAWN_LOCATIONS[i % 3]
		yield(get_tree().create_timer(0.2, false), "timeout")


func game_win():
	if is_game_end: return
	is_game_end = true
	
	if Globals.save.history_progress < 2:
		Globals.save.history_progress = 2
		Globals.save_sv()
	
	item.visible = false
	player.can_move = false
	player.can_shoot = false
	yield(get_tree().create_timer(0.3, false), "timeout")
	player.look_at_mouse = false
	narrador.look_at_player = true
	narrador.change_emotion(narrador.Emotions.NORMAL)
	
	var dir = player.position.direction_to(Vector2(2880, 1030))
	
	if dir.x > 0:
		tween.interpolate_property(narrador, "rect_position", narrador.rect_position, player.position + Vector2(50, -500), 1.0, Tween.TRANS_SINE, Tween.EASE_OUT)
		tween.start()
		yield(get_tree().create_timer(0.5, false), "timeout")
		animation.play("win")
		
		yield(get_tree().create_timer(1.0, false), "timeout")
		
		tween.interpolate_property(narrador, "rect_position", narrador.rect_position, Vector2(3880, 950), 1.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		
		var time = player.position.distance_to(Vector2(2880, 1030)) / 800.0
		tween.interpolate_property(player, "position", player.position, Vector2(2880, 1000), time)
		tween.start()
		
		player._move = dir
	
	yield(get_tree().create_timer(0.5, false), "timeout")
	gui.fade_anim.play("fade_in")
	
	yield(get_tree().create_timer(1.0, false), "timeout")
	var _err = get_tree().change_scene("res://scenes/main/main.tscn")


func game_lose():
	if is_game_end: return
	is_game_end = true
	
	player.can_shoot = false
	player.can_move = false
	player.dead = true
	
	get_tree().call_group("enemy_2d", "desative_self")
	gui.fade_anim.play("fade_in")
	
	yield(get_tree().create_timer(1.0, false), "timeout")
	var _err = get_tree().reload_current_scene()


func _on_start_body_entered(_body):
	$start.queue_free()
	yield(get_tree().create_timer(0.5, false), "timeout")
	advance_progress()
	gui.status_bar.add_child(item)


func _on_player_2d_suffered_damage():
	player_life -= 17
	item.set_bar_value(float(player_life))
	
	if player_life <= 0:
		game_lose()
	else:
		AudioSystem.shot_audio(AudioSystem.PLAYER_HITTED[randi() % 2], AudioSystem.volume_effects)



