extends Spatial

onready var gui : CanvasLayer = $gui

func his1():
	gui.label_alert.emit_alert("Pressione ( ESQ ) para liberar o mouse")
	gui.dialogue.show_dialogue(PoolStringArray(["kkkkk só capa"]))

