extends Node
#handles global game functionality
var current_player
var current_enemy : Enemy
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func Set_active_player(player):
	current_player = player
	
func Set_active_enemy(enemy):
	current_enemy = enemy
