extends Node

static func ObstacleDetection(enemyPosition: Vector3 , targetPosition: Vector3, world: World3D):
	var query = PhysicsRayQueryParameters3D.create(enemyPosition, targetPosition, 0b1)
	return world.direct_space_state.intersect_ray(query)

static func CalcAvoidanceAngle(enemyPosition: Vector3 , targetPosition: Vector3, world: World3D):
	var obstacle = ObstacleDetection(enemyPosition, targetPosition, world)
	if !obstacle.collider: return 0
	var facingDir = targetPosition - enemyPosition
	var directionToObstacle = obstacle.position - enemyPosition
	var angleToObsDir = facingDir.signed_angle_to(directionToObstacle, facingDir)
	var angleScalar =  clampf(1 - directionToObstacle.length / 10.0, 0.0, 1.0)
	return angleScalar * (PI/2) * sign(angleToObsDir)
