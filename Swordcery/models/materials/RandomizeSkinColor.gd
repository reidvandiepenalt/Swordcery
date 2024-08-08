extends MeshInstance3D

const Color1 = Color(0.61, 0.337, 0.181)
const Color2 = Color(0.639, 0.557, 0.455)

func _ready():
	randomize()
	var newMat = StandardMaterial3D.new()
	newMat.albedo_color = Color(randf_range(Color1.r, Color2.r), randf_range(Color1.g, Color2.g), randf_range(Color1.b, Color1.b))
	self.material_override = newMat
