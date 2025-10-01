extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_play_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	UIManager.switch_ui(UIManager.UI.ingame)

func _on_options_button_down() -> void:
	UIManager.switch_ui(UIManager.UI.options)

func _on_exit_button_down() -> void:
	get_tree().quit()
