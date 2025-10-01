@tool
extends Resource
class_name AudioWithTag

@export var file: AudioStream
@export var tag: String

func _get_property_list() -> Array:
	tag = file.resource_path.get_file().get_basename()
	return []
