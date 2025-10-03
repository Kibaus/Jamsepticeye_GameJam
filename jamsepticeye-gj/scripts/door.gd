class_name Door

extends RigidBody3D

enum DoorGroup{
	Sun,
	Moon,
	Sword,
	Shield
}

var initial_position : Vector3

func _ready() -> void:
	initial_position = position

func open( animate : bool = true):
	if animate:
		var tween : Tween = get_tree().create_tween()
		tween.tween_property(self,"position",initial_position + Vector3(0,2,0),1)
	else:
		position.y = 2
	pass

func close(animate : bool = true):
	if animate:
		var tween : Tween = get_tree().create_tween()
		tween.tween_property(self,"position",initial_position,1)
	else:
		position.y = 0
	pass
