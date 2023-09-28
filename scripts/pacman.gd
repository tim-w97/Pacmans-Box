extends Node2D

var _rotation_speed_while_orbiting = 2
var _rotation_speed_while_shoot = 7

var _shoot_speed = 800
var _orbit_radius = 150
var _offscreen_offset = 50

@onready var _animated_sprite = $AnimatedSprite2D

var _is_orbiting = false
var _is_moving_away = false

var _last_direction_angle

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _is_moving_away:
		var direction_vector = Vector2.from_angle(
			_last_direction_angle
		)
		
		position += direction_vector * delta * _shoot_speed
		rotation += _rotation_speed_while_shoot * delta
		
		reset_position()
	
	if _is_orbiting:
		rotation -= _rotation_speed_while_orbiting * delta
		_do_orbit_movement()

func reset_position():
	var screen_size = get_viewport_rect().size
	var center = screen_size / 2
	
	# if one of the following predicates is true, the pacman is offscreen
	var p1 = position.x > screen_size.x + _offscreen_offset
	var p2 = position.y > screen_size.y + _offscreen_offset
	var p3 = position.x < - _offscreen_offset
	var p4 = position.y < - _offscreen_offset
	
	if p1 or p2 or p3 or p4:
		_animated_sprite.set_frame_and_progress(0,0)
		_is_moving_away = false
		position = center

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
	
	_last_direction_angle = adjusted_rotation

func _shoot():
	_is_moving_away = true

func _input(event):
	if _is_moving_away:
		return
	
	if not event is InputEventScreenTouch:
		return
	
	if event.is_pressed():
		_animated_sprite.play()
		_is_orbiting = true
		return
	
	_is_orbiting = false
	
	_animated_sprite.stop()
	_animated_sprite.set_frame_and_progress(2,0)
	
	_shoot()

# if pacman collides with the box, stop moving
func _on_area_2d_area_entered(_area):
	_is_moving_away = false
