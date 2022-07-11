extends Spatial


var player_in_door := false

onready var anim_cena_1 := $AnimationPlayer
onready var gui = $gui


func top_1():
	gui.label_alert.emit_alert("Pressione ( ESQ ) para liberar o mouse")
	gui.dialogue.show_dialogue(PoolStringArray(["Quem é você?", "Eu conheço você de algum lugar..."]))
	gui.dialogue.connect("choise_answer", self, "dialogue_answer", [], CONNECT_ONESHOT)


func dialogue_answer(choise):
	print(choise)


func _on_door_body_entered(body):
	player_in_door = true


func _on_door_body_exited(body):
	player_in_door = false



