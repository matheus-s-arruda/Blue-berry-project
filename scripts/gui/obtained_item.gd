extends RichTextLabel

onready var timer := $Timer
onready var tween := $Tween

func _ready():
	tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 0.8)
	tween.interpolate_property(self, "rect_position", Vector2.ZERO, Vector2(0, -96), 0.8, Tween.TRANS_SINE)
	tween.start()
	timer.start(1.5)


func _on_Timer_timeout():
	tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 0.8)
	tween.interpolate_property(self, "rect_position", Vector2(0, -96), Vector2(0, -192), 0.8, Tween.TRANS_SINE)
	tween.start()
	
	yield(tween, "tween_all_completed")
	queue_free()
