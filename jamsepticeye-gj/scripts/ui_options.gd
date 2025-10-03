extends Control


# Called when the node enters the scene tree for the first time.
@onready var master_volume: HSlider = $MenuButtons/MasterVolume/HSlider
@onready var background_music_volume: HSlider = $MenuButtons/BackgroundMusicVolume/HSlider
@onready var sfx_volume: HSlider = $MenuButtons/SFXVolume/HSlider
@onready var vsync_checkbutton: CheckButton = $MenuButtons/VSYNC/CheckButton
@onready var resolution_option_button: OptionButton = $MenuButtons/Resolution/OptionButton
@onready var full_screen_toggle: CheckButton = $MenuButtons/FullScreen/CheckButton
@onready var scale_3d_slider: HSlider = $"MenuButtons/3DScaling/HSlider"

var resolutions = [
	Vector2(960, 540),
	Vector2(1280, 720),
	Vector2(1440, 810),
	Vector2(1920, 1080)
	]

func _ready() -> void:
	pass # Replace with function body.
	#Set true option value fist time
	master_volume.value = AudioManager.master_volume
	background_music_volume.value = AudioManager.background_music_volume
	sfx_volume.value = AudioManager.sound_effect_volume
	vsync_checkbutton.button_pressed = DisplayServer.window_get_vsync_mode()
	print(DisplayServer.window_get_vsync_mode())
	for i in range(resolutions.size()):
		var res = resolutions[i]
		resolution_option_button.add_item(str(int(res.x)) + " x " + str(int(res.y)))
	#resolution_option_button.selected = -1
	scale_3d_slider.value = get_viewport().scaling_3d_scale
	full_screen_toggle.button_pressed = DisplayServer.window_get_mode()



func _on_return_button_down() -> void:
	UIManager.switch_ui(UIManager.previous_ui)
	pass # Replace with function body.

func _on_MasterSlider_value_changed(value):
	AudioManager.set_master_volume(value)


func _on_MusicSlider_value_changed(value):
	AudioManager.set_background_music_volume(value)


func _on_SFXSlider_value_changed(value):
	AudioManager.set_sound_effect_volume(value)
	
func _on_VSYNC_checkbutton_toggle(toggle_on):
	if(toggle_on):
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func _on_FullSCreen_checkbutton_toggle(toggle_on):
	if(toggle_on):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(resolutions[clamp(resolution_option_button.selected, 0, resolutions.size()-1)])
		get_viewport().scaling_3d_scale = 1
		
func _on_OptionResolution_selected(index):
	DisplayServer.window_set_size(resolutions[index])
	#if(DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN):
		#get_viewport().scaling_3d_scale = resolutions[index].z
	#else:
		#get_viewport().scaling_3d_scale = 1

func _on_Option3DScaling_value_changed(value):
	get_viewport().scaling_3d_scale = value
