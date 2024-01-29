extends BoneAttachment3D
class_name ProjectileSpawnLocation

signal NodeReady(spawnNode)

func _ready():
	NodeReady.emit(self)
