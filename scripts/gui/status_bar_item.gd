extends Control

var is_ready := false

onready var label := $Label
onready var bar := $ProgressBar


func _ready():
	is_ready = true


func set_text(text : String):
	if not is_ready:
		yield(self, "ready")
	label.text = text

func set_bar_value(value : float, change_color := false, color := Color("#8b2626")):
	if not is_ready:
		yield(self, "ready")
	
	bar.value = value
	if change_color:
		bar.get_stylebox("fg").bg_color = color
