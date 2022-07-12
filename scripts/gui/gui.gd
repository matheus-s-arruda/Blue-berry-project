extends CanvasLayer

const OBTAINED_ITEM := preload("res://scenes/gui/obtained_item.tscn")

onready var dialogue := $ui/dialogue
onready var label_alert : Label = $hud/alert
onready var obtaioned_itens := $ui/obtained_itens


func set_obtained_item(text:String):
	var item = OBTAINED_ITEM.instance()
	item.bbcode_text = "Você adquiriu " + text + "!"
	obtaioned_itens.add_child(item)
	



