extends Spatial

var Item_val : int = 0 

onready var VicAnima : AnimationPlayer = $Hud/Vitoria/AnimaVi

func Vit():
	if Item_val == 3:
		VicAnima.play("Vit")

onready var gui : CanvasLayer = $gui



func _on_Anima_animation_finished(anim_name):
	get_tree().reload_current_scene()


func _on_AnimaVi_animation_finished(anim_name):
	get_tree().quit()
