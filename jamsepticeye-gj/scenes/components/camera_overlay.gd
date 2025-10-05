extends Node3D

@onready var canvas_overlay: Control = UIManager.canvas_overlay
@onready var linear_depth_effect: MeshInstance3D = $LinearDepthEffect

var show_linear_depth_tween: Tween = null
var is_linear_depth = false

func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("ghost_switch")):
		if(is_linear_depth):
			_linear_depth_tween(0)
			is_linear_depth = false
		else:
			_linear_depth_tween(1)
			is_linear_depth = true

func _linear_depth_tween(p_target_value: float, duration: float = 0.3) -> void:
	if(p_target_value == 1):
		linear_depth_effect.visible = true

	if show_linear_depth_tween != null and show_linear_depth_tween.is_valid():
		canvas_overlay._hide_ripple_effect()
		show_linear_depth_tween.kill()
	
	if(UIManager.ui_option.is_special_visual_effect_on):
		canvas_overlay._show_ripple_effect()
	var mat = linear_depth_effect.get_active_material(0)
	
	show_linear_depth_tween = create_tween()
	show_linear_depth_tween.tween_property(mat, "shader_parameter/mix_factor", p_target_value, duration)
	await show_linear_depth_tween.finished
	canvas_overlay._hide_ripple_effect()
	if(p_target_value == 0):
		linear_depth_effect.visible = false
