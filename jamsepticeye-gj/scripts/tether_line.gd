extends MeshInstance3D

@export var start_node: Node3D
@export var end_node: Node3D
@export var amplitude: float = 0.12             
@export var chaos: float = 0                 
@export var frequency: float = 4.0             
@export var segments: int = 180                
@export var thickness: float = 0.05          
@export var animate_speed: float = 2.0          
@export var bolt_color: Color = Color(0.5, 0.9, 1.5)
@export var glow_intensity: float = 10.0       
@export var branch_count: int = 2           
@export var noise_scale: float = 10.0          

@export var max_distance: float = 10
@export var max_chao: float = 0.3

var time_offsets: Array = []
var amplitude_offsets: Array = []
var frequency_offsets: Array = []
var side_offsets: Array = []
var noise: FastNoiseLite

func _ready():
	randomize()
	noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 1.2
	
	_initialize_lightning()
	_generate_lightning()

func _process(delta: float) -> void:
	if not start_node or not end_node:
		return
	for i in range(branch_count):
		time_offsets[i] += delta * animate_speed
	_generate_lightning()

func _initialize_lightning():
	time_offsets.clear()
	amplitude_offsets.clear()
	frequency_offsets.clear()
	side_offsets.clear()
	
	for i in range(branch_count):
		time_offsets.append(randf() * 10.0)
		amplitude_offsets.append(amplitude * randf_range(0.7, 1.3))
		frequency_offsets.append(frequency * randf_range(0.8, 1.2))
		side_offsets.append(randf_range(-thickness * 4.0, thickness * 4.0))

func _generate_lightning() -> void:
	if not start_node or not end_node:
		return
		
	var start_pos = global_transform.affine_inverse() * start_node.global_transform.origin + Vector3(0, 0.2, 0)
	var end_pos = global_transform.affine_inverse() * end_node.global_transform.origin + Vector3(0, 1.1, 0)

	var direction = end_pos - start_pos
	var length_vec = direction.length()
	var direction_norm = direction / length_vec

	var right = direction_norm.cross(Vector3.UP)
	if right.length_squared() < 0.001:
		right = direction_norm.cross(Vector3.RIGHT)
	right = right.normalized()
	var up = right.cross(direction_norm).normalized()

	var verts := PackedVector3Array()
	var uvs := PackedVector2Array()
	var indices := PackedInt32Array()

	for b in range(branch_count):
		var amp = amplitude_offsets[b]
		var freq = frequency_offsets[b]
		var t_offset = time_offsets[b]
		var side = side_offsets[b]

		var centers := []
		for i in range(segments + 1):
			var t := float(i) / float(segments)
			var pos = start_pos + direction * t

			# Hai đầu cố định tuyệt đối
			if i == 0:
				centers.append(start_pos)
				continue
			elif i == segments:
				centers.append(end_pos)
				continue

			# Giảm dần rung về 0 ở hai đầu
			var end_fade = clamp((t * (1.0 - t)) * 4.0, 0.0, 1.0)

			var base_wave = sin(t * freq * TAU + t_offset) * amp
			base_wave += sin(t * freq * 0.5 * TAU + t_offset * 1.7) * amp * 0.4
			base_wave += sin(t * freq * 1.8 * TAU + t_offset * 2.3) * amp * 0.3

			var n := noise.get_noise_3d(t * 3.0, t_offset * 0.4, b * 2.0)
			var n2 := noise.get_noise_3d(t * 6.0, t_offset * 1.1, b * 3.0)
			var offset_x = base_wave + (n + n2) * chaos + side
			var offset_y = (sin(t * freq * 0.7 * TAU + t_offset * 1.2) * amp * 0.6)
			offset_y += noise.get_noise_3d(t * 5.0, b * 2.5, t_offset) * chaos * 0.5

			var offset = (right * offset_x + up * offset_y) * end_fade
			centers.append(pos + offset)

		for i in range(segments):
			var a = centers[i]
			var b_point = centers[i + 1]

			var v0 = a + right * thickness
			var v1 = a - right * thickness
			var v2 = b_point + right * thickness
			var v3 = b_point - right * thickness

			var base = verts.size()
			verts.append_array([v0, v1, v2, v3])
			uvs.append_array([Vector2(0,0), Vector2(1,0), Vector2(0,1), Vector2(1,1)])
			indices.append_array([base, base+2, base+1, base+2, base+3, base+1])

	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = verts
	arrays[Mesh.ARRAY_TEX_UV] = uvs
	arrays[Mesh.ARRAY_INDEX] = indices

	var new_mesh := ArrayMesh.new()
	new_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)

	var mat := StandardMaterial3D.new()
	mat.depth_draw_mode = BaseMaterial3D.DEPTH_DRAW_DISABLED
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	mat.emission_enabled = true
	mat.emission = bolt_color
	mat.emission_energy_multiplier = glow_intensity
	mat.albedo_color = bolt_color
	mat.vertex_color_use_as_albedo = true

	new_mesh.surface_set_material(0, mat)
	mesh = new_mesh
