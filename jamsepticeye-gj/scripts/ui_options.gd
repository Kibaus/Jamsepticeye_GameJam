extends Control


# Called when the node enters the scene tree for the first time.
@onready var master_volume: HSlider = $MenuButtons/MasterVolume/HSlider
@onready var background_music_volume: HSlider = $MenuButtons/BackgroundMusicVolume/HSlider
@onready var sfx_volume: HSlider = $MenuButtons/SFXVolume/HSlider
@onready var vsync_checkbutton: CheckButton = $MenuButtons/VSYNC/CheckButton
@onready var resolution_option_button: OptionButton = $MenuButtons/Resolution/OptionButton
@onready var full_screen_toggle: CheckButton = $MenuButtons/FullScreen/CheckButton
@onready var scale_3d_slider: HSlider = $"MenuButtons/3DScaling/HSlider"
@onready var mouse_sensitive_slider: HSlider = $MenuButtons/MouseSensitivity/HSlider
@onready var special_visual_effect_checkbutton: CheckButton = $MenuButtons/SpecialVisualEffect/CheckButton

var mouse_sensitivity: int = 50

var is_special_visual_effect_on: bool = true

var resolutions = [
	Vector2(960, 540),
	Vector2(1280, 720),
	Vector2(1440, 810),
	Vector2(1920, 1080)
	]

func _ready() -> void:
	pass # Replace with function body.
	#Set true option value fist time
	#master_volume.value = AudioManager.master_volume
	
	
	#background_music_volume.value = AudioManager.background_music_volume
	#sfx_volume.value = AudioManager.sound_effect_volume
	#vsync_checkbutton.button_pressed = DisplayServer.window_get_vsync_mode()
	
	for i in range(resolutions.size()):
		var res = resolutions[i]
		resolution_option_button.add_item(str(int(res.x)) + " x " + str(int(res.y)))
	
	_on_ResetButton_pressed()
	
	#resolution_option_button.selected = -1
	#scale_3d_slider.value = get_viewport().scaling_3d_scale
	#full_screen_toggle.button_pressed = DisplayServer.window_get_mode()
	#mouse_sensitive_slider.value = mouse_sensitivity



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
	
func _on_MouseSensitivity_value_changed(value):
	if(value == 0):
		value += 1
	mouse_sensitivity = value
	
func _on_SpecialVisualEffct_toggle(toggle_on):
	is_special_visual_effect_on = toggle_on

func _on_ResetButton_pressed():
	full_screen_toggle.button_pressed = DisplayServer.window_get_mode()
	
	#Reset Master Volume
	AudioManager.master_volume = 1
	master_volume.value = AudioManager.master_volume
	
	#Reset Music Volume
	AudioManager.background_music_volume = 0
	background_music_volume.value = AudioManager.background_music_volume
	
	#Reset SFX Volume
	AudioManager.sound_effect_volume = 1
	sfx_volume.value = AudioManager.sound_effect_volume
	
	#Reset VSYNC
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	vsync_checkbutton.button_pressed = true
	
	#Reset 3D Scaling
	get_viewport().scaling_3d_scale = 1
	scale_3d_slider.value = get_viewport().scaling_3d_scale
	
	#Reset mouse sensitive
	mouse_sensitivity = 50
	mouse_sensitive_slider.value = mouse_sensitivity
	
	#Reset VFX
	is_special_visual_effect_on = true
	special_visual_effect_checkbutton.button_pressed = true
	
	
