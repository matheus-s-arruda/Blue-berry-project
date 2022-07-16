extends CanvasLayer

const OBTAINED_ITEM := preload("res://scenes/gui/obtained_item.tscn")

export var mouse_capture_mode := false

onready var dialogue := $ui/dialogue
onready var fade_anim : AnimationPlayer = $hud/fade/AnimationPlayer
onready var label_alert : Label = $hud/alert
onready var obtaioned_itens := $ui/obtained_itens
onready var status_bar : Control = $ui/status_bar
onready var pause = $pause_menu


func _ready():
	if mouse_capture_mode:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func set_obtained_item(text:String):
	var item = OBTAINED_ITEM.instance()
	item.bbcode_text = "Você adquiriu " + text + "!"
	obtaioned_itens.add_child(item)


func _input(_event):
	if Input.is_action_just_pressed("pause"):
		pause.visible = !pause.visible
		if pause.visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		elif mouse_capture_mode:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


