extends Spatial

var has_key := false
var cap_progress := 0
var player_in_door := false

onready var anim_cinema := $"Viewport/cinema/AnimationPlayer"
onready var anim_cena_1 := $AnimationPlayer
onready var gui = $gui
onready var gui_control = $gui/Control


func _ready():
	gui.dialogue.connect("choise_answer", self, "dialogue_answer")


func top_1():
	gui.label_alert.emit_alert("Pressione ( ESQ ) para liberar o mouse")
	gui.dialogue.show_dialogue(PoolStringArray(["Quem é você?", "Eu conheço você de algum lugar..."]))


func top_2():
	gui.dialogue.show_dialogue(PoolStringArray(["Não tenho a minima idéia.", "Você é a godot?"]))


func top_3():
	gui.dialogue.show_dialogue(PoolStringArray(["Bom... oque fazemos agora?"]))


func top_4():
	gui.dialogue.show_dialogue(PoolStringArray(["Que porta?", "Que chave?"]))


func dialogue_answer(choise):
	match cap_progress:
		0:
			yield(get_tree().create_timer(0.5), "timeout")
			anim_cinema.play("top_2")
		1:
			yield(get_tree().create_timer(0.5), "timeout")
			if choise == 0:
				anim_cinema.play("top_3_a")
			elif choise == 1:
				anim_cinema.play("top_3_b")
		2:
			yield(get_tree().create_timer(0.5), "timeout")
			anim_cinema.play("top_4")
		3:
			yield(get_tree().create_timer(0.5), "timeout")
			if choise == 0:
				anim_cinema.play("top_5_a")
			elif choise == 1:
				anim_cinema.play("top_5_b")
			gui_control.vector_target = gui_control.KEY_INTERACTION_POSITION
			gui_control.interaction_text.text = "pegar chave"
		5:
			yield(get_tree().create_timer(0.5), "timeout")
	
	cap_progress += 1


func _on_door_body_entered(_body):
	player_in_door = true
	if has_key:
		$player.can_move = false
		anim_cena_1.play("door_open")


func _on_door_body_exited(_body):
	player_in_door = false



