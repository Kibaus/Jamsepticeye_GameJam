class_name Door

extends Marker3D

enum DoorGroup{
	Sun,
	Moon,
	Sword,
	Shield
}

var initial_position : Vector3

func _ready() -> void:
	initial_position = %Moveable.position

func open( animate : bool = true):
	if animate:
		var tween : Tween = get_tree().create_tween()
		tween.tween_property(%Moveable,"position",initial_position + Vector3(0,2,0),1)
	else:
		%Moveable.position.y = 2
	pass

func close(animate : bool = true):
	if animate:
		var tween : Tween = get_tree().create_tween()
		tween.tween_property(%Moveable,"position",initial_position,1)
	else:
		%Moveable.position.y = 0
	pass

func setup_symbols(texture):
	%Symbol1.texture = texture
	%Symbol2.texture = texture
