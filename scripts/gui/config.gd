extends Panel


onready var v_master = $VBoxContainer/volume_master/volume_master
onready var v_music = $VBoxContainer/volume_music/volume_music
onready var v_dialog = $VBoxContainer/volume_dialogue/volume_dialogue
onready var v_effects = $VBoxContainer/volume_effecs/volume_effecs


func _ready():
	v_master.value = Globals.save.volume_master
	v_music.value = calc_range_by_volume(Globals.save.volume_music)
	v_dialog.value = calc_range_by_volume(Globals.save.volume_dialogue)
	v_effects.value = calc_range_by_volume(Globals.save.volume_effects)


func calc_volume_range(v_range : float):
	return ((clamp(v_range, 0.0, 1.0) * 60.0) -50)


func calc_range_by_volume(volume : float):
	return ((clamp(volume, -50, 10) + 50) / 60)


func _vslider_end_edit(event : InputEvent):
	if event.is_action_released("mouse_click"):
		Globals.save.volume_music = calc_volume_range(v_music.value)
		Globals.save.volume_effects = calc_volume_range(v_effects.value)
		Globals.save.volume_dialogue = calc_volume_range(v_dialog.value)
		
		Globals.save.volume_master = v_master.value
		AudioSystem.change_bus_volume_range(v_master.value)
		
		AudioSystem.volume_master = Globals.save.volume_music
		AudioSystem.volume_dialogue = Globals.save.volume_dialogue
		AudioSystem.volume_effects = Globals.save.volume_effects
		Globals.save_sv()


func _on_cancel_config_pressed():
	get_parent().visible = false
