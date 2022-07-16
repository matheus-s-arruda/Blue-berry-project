extends Node2D

const CAMERA_INITIAL_POS := Vector2(960, 540)

export var narrador_look_at_player := false
export var shake_camera := false

var cap_progress := 0
var last_choise_path := 0

onready var camera := $Camera2D
onready var player := $player_2d
onready var narrador := $narrador
onready var animation := $AnimationPlayer
onready var gui := $gui
onready var audioplayer = $AudioStreamPlayer


func _ready():
	AudioSystem.dialogue_audio_nodes.append(audioplayer)
	audioplayer.volume_db = AudioSystem.volume_dialogue
	gui.dialogue.connect("choise_answer", self, "dialogue_answer")


func _process(_delta):
	if narrador_look_at_player:
		var d = narrador.rect_global_position.direction_to(player.global_position)
		narrador.eye_direction(d * 6.0)
	if shake_camera:
		camera.position = CAMERA_INITIAL_POS + (Vector2(randf() - 0.5, randf() - 0.5) * 15.0)


func start():
	gui.label_alert.emit_alert("Movimente usando (W, A, S, D) ou setas")


func top_1():
	gui.dialogue.show_dialogue(PoolStringArray(["Onde eu estou?"]))


func top_3():
	gui.dialogue.show_dialogue(PoolStringArray(["Ok... e agora?"]))


func top_4():
	gui.dialogue.show_dialogue(PoolStringArray(["Oque!? você está ficando louco? O.O", "Finalmente! haha, onde estão as armas?"]))


func top_5():
	gui.dialogue.show_dialogue(PoolStringArray(["Oque é isso?"]))


func top_6():
	if last_choise_path == 0:
		gui.dialogue.show_dialogue(PoolStringArray(["Isso não é uma arma, isso é uma caixa!"]))
	elif last_choise_path == 1:
		gui.dialogue.show_dialogue(PoolStringArray(["Eu quero uma arma de verdade!"]))


func top_7():
	if last_choise_path == 0:
		gui.dialogue.show_dialogue(PoolStringArray(["paia..."]))
	elif last_choise_path == 1:
		gui.dialogue.show_dialogue(PoolStringArray(["Era disso que eu tava falando >:D"]))


func dialogue_answer(choise):
	match cap_progress:
		0:
			animation.play("top_1")
		1:
			animation.play("top_2")
		2:
			yield(get_tree().create_timer(0.5), "timeout")
			animation.play("top_3")
		3:
			if choise == 0:
				last_choise_path = 0
				animation.play("top_4_a")
			elif choise == 1:
				last_choise_path = 1
				animation.play("top_4_b")
		4:
			animation.play("top_5")
		5:
			animation.play("top_6")
		6:
			player.can_move = false
			var tween := Tween.new()
			add_child(tween)
			
			if last_choise_path == 0:
				player.look_at_mouse = false
				var s = player.shadow
				var ps = s.rect_global_position
				player.remove_child(s)
				add_child(s)
				$narrador.change_emotion($narrador.Emotions.ANGRY)
				
				s.rect_global_position = ps + Vector2(32, 8)
				var _res = tween.interpolate_property($narrador_hand4, "rect_position", $narrador_hand4.rect_position,
						player.position + Vector2(-50, -220), 1.0, Tween.TRANS_SINE)
				_res = tween.start()
				yield(tween, "tween_completed")
				$narrador_hand2.rect_position = $narrador_hand4.rect_position
				$narrador_hand4.visible = false
				
				_res = tween.interpolate_property($narrador_hand2, "rect_position", $narrador_hand2.rect_position,
						$narrador_hand2.rect_position + Vector2(0, -300), 0.5, Tween.TRANS_QUAD)
				_res = tween.interpolate_property(player, "position", player.position,
						player.position + Vector2(0, -300), 0.5, Tween.TRANS_QUAD)
				_res = tween.interpolate_property(s, "rect_scale", s.rect_scale,
						Vector2.ZERO, 0.5)
				_res = tween.start()
				
				yield(tween, "tween_completed")
				yield(get_tree().create_timer(0.5), "timeout")
				
				_res = tween.interpolate_property($narrador_hand2, "rect_position", $narrador_hand2.rect_position,
						$narrador_hand2.rect_position + Vector2(2000, 0), 1.0, Tween.TRANS_QUAD)
				_res = tween.interpolate_property(player, "position", player.position,
						player.position + Vector2(2000, 0), 1.0, Tween.TRANS_QUAD)
				_res = tween.interpolate_property(player, "rotation_degrees", player.rotation_degrees,
						30, 1.0, Tween.TRANS_SINE)
				_res = tween.start()
				
			elif last_choise_path == 1:
				$blocks/CollisionShape.disabled = true
				player._move.x = player.SPEED 
			
			var _res = tween.interpolate_property($narrador, "rect_position", $narrador.rect_position,
					$narrador.rect_position + Vector2(2000, 0), 1.0, Tween.TRANS_QUAD)
			_res = tween.start()
			
			$AnimationPlayer2.play("vamos")
			$gui.fade_anim.play("fade_in")
			yield(get_tree().create_timer(1.0), "timeout")
			
			var call1 = Constants.CallExecutioner.new(false, "entry_style", last_choise_path + 1)
			Globals.change_scene_with_params("res://scenes/campaing/cap_2/cap_2_action.tscn", [call1])
			
	cap_progress += 1


func weapon_merge():
	for c in $weapon.get_children():
		if c is Panel:
			c.visible = true
	$weapon/AnimationPlayer.play("merge")


func _on_Area2D_body_entered(_body):
	top_7()
	$player_2d.look_at_mouse = true
	$weapon.queue_free()
	$get_weapon.queue_free()
	gui.set_obtained_item("[color=#990909]Arma[/color]")




