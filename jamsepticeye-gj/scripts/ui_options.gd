extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_return_button_down() -> void:
	UIManager.switch_ui(UIManager.previous_ui)
	pass # Replace with function body.
