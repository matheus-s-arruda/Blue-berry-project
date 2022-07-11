extends Spatial




onready var gui = $gui


func top_1():
	gui.label_alert.emit_alert("Pressione ( ESQ ) para liberar o mouse")
	gui.dialogue.show_dialogue(PoolStringArray(["Quem é vocẽ?", "Eu conheço você de algum lugar..."]))
