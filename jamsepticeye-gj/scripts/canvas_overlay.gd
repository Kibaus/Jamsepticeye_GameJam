extends Control

@onready var ripple_effect: ColorRect = $RippleEffect
@onready var vignette_effect: ColorRect = $VignetteEffect


func _show_ripple_effect():
	pass
	ripple_effect.visible = true


func _hide_ripple_effect():
	pass
	ripple_effect.visible = false

func _show_vignette_effect():
	pass
	vignette_effect.visible = true

func _hide_vignette_effect():
	pass
	vignette_effect.visible = false
