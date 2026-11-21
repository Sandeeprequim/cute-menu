class_name Perspective

const VANISH := Vector2(320, 120)
const NEAR_Y := 300.0
const TRAVEL_TIME := 1.5

static func depth(p: float) -> float:
	return p * p

static func pos(x_near: float, p: float) -> Vector2:
	var t := depth(p)
	return Vector2(lerp(VANISH.x, x_near, t), lerp(VANISH.y, NEAR_Y, t))

static func scale_at(p: float) -> float:
	return lerp(0.1, 1.0, depth(p))
