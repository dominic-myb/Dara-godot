extends ParallaxLayer
@export var LIGHT_SPEED = -50
func _process(delta):
	self.motion_offset.x += LIGHT_SPEED * delta
