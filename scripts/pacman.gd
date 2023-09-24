extends Node2D

var _rotation_speed_while_orbiting = 2
var _rotation_speed_while_shoot = 7

var _shoot_speed = 800
var _orbit_radius = 150

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
		
		move_back_to_center()
	
	if _is_orbiting:
		rotation -= _rotation_speed_while_orbiting * delta
		_do_orbit_movement()

func move_back_to_center():
	var screen_size = get_viewport_rect().size
	
	# relocate pacman if he is off screen
	
	if position.x < 0:
		position.x = screen_size.x
		position.y = screen_size.y - position.y
	
	if position.x > screen_size.x:
		position.x = 0
		position.y = screen_size.y - position.y
	
	if position.y < 0:
		position.y = screen_size.y
		position.x = screen_size.x - position.x
		
	if position.y > screen_size.y:
		position.y = 0
		position.x = screen_size.x - position.x
	
	# if pacman is at center again, stop moving
	
	var center = screen_size / 2
	var tolerance = Vector2(5,5)
	
	if position < center + tolerance && position > center - tolerance:
		position = center
		_is_moving_away = false
		_animated_sprite.set_frame_and_progress(0,0)
	

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
