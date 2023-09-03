extends Node2D

var _speed = 1
var _orbit_radius = 150

@onready var _animated_sprite = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation -= _speed * delta
	
	_do_orbit_movement()

func _do_orbit_movement():
	var center = get_viewport_rect().size / 2
	
	# r = radius
	# t = angle in radians
	# (h,k) = center point
	# (x,y) = desired point on circle path
	
	# float x = r*cos(t) + h;
	# float y = r*sin(t) + k;
	
	# adjust rotation so pacman follows the circle path
	var adjusted_rotation = rotation - deg_to_rad(90)
	
	position = Vector2(
		_orbit_radius * cos(adjusted_rotation) + center.x,
		_orbit_radius * sin(adjusted_rotation) + center.y
	)

func _input(event):
	if not event is InputEventScreenTouch:
		return
	
	if event.is_pressed():
		_animated_sprite.play()
		return
	
	_animated_sprite.stop()
	_animated_sprite.set_frame_and_progress(2, 0)
